import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:license_plate_detector/shared/adaptive/loadingIndicator/LoadingIndicator.dart';
import 'package:license_plate_detector/shared/components/Constants.dart';
import 'package:license_plate_detector/shared/cubits/appCubit/AppCubit.dart';
import 'package:license_plate_detector/shared/styles/Colors.dart';
import 'package:shimmer/shimmer.dart';

navigateTo({required BuildContext context , required Widget screen}) =>
    Navigator.push(context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => screen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ));

navigateAndNotReturn({required BuildContext context, required Widget screen}) =>
    Navigator.pushAndRemoveUntil(context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => screen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ), (route) => false);

Route createRoute({required screen}) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      });
}

Route createSecondRoute({required screen}) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      });
}


PreferredSizeWidget defaultAppBar({
  required Function onPress,
  required IconData icon,
  required double size,
  bool centerTitle = false,
  double sizeText = 19.0,
  String? title,
  List<Widget>? actions,
}) => AppBar(
  clipBehavior: Clip.antiAlias,
  scrolledUnderElevation: 0.0,
  centerTitle: centerTitle,
  leading: IconButton(
    onPressed: () {
      onPress();
    },
    icon: Icon(
      icon,
      size: size,
    ),
    tooltip: 'Back',
  ),
  title: Text(
    title ?? '',
    maxLines: 1,
    style: TextStyle(
      letterSpacing: (kIsWeb) ? 1.4 : 0.6,
      fontSize: sizeText,
      overflow: TextOverflow.ellipsis,
    ),
  ),
  titleSpacing: 0.6,
  actions: actions,
);



Widget defaultTextFormField({
  required bool isDarkTheme,
  required TextEditingController controller,
  required FocusNode focusNode,
  required String hintText,
  required String? Function(String?) validate,
  void Function()? onPress,
  void Function()? onComplete,
  void Function(String)? onSubmit,
  void Function(String)? onChange,
  bool isWithBorder = true,
  bool isPassword = false,
  IconData? prefixIcon,
  IconData? suffixIcon,

}) => TextFormField(
  clipBehavior: Clip.antiAlias,
  controller: controller,
  focusNode: focusNode,
  keyboardType: TextInputType.text,
  obscureText: isPassword,
  style: TextStyle(
    // fontWeight: FontWeight.bold,
    letterSpacing: (kIsWeb) ? 1.4 : 0.6,
  ),
  decoration: InputDecoration(
    hintText: hintText,
    errorMaxLines: 3,
    hintStyle: TextStyle(
      letterSpacing: (kIsWeb) ? 1.4 : 0.6,
    ),
    border: isWithBorder ? OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
    ) : InputBorder.none,
    prefixIcon: (prefixIcon != null) ? Icon(prefixIcon) : null,
    suffixIcon: (suffixIcon != null) ? IconButton(
        onPressed: onPress,
        icon: Icon(suffixIcon,),
        color: isDarkTheme ? Colors.white : Colors.black,
        ) : null,
  ),
  onChanged: onChange,
  onFieldSubmitted: (value) {
    if(value.isNotEmpty) {
      onSubmit!(value);
    }
  },
  onEditingComplete: onComplete,
  validator: validate,
);


Widget defaultIconButton({
  required Function onPress,
  required IconData icon,
  required String tooltipMsg,
  required bool isDarkTheme,
  required Color lightThemeColor,
  required Color darkThemeColor,
  required double size,
}) => IconButton(
  onPressed: () {
    onPress();
  },
  tooltip: tooltipMsg,
  enableFeedback: true,
  style: ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(
      isDarkTheme ? darkThemeColor : lightThemeColor,
    ),
  ),
  icon: Icon(
    icon,
    color: isDarkTheme ? Colors.white : Colors.black,
    size: size,
  ),
);


Widget defaultButton({
  double width = double.infinity,
  double height = 48.0,
  required String text,
  required void Function() onPress,
  required BuildContext context,
}) => SizedBox(
  width: width,
  child: MaterialButton(
    height: height,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    color: Theme.of(context).colorScheme.primary,
    onPressed: onPress,
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 18.0,
        color: Colors.white,
        letterSpacing: (kIsWeb) ? 1.4 : 0.6,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
);


enum ToastStates {success , warning , error}

void showFlutterToast({
  required String message,
  required ToastStates state,
  required BuildContext context,
  int seconds = 3,
}) =>
    showToast(
      message,
      context: context,
      backgroundColor: chooseToastColor(s: state),
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      animDuration: const Duration(milliseconds: 1500),
      duration: Duration(seconds: seconds),
      curve: Curves.elasticInOut,
      reverseCurve: Curves.linear,
    );


Color chooseToastColor({
  required ToastStates s,
}) {

  return switch(s) {
    ToastStates.success => greenColor,
    ToastStates.warning => Colors.amber.shade900,
    ToastStates.error => Colors.red,
  };

}

Widget shimmerImageLoading({
  required double width,
  required double height,
  required double radius,
  required ThemeData theme,
  required bool isDarkTheme,
  bool isItem = false,
}) => Shimmer.fromColors(
  baseColor: isDarkTheme ? darkShimmerColor
      : lightShimmerColor,
  highlightColor: isDarkTheme ? darkShimmerColor2
      : lightShimmerColor2,
  child: Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: (isItem) ? BorderRadius.only(
        topLeft: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
      ) : BorderRadius.circular(radius),
      color: theme.scaffoldBackgroundColor,
    ),
    clipBehavior: Clip.antiAlias,
  ),
);


