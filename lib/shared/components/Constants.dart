import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const String ipAddress = '192.168.125.75';
const String baseUrl = 'http://$ipAddress:8000';
const String uploadImgUrl = 'https://freeimage.host/api/1/upload';
const String apiKey = '6d207e02198a847aa98d0a2a901485a5';

String getOs() {
  if(kIsWeb) {
    return 'web';
  }
  return Platform.operatingSystem;
}

dynamic userId;

late List<CameraDescription> cameras;

RegExp emailRegExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

RegExp passRegExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~,.]).{8,}$');

RegExp nameRegExp = RegExp(r'^[a-zA-Z\s]+$');


bool isDarkThemeApplied(context) {

  final ThemeData theme = Theme.of(context);
  final bool isDark = theme.brightness == Brightness.dark;

  return isDark;

}

