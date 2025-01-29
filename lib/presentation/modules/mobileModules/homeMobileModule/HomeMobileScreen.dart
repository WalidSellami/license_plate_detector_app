import 'package:animate_do/animate_do.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:license_plate_detector/presentation/modules/mobileModules/homeMobileModule/CameraStreamScreen.dart';
import 'package:license_plate_detector/shared/components/Components.dart';
import 'package:license_plate_detector/shared/components/Constants.dart';
import 'package:license_plate_detector/shared/components/Extensions.dart';

class HomeMobileScreen extends StatelessWidget {
  const HomeMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {

        final bool isDarkTheme = isDarkThemeApplied(context);

        return Scaffold(
          appBar: AppBar(
            title: Text('Hello!'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ZoomIn(
                  child: Icon(
                    EvaIcons.bulbOutline,
                    color: isDarkTheme ? Colors.white : Colors.black,
                    size: 65.0,
                  ),
                ),
                36.0.vrSpace,
                FadeIn(
                  child: Text(
                    'Press on the button to start recording',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ZoomIn(
              child: SizedBox(
                width: 62.0,
                height: 62.0,
                child: FloatingActionButton(
                  onPressed: () {
                    navigateTo(context: context, screen: CameraStreamScreen());
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 27.0,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