dynamic showLoading(context, isDarkTheme) => showDialog(
  barrierDismissible: false,
  context: context,
  builder: (context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: Container(
            padding: const EdgeInsets.all(26.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.0),
              color: isDarkTheme ? darkWebBackground : lightBackground,
            ),
            clipBehavior: Clip.antiAlias,
            child: (kIsWeb) ? SizedBox(
                width: 50.0,
                height: 50.0,
                child: LoadingIndicator(os: getOs())) :
            LoadingIndicator(os: getOs())),
      ),
    );
  },
);



dynamic showDialogSignOut(context, {required void Function() onPress}) => showDialog(
    context: context,
    builder: (dialogContext) {
      return FadeIn(
        duration: Duration(milliseconds: 300),
        child: AlertDialog(
          clipBehavior: Clip.antiAlias,
          title: Text(
            'Sign Out?',
            style: TextStyle(
              fontSize: 19.0,
              fontWeight: FontWeight.bold,
              height: 1.0,
              letterSpacing: (kIsWeb) ? 1.4 : 0.6,
            ),
          ),
          content: Text(
            'Are you sure you want to sign out?',
            style: TextStyle(
              fontSize: 17.0,
              letterSpacing: (kIsWeb) ? 1.4 : 0.6,
              height: 1.0
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: Text(
                  'No',
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  onPress();
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: redColor,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ],
        ),
      );
    });


dynamic showDialogRemoveItem(dynamic plateId, isDarkTheme, context) => showDialog(
    context: context,
    builder: (dialogContext) {
      return FadeIn(
        duration: Duration(milliseconds: 300),
        child: AlertDialog(
          clipBehavior: Clip.antiAlias,
          title: Text(
            'Remove Item?',
            style: TextStyle(
              fontSize: 19.0,
              fontWeight: FontWeight.bold,
              height: 1.0,
              letterSpacing: (kIsWeb) ? 1.4 : 0.6,
            ),
          ),
          content: Text(
            'Are You Sure You Want to Remove This Item?',
            style: TextStyle(
                fontSize: 17.0,
                letterSpacing: (kIsWeb) ? 1.4 : 0.6,
                height: 1.0
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: Text(
                  'No',
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  showLoading(context, isDarkTheme);
                  AppCubit.get(context).removeAlert(alertId: plateId);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: redColor,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ],
        ),
      );
    });


dynamic showDialogRemoveAlert(dynamic alertId, isDarkTheme, context) => showDialog(
    context: context,
    builder: (dialogContext) {
      return FadeIn(
        duration: Duration(milliseconds: 300),
        child: AlertDialog(
          clipBehavior: Clip.antiAlias,
          title: Text(
            'Remove Alert?',
            style: TextStyle(
              fontSize: 19.0,
              fontWeight: FontWeight.bold,
              height: 1.0,
              letterSpacing: (kIsWeb) ? 1.4 : 0.6,
            ),
          ),
          content: Text(
            'Are You Sure You Want to Remove This Alert?',
            style: TextStyle(
                fontSize: 17.0,
                letterSpacing: (kIsWeb) ? 1.4 : 0.6,
                height: 1.0
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: Text(
                  'No',
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  showLoading(context, isDarkTheme);
                  AppCubit.get(context).removeAlert(alertId: alertId);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: redColor,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ],
        ),
      );
    });


dynamic showDialogRemoveAllAlerts(isDarkTheme, context) => showDialog(
    context: context,
    builder: (dialogContext) {
      return FadeIn(
        duration: Duration(milliseconds: 300),
        child: AlertDialog(
          clipBehavior: Clip.antiAlias,
          title: Text(
            'Remove All Alerts?',
            style: TextStyle(
              fontSize: 19.0,
              fontWeight: FontWeight.bold,
              height: 1.0,
              letterSpacing: (kIsWeb) ? 1.4 : 0.6,
            ),
          ),
          content: Text(
            'Are You Sure You Want to Remove This All Alerts?',
            style: TextStyle(
                fontSize: 17.0,
                letterSpacing: (kIsWeb) ? 1.4 : 0.6,
                height: 1.0
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: Text(
                  'No',
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  showLoading(context, isDarkTheme);
                  AppCubit.get(context).removeAllAlerts();
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: redColor,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ],
        ),
      );
    });




dynamic showFullImage(String? image, context, isDarkTheme) {
  return Navigator.push(
      context,
      createSecondRoute(screen: Scaffold(
        body: SafeArea(
            child: SlideInRight(
              duration: Duration(seconds: 1),
              child: InteractiveViewer(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  mouseCursor: SystemMouseCursors.click,
                  child: Image.network(
                    image ?? '',
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.contain,
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                      if(frame == null) {
                        return Center(child: LoadingIndicator(os: getOs()));
                      }
                      return child;
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.error_outline_rounded,
                        color: (isDarkTheme) ? Colors.white : Colors.black,
                        size: 50.0,
                      );
                    },
                  ),
                ),
              ),
            ),
        ),
      ),));
}