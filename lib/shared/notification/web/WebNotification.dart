import 'package:audioplayers/audioplayers.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:license_plate_detector/presentation/modules/webModules/homeWebModule/AlertsWebScreen.dart';
import 'package:license_plate_detector/shared/components/Components.dart';
import 'package:license_plate_detector/shared/components/Constants.dart';
import 'package:license_plate_detector/shared/styles/Colors.dart';

class WebNotification {
  final AudioPlayer audioPlayer = AudioPlayer();

  Future showNotification(
      {required String title,
      required String message,
      required BuildContext context}) async {

    // if(title == 'Authorized') {
    //
    //   ElegantNotification.success(
    //     width: 360,
    //     isDismissable: false,
    //     borderRadius: BorderRadius.only(
    //         topRight: Radius.circular(8.0),
    //         topLeft: Radius.circular(8.0)
    //     ),
    //     animationCurve: Curves.easeInOut,
    //     position: Alignment.topCenter,
    //     animation: AnimationType.fromTop,
    //     progressIndicatorBackground: Colors.grey.shade100,
    //     background: isDarkThemeApplied(context) ? darkColorIcnBtn : lightBackground,
    //     verticalDividerColor: isDarkThemeApplied(context) ? Colors.white : Colors.black,
    //     title: Text(
    //       title,
    //       style: TextStyle(
    //         fontSize: 16.0,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     description: Text(
    //       message,
    //       style: TextStyle(),
    //     ),
    //     onDismiss: () {},
    //     onNotificationPressed: () {},
    //     shadow: BoxShadow(
    //       color: isDarkThemeApplied(context) ? Colors.grey.shade900 : Colors.grey.shade400,
    //       spreadRadius: 2,
    //       blurRadius: 5,
    //       offset: const Offset(0, 4),
    //     ),
    //   ).show(context);
    //   await Future.delayed(Duration(milliseconds: 300)).then((value) async {
    //     await audioPlayer.play(AssetSource('audios/song-1.mp3'));
    //   });
    //
    // }

    // if(title == 'Unauthorized') {

    ElegantNotification.error(
      width: 360,
      isDismissable: false,
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(8.0), topLeft: Radius.circular(8.0)),
      animationCurve: Curves.easeInOut,
      position: Alignment.topCenter,
      animation: AnimationType.fromTop,
      progressIndicatorBackground: Colors.grey.shade100,
      background:
          isDarkThemeApplied(context) ? darkColorIcnBtn : lightBackground,
      verticalDividerColor:
          isDarkThemeApplied(context) ? Colors.white : Colors.black,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          letterSpacing: 1.4,
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(
        message,
        style: TextStyle(
          letterSpacing: 1.4,
        ),
      ),
      onDismiss: () {},
      onNotificationPressed: () {
        Navigator.of(context).push(
            createRoute(screen: AlertsWebScreen()));
      },
      shadow: BoxShadow(
        color: isDarkThemeApplied(context)
            ? Colors.grey.shade900
            : Colors.grey.shade400,
        spreadRadius: 2,
        blurRadius: 5,
        offset: const Offset(0, 4),
      ),
    ).show(context);
    await Future.delayed(Duration(milliseconds: 300)).then((value) async {
      await audioPlayer.play(AssetSource('audios/song-2.mp3'));
    });

    // }
  }
}
