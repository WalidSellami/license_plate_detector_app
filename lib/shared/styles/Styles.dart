import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:license_plate_detector/shared/styles/Colors.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: lightBackground,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: (kIsWeb) ? 'Spartan' : 'Varela',
  colorScheme: ColorScheme.light(
    primary: lightPrimary,
  ),
  appBarTheme: AppBarTheme(
    color: lightBackground,
    scrolledUnderElevation: 0.0,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    titleTextStyle: TextStyle(
      fontSize: (kIsWeb) ? 19.0 : 17.0,
      color: Colors.black,
      letterSpacing: (kIsWeb) ? 1.4 : 0.6,
      fontFamily: (kIsWeb) ? 'Spartan' : 'Varela',
      fontWeight: FontWeight.bold,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: lightBackground,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: lightBackground,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ),
  ),
  textTheme: TextTheme(
    displayMedium: TextStyle(
      color: Colors.black,
      fontSize: (kIsWeb) ? 18.0: 16.0,
      letterSpacing: (kIsWeb) ? 1.4 : 0.6,
      fontWeight: FontWeight.bold,
      fontFamily: (kIsWeb) ? 'Spartan' : 'Varela',
    ),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: (kIsWeb) ? lightBackground : Colors.white,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    clipBehavior: Clip.antiAlias,
    backgroundColor: Colors.white,
    showDragHandle: true,
  ),
);


ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: (kIsWeb) ? darkWebBackground : darkBackground,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: (kIsWeb) ? 'Spartan' : 'Varela',
  colorScheme: ColorScheme.dark(
    primary: darkPrimary,
  ),
  appBarTheme: AppBarTheme(
    color: (kIsWeb) ? darkWebBackground : darkBackground,
    scrolledUnderElevation: 0.0,
    elevation: 0,
    titleTextStyle: const TextStyle(
      fontSize: (kIsWeb) ? 19.0 : 17.0,
      letterSpacing: (kIsWeb) ? 1.4 : 0.6,
      color: Colors.white,
      fontFamily: (kIsWeb) ? 'Spartan' : 'Varela',
      fontWeight: FontWeight.bold,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: (kIsWeb) ? darkWebBackground : darkBackground,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: (kIsWeb) ? darkWebBackground : darkBackground,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ),
  ),
  textTheme: TextTheme(
    displayMedium: TextStyle(
      color: Colors.white,
      fontSize: (kIsWeb) ? 18.0: 16.0,
      letterSpacing: (kIsWeb) ? 1.4 : 0.6,
      fontWeight: FontWeight.bold,
      fontFamily: (kIsWeb) ? 'Spartan' : 'Varela',
    ),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: (kIsWeb) ? darkWebBackground : darkColor2,
  ),
  bottomSheetTheme: BottomSheetThemeData(
    clipBehavior: Clip.antiAlias,
    backgroundColor: darkColor1,
    showDragHandle: true,
  ),
);