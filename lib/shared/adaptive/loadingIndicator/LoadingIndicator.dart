import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {

  final String os;
  final double? strokeWidth;
  const LoadingIndicator({super.key, required this.os, this.strokeWidth});

  @override
  Widget build(BuildContext context) {

    if(os == 'android') {

      return CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
        strokeCap: StrokeCap.round,
        strokeWidth: strokeWidth ?? 4.0,
      );

    } else if(os == 'web') {

      return SpinKitFadingCircle(
        color: Theme.of(context).colorScheme.primary,
      );

    } else {

      return CupertinoActivityIndicator(
        color: Theme.of(context).colorScheme.primary,
      );

    }
  }
}
