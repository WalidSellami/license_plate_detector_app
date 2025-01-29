import 'package:animate_do/animate_do.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:license_plate_detector/data/models/dataModel/DataModel.dart';
import 'package:license_plate_detector/shared/adaptive/loadingIndicator/LoadingIndicator.dart';
import 'package:license_plate_detector/shared/components/Components.dart';
import 'package:license_plate_detector/shared/components/Constants.dart';
import 'package:license_plate_detector/shared/components/Extensions.dart';
import 'package:license_plate_detector/shared/cubits/appCubit/AppCubit.dart';
import 'package:license_plate_detector/shared/cubits/appCubit/AppStates.dart';
import 'package:license_plate_detector/shared/styles/Colors.dart';

class EditItemWebScreen extends StatefulWidget {

  final LicensePlateData? data;

  const EditItemWebScreen({super.key, required this.data});

  @override
  State<EditItemWebScreen> createState() => _EditItemWebScreenState();
}

class _EditItemWebScreenState extends State<EditItemWebScreen> {

  final TextEditingController pltNumberController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final FocusNode focusNode = FocusNode();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {});
    });
    pltNumberController.addListener(() {
      setState(() {});
    });

    pltNumberController.text = widget.data?.plateNumber ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    pltNumberController.dispose();
    pltNumberController.removeListener(() {
      setState(() {});
    });
    focusNode.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final ThemeData theme = Theme.of(context);
      final bool isDarkTheme = isDarkThemeApplied(context);

      return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {

          var cubit = AppCubit.get(context);

          if(state is SuccessEditLicensePlateAppState) {
            showFlutterToast(message: 'Done with success', state: ToastStates.success, context: context);
            setState(() {isLoading = false;});
            cubit.getLicensePlates();
            Navigator.pop(context);
            if(cubit.imageUploaded != null) {
              Future.delayed(Duration(milliseconds: 500)).then((value) {
                cubit.clearData();
              });
            }
          }

          if(state is ErrorEditLicensePlateAppState) {
            showFlutterToast(message: state.error.toString(), state: ToastStates.error, context: context, seconds: 5);
            setState(() {isLoading = false;});
          }

          if(state is ErrorUploadImageToServerAppState) {
            showFlutterToast(message: state.error.toString(), state: ToastStates.error, context: context, seconds: 5);
            setState(() {isLoading = false;});
          }

          if(state is ErrorGetImageAppState) {
            showFlutterToast(message: state.error.toString(), state: ToastStates.error, context: context, seconds: 5);
            setState(() {isLoading = false;});
          }

        },
        builder: (context, state) {
          var cubit = AppCubit.get(context);

          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(65.0),
              child: AppBar(
                leading: SizedBox.shrink(),
                flexibleSpace: PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: defaultAppBar(
                      onPress: () {
                        Navigator.pop(context);
                      },
                      icon: Icons.close_rounded,
                      size: 30.0,
                    ),
                  ),
                ),
              ),
            ),
            body: Center(
              child: FadeInUp(
                duration: Duration(milliseconds: 500),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: 50.0,
                      vertical: 12.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    elevation: 8.0,
                    color: isDarkTheme ? darkColor1 : Colors.white,
                    surfaceTintColor: isDarkTheme ? darkPrimary : Colors.white,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(26.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Text(
                                'Edit Item',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.4,
                                ),
                              ),
                              42.0.vrSpace,
                              Container(
                                width: MediaQuery.of(context).size.width / 2.4,
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: (focusNode.hasFocus)
                                      ? Border.all(
                                      width: 1.0,
                                      color: isDarkTheme
                                          ? Colors.white
                                          : Colors.black)
                                      : null,
                                  color: isDarkTheme
                                      ? HexColor('2A313A')
                                      : Colors.grey.shade100,
                                ),
                                child: defaultTextFormField(
                                    isDarkTheme: isDarkTheme,
                                    controller: pltNumberController,
                                    focusNode: focusNode,
                                    hintText: 'Plate Number',
                                    isWithBorder: false,
                                    prefixIcon: Icons.numbers_rounded,
                                    onComplete: () {
                                      FocusScope.of(context).nextFocus();
                                    },
                                    validate: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Plate Number must not be empty';
                                      }
                                      return null;
                                    }),
                              ),
                              30.0.vrSpace,
                              ZoomIn(
                                duration: Duration(milliseconds: 500),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: InkWell(
                                    onTap: () {
                                      showFullImage(widget.data?.image, context, isDarkTheme);
                                    },
                                    mouseCursor: SystemMouseCursors.click,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                        border: Border.all(
                                          width: 0.0,
                                          color: isDarkTheme ? Colors.white : Colors.black,
                                          style: BorderStyle.solid,
                                          strokeAlign: BorderSide.strokeAlignOutside,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.network(
                                          widget.data?.image ?? '',
                                          width: 125.0,
                                          height: 125.0,
                                          fit: BoxFit.cover,
                                          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                            if(frame == null) {
                                              return shimmerImageLoading(
                                                  width: 125.0,
                                                  height: 125.0,
                                                  radius: 8.0,
                                                  theme: theme,
                                                  isDarkTheme: isDarkTheme);
                                            }
                                            return FadeIn(
                                                duration: Duration(milliseconds: 300),
                                                child: child);
                                          },
                                          errorBuilder: (context, error, stackTrace) {
                                            return SizedBox(
                                              width: 125.0,
                                              height: 125.0,
                                              child: Center(
                                                child: Icon(
                                                  Icons.error_outline_rounded,
                                                  size: 28.0,
                                                  color: isDarkTheme ? Colors.white : Colors.black,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              30.0.vrSpace,
                              if(cubit.imageUploaded == null) ...[
                                FadeIn(
                                  duration: Duration(milliseconds: 500),
                                  child: OutlinedButton(
                                    style: ButtonStyle(
                                      enableFeedback: true,
                                      side: WidgetStatePropertyAll(
                                        BorderSide(
                                          width: 1.0,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                      shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      await cubit.getImage();
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        Icon(
                                          EvaIcons.imageOutline,
                                          size: 19.0,
                                          color: theme.colorScheme.primary,
                                        ),
                                        6.0.hrSpace,
                                        Text(
                                          'Update Image',
                                          style: TextStyle(
                                              // fontWeight: FontWeight.bold,
                                              letterSpacing: 1.4,
                                              color: theme.colorScheme.primary),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              AnimatedSize(
                                duration: Duration(milliseconds: 450),
                                clipBehavior: Clip.antiAlias,
                                curve: Curves.easeInOut,
                                child: Column(
                                  children: [
                                    if(cubit.imageUploaded != null) ...[
                                      SizedBox(
                                        width: 165.0,
                                        height: 165.0,
                                        child: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            ZoomIn(
                                              duration: Duration(milliseconds: 500),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: InkWell(
                                                  onTap: () {
                                                    showFullImage(cubit.imageUploaded!.path, context, isDarkTheme);
                                                  },
                                                  mouseCursor: SystemMouseCursors.click,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8.0),
                                                      border: Border.all(
                                                        width: 0.0,
                                                        color: isDarkTheme ? Colors.white : Colors.black,
                                                        style: BorderStyle.solid,
                                                        strokeAlign: BorderSide.strokeAlignOutside,
                                                      ),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(8.0),
                                                      child: Image.network(
                                                        cubit.imageUploaded!.path,
                                                        width: 125.0,
                                                        height: 125.0,
                                                        fit: BoxFit.cover,
                                                        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                                          if(frame == null) {
                                                            return shimmerImageLoading(
                                                                width: 125.0,
                                                                height: 125.0,
                                                                radius: 8.0,
                                                                theme: theme,
                                                                isDarkTheme: isDarkTheme);
                                                          }
                                                          return FadeIn(
                                                              duration: Duration(milliseconds: 300),
                                                              child: child);
                                                        },
                                                        errorBuilder: (context, error, stackTrace) {
                                                          return SizedBox(
                                                            width: 125.0,
                                                            height: 125.0,
                                                            child: Center(
                                                              child: Icon(
                                                                Icons.error_outline_rounded,
                                                                size: 28.0,
                                                                color: isDarkTheme ? Colors.white : Colors.black,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            FadeIn(
                                              duration: Duration(milliseconds: 500),
                                              child: defaultIconButton(
                                                  onPress: () {
                                                    cubit.clearData();
                                                  },
                                                  icon: Icons.close_rounded,
                                                  tooltipMsg: 'Remove',
                                                  isDarkTheme: isDarkTheme,
                                                  lightThemeColor: Colors.grey.shade300,
                                                  darkThemeColor: Colors.grey.shade800,
                                                  size: 22.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              AnimatedSize(
                                duration: Duration(milliseconds: 450),
                                clipBehavior: Clip.antiAlias,
                                curve: Curves.easeInOut,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if(pltNumberController.text.isNotEmpty) ...[
                                      45.0.vrSpace,
                                      ConditionalBuilder(
                                        condition: !isLoading,
                                        builder: (context) => defaultButton(
                                            width:
                                            MediaQuery.of(context).size.width / 2.4,
                                            height: 55.0,
                                            text: 'Update',
                                            onPress: () {
                                              if (formKey.currentState!.validate()) {

                                                setState(() {isLoading = true;});

                                                if(cubit.imageUploaded != null) {

                                                  cubit.uploadWebImageAndDataToServer(
                                                      pathUrl: uploadImgUrl,
                                                      image: cubit.imageUploaded!,
                                                      pltNumber: pltNumberController.text,
                                                      isEdited: true,
                                                      plateId: widget.data?.id,
                                                  );

                                                } else {

                                                  cubit.editLicensePlate(
                                                      plateId: widget.data?.id,
                                                      imageUrl: widget.data?.image ?? '',
                                                      pltNumber: pltNumberController.text);

                                                }

                                              }
                                            },
                                            context: context),
                                        fallback: (context) => Center(
                                            child: LoadingIndicator(os: getOs())),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
