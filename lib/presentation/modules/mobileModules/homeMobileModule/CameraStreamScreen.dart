import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:camera/camera.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:license_plate_detector/presentation/modules/mobileModules/homeMobileModule/HomeMobileScreen.dart';
import 'package:license_plate_detector/shared/adaptive/loadingIndicator/LoadingIndicator.dart';
import 'package:license_plate_detector/shared/components/Components.dart';
import 'package:license_plate_detector/shared/components/Constants.dart';
import 'package:license_plate_detector/shared/cubits/appCubit/AppCubit.dart';
import 'package:license_plate_detector/shared/cubits/appCubit/AppStates.dart';
import 'package:license_plate_detector/shared/styles/Colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class CameraStreamScreen extends StatefulWidget with WidgetsBindingObserver{
  const CameraStreamScreen({super.key});

  @override
  State<CameraStreamScreen> createState() => _CameraStreamScreenState();
}

class _CameraStreamScreenState extends State<CameraStreamScreen> {

  late AppLifecycleListener listener;
  late CameraController controller;
  Timer? timer;
  int secondsRemain = 5;
  bool timeIsStarted = false;


  double scaleX(double x, BuildContext context, CameraController controller) {
    double screenWidth = MediaQuery.of(context).size.width;
    double previewWidth = controller.value.previewSize!.height; // Adjusted for portrait
    double scale = screenWidth / previewWidth;

    return x * scale;
  }

  double scaleY(double y, BuildContext context, CameraController controller) {
    double screenHeight = MediaQuery.of(context).size.height;
    double previewHeight = controller.value.previewSize!.width; // Adjusted for portrait
    double scale = screenHeight / previewHeight;

    return y * scale;
  }

  double scaleWidth(double width, BuildContext context, CameraController controller) {
    double screenWidth = MediaQuery.of(context).size.width;
    double previewWidth = controller.value.previewSize!.height; // Adjusted for portrait
    double scale = screenWidth / previewWidth;

    return width * scale;
  }

  double scaleHeight(double height, BuildContext context, CameraController controller) {
    double screenHeight = MediaQuery.of(context).size.height;
    double previewHeight = controller.value.previewSize!.width; // Adjusted for portrait
    double scale = screenHeight / previewHeight;

    return height * scale;
  }

