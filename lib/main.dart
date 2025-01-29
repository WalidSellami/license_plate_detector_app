import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:license_plate_detector/presentation/modules/mobileModules/homeMobileModule/HomeMobileScreen.dart';
import 'package:license_plate_detector/presentation/modules/webModules/homeWebModule/HomeWebScreen.dart';
import 'package:license_plate_detector/presentation/modules/webModules/startUpWebModule/signInWebModule/SignInWebScreen.dart';
import 'package:license_plate_detector/shared/blocObserver/SimpleBlocObserver.dart';
import 'package:license_plate_detector/shared/components/Constants.dart';
import 'package:license_plate_detector/shared/cubits/appCubit/AppCubit.dart';
import 'package:license_plate_detector/shared/cubits/signInCubit/SignInCubit.dart';
import 'package:license_plate_detector/shared/network/local/CacheHelper.dart';
import 'package:license_plate_detector/shared/network/remot/DioHelper.dart';
import 'package:license_plate_detector/shared/styles/Styles.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  DioHelper.init();

  Widget? startWidget;

  if(kIsWeb) {

    await CacheHelper.init();
    userId = CacheHelper.getCachedData(key: 'userId');

    if(userId != null) {
      startWidget = HomeWebScreen();
    } else {
      startWidget = SignInWebScreen();
    }

  } else {

    cameras = await availableCameras();

  }


  runApp(MyApp(startWidget: startWidget,));
}

class MyApp extends StatelessWidget {

  final Widget? startWidget;

  const MyApp({super.key, this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => AppCubit()..getNotification(context)),
        BlocProvider(create: (BuildContext context) => SignInCubit()),
      ],
      child: MaterialApp(
        title: 'LP Detector',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: Builder(
            builder: (context) {
              if(kIsWeb) {
                return startWidget!;
              }
              return HomeMobileScreen();
            }
        ),
      ),
    );
  }
}