  void startTiming() {

    setState(() {timeIsStarted = true;});

    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if(secondsRemain > 0) {
        setState(() {
          secondsRemain--;
        });
      } else {
        t.cancel();
        setState(() {
          timeIsStarted = false;
          secondsRemain = 5;
        });
        AppCubit.get(context).clearDetectionResult();
      }
    });

  }

  Future<String> saveImageToFile(Uint8List imageBytes) async {
    final Directory dir = await getApplicationDocumentsDirectory();

    final String randomName = generateRandomString(10);
    final String filePath = '${dir.path}/$randomName.jpg';

    final File file = File(filePath);
    await file.writeAsBytes(imageBytes);

    return filePath;
  }

  String generateRandomString(int length) {
    const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final Random random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  void startStreaming() {
    controller.startImageStream((CameraImage image) async {
      if (!mounted || AppCubit.get(context).isProcessing) return;  // Guard Statement

      if(AppCubit.get(context).detections.isEmpty) {

        AppCubit.get(context).updateProcessState(true);

        try {
          // Convert frame to JPEG or PNG format
          final frameBytes = await compute(convertImageToBytes, image);
          final imagePath = await saveImageToFile(frameBytes);

          if (!mounted) return;
          AppCubit.get(context).uploadImageAndGetDetectionsResult(
            imagePath: imagePath,
          );

          if (AppCubit.get(context).detections.isNotEmpty) {
            await HapticFeedback.vibrate();
            startTiming();
          } else {
            AppCubit.get(context).updateProcessState(false);
          }

        } catch (error, stackTrace) {

          if(!mounted) return;
          showFlutterToast(
            message: 'Error in image stream processing: $error',
            state: ToastStates.error,
            context: context,
            seconds: 5,
          );

          if (kDebugMode) {
            print('Error in image stream processing: $error');
            print(stackTrace);
          }

          AppCubit.get(context).updateProcessState(false);
          clearProcess();

        }

      }

    });
  }


  void initializeCamera() {
    controller = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );

    controller.initialize().then((_) {
      if (!mounted) return;

      if (cameras[0].sensorOrientation == 90 || cameras[0].sensorOrientation == 270) {
        controller.lockCaptureOrientation(DeviceOrientation.landscapeRight);
      } else {
        controller.lockCaptureOrientation(DeviceOrientation.portraitUp);
      }

      setState(() {});
      startStreaming();

    }).catchError((error) {

      if(!mounted) return;
      showFlutterToast(
        message: 'Error initializing camera: $error',
        state: ToastStates.error,
        context: context,
        seconds: 5,
      );

      if (kDebugMode) {
        print('Error initializing camera: $error');
      }
    });

  }


  void clearProcess() {
    AppCubit.get(context).clearDetectionResult();
    timer?.cancel();
    setState(() {
      timeIsStarted = false;
      secondsRemain = 5;
    });
  }


  @override
  void initState() {
    super.initState();

    listener = AppLifecycleListener(
      onStateChange: (AppLifecycleState state) {
        if (state == AppLifecycleState.resumed) {
          if (!controller.value.isInitialized) {
            initializeCamera();
          }
        } else if (state ==  AppLifecycleState.paused || state == AppLifecycleState.inactive) {
          controller.stopImageStream();
          clearProcess();

          if(!mounted) return;
          navigateAndNotReturn(context: context, screen: HomeMobileScreen());
        }
      },
    );

    initializeCamera();
  }

  @override
  void dispose() {
    controller.dispose();
    listener.dispose();
    timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final ThemeData theme = Theme.of(context);
      final bool isDarkTheme = theme.brightness == Brightness.dark;

      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: isDarkTheme ? darkBackground : lightBackground,
          statusBarIconBrightness:
              isDarkTheme ? Brightness.light : Brightness.dark,
          systemNavigationBarColor:
              isDarkTheme ? darkBackground : lightBackground,
          systemNavigationBarIconBrightness:
              isDarkTheme ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDarkTheme ? Brightness.light : Brightness.dark,
        ),
      );

      return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);

          return PopScope(
            canPop: true,
            onPopInvokedWithResult: (didPop, result) {
              clearProcess();
            },
            child: Scaffold(
              body: SafeArea(
                child: ConditionalBuilder(
                  condition: controller.value.isInitialized,
                  builder: (context) => GestureDetector(
                    onTap: () {
                      clearProcess();
                    },
                    child: Stack(
                      children: [
                        SizedBox.expand(
                            child: ZoomIn(
                                duration: Duration(seconds: 1),
                                child: CameraPreview(controller))),
                        ZoomIn(
                          duration: Duration(milliseconds: 1500),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                tooltip: 'Cancel',
                                enableFeedback: true,
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                      isDarkTheme
                                          ? Colors.grey.shade800
                                          : Colors.grey.shade300),
                                ),
                                onPressed: () {
                                  clearProcess();
                                  controller.stopImageStream();
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: isDarkTheme ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        for (var detection in cubit.detections) ...[
                          Positioned(
                            left: scaleX(detection['x'], context, controller),
                            top: scaleY(detection['y'], context, controller),
                            child: ZoomIn(
                              duration: Duration(milliseconds: 500),
                              child: Container(
                                width: scaleWidth(
                                    detection['width'], context, controller),
                                height: scaleHeight(
                                    detection['height'], context, controller),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: (detection['status'] == 'Authorized')
                                          ? greenColor
                                          : redColor,
                                      width: 2.2),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                        ],

                        if(timeIsStarted) ... [

                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: FadeInUp(
                                duration: Duration(milliseconds: 500),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 12.0,
                                    horizontal: 16.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: isDarkTheme ? Colors.grey.shade800 : Colors.grey.shade300,
                                  ),
                                  child: Text.rich(
                                    TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Restarting in: ',
                                          ),
                                          TextSpan(
                                            text: '$secondsRemain',
                                            style: TextStyle(
                                              color: lightPrimary,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ]
                                    ),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ] else ...[

                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: ZoomIn(
                                    child: LoadingIndicator(os: getOs()))),
                          )
                        ],
                      ],
                    ),
                  ),
                  fallback: (context) =>
                      Center(child: LoadingIndicator(os: getOs())),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

Future<Uint8List> convertImageToBytes(CameraImage image) async {
  // Create an empty image buffer
  final img.Image convertedImage =
      img.Image(width: image.width, height: image.height);

  // Fill the image buffer from the YUV420 data
  final plane = image.planes[0];
  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      final int uvIndex =
          (y ~/ 2) * (image.planes[1].bytesPerRow ~/ 2) + (x ~/ 2);

      final int yValue = plane.bytes[y * plane.bytesPerRow + x];
      final int uValue = image.planes[1].bytes[uvIndex];
      final int vValue = image.planes[2].bytes[uvIndex];

      // Convert YUV to RGB
      final int r =
          (yValue + (1.370705 * (vValue - 128))).toInt().clamp(0, 255);
      final int g =
          (yValue - (0.698001 * (vValue - 128)) - (0.337633 * (uValue - 128)))
              .toInt()
              .clamp(0, 255);
      final int b =
          (yValue + (1.732446 * (uValue - 128))).toInt().clamp(0, 255);

      // Set pixel color
      convertedImage.setPixel(x, y, img.ColorRgb8(r, g, b));
    }
  }

  // Check if the width is greater than the height
  img.Image finalImage = convertedImage;
  if (convertedImage.width > convertedImage.height) {
    // Rotate the image 90 degrees
    finalImage = img.copyRotate(convertedImage, angle: 90);
  }

  // Encode the image to JPEG
  return Uint8List.fromList(img.encodeJpg(finalImage));
}
