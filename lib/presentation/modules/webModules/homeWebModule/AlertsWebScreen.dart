import 'package:animate_do/animate_do.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:license_plate_detector/data/models/alertModel/AlertModel.dart';
import 'package:license_plate_detector/shared/adaptive/loadingIndicator/LoadingIndicator.dart';
import 'package:license_plate_detector/shared/components/Components.dart';
import 'package:license_plate_detector/shared/components/Constants.dart';
import 'package:license_plate_detector/shared/components/Extensions.dart';
import 'package:license_plate_detector/shared/cubits/appCubit/AppCubit.dart';
import 'package:license_plate_detector/shared/cubits/appCubit/AppStates.dart';
import 'package:license_plate_detector/shared/notification/web/WebNotification.dart';
import 'package:license_plate_detector/shared/styles/Colors.dart';

class AlertsWebScreen extends StatefulWidget {
  const AlertsWebScreen({super.key});

  @override
  State<AlertsWebScreen> createState() => _AlertsWebScreenState();
}

class _AlertsWebScreenState extends State<AlertsWebScreen> {


  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 700)).then((v) {
      if(!mounted) return;
      AppCubit.get(context).getAlerts(isRead: true);
    });

  }


  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {

        final ThemeData theme = Theme.of(context);

        final bool isDarkTheme = isDarkThemeApplied(context);

        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {

            var cubit = AppCubit.get(context);

            if(state is SuccessRemoveAlertAppState) {
              showFlutterToast(message: 'Done with success', state: ToastStates.success, context: context);
              Navigator.pop(context);
              cubit.getAlerts(isRead: true);
            }

            if(state is ErrorRemoveAlertAppState) {
              showFlutterToast(
                  message: state.error.toString(),
                  state: ToastStates.error,
                  context: context,
                  seconds: 5);
              Navigator.pop(context);
            }

            if(state is SuccessRemoveAllAlertsAppState) {
              showFlutterToast(message: 'Done with success', state: ToastStates.success, context: context);
              Navigator.pop(context);
              cubit.getAlerts(isRead: true);
            }

            if(state is ErrorRemoveAllAlertsAppState) {
              showFlutterToast(
                  message: state.error.toString(),
                  state: ToastStates.error,
                  context: context,
                  seconds: 5,
              );
              Navigator.pop(context);
            }

            if(state is SuccessGetNotificationAppState) {

              if(state.title == 'Unauthorized') {
                WebNotification().showNotification(
                    title: state.title,
                    message: state.message,
                    context: context);
              }
            }

          },
          builder: (context, state) {

            var cubit = AppCubit.get(context);

            return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(80.0),
                child: AppBar(
                  clipBehavior: Clip.antiAlias,
                  leading: SizedBox.shrink(),
                  flexibleSpace: PreferredSize(
                      preferredSize: Size.fromHeight(kToolbarHeight),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 50.0,
                        ),
                        child: defaultAppBar(
                          onPress: () {
                            Navigator.pop(context);
                          },
                          title: 'Alerts',
                          sizeText: 22.0,
                          centerTitle: true,
                          icon: Icons.close_rounded,
                          size: 30.0,
                          actions: [
                            if((cubit.alertModel?.alerts ?? []).isNotEmpty) ...[
                              FadeIn(
                                duration: Duration(milliseconds: 500),
                                child: OutlinedButton(
                                  style: ButtonStyle(
                                    enableFeedback: true,
                                    side: WidgetStatePropertyAll(
                                      BorderSide(
                                        width: 2.0,
                                        color: redColor,
                                      ),
                                    ),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    showDialogRemoveAllAlerts(isDarkTheme, context);
                                  },
                                  child: Text(
                                    'Remove All',
                                    style: TextStyle(
                                        fontSize: 19.0,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: (kIsWeb) ? 1.0 : 0.6,
                                        color: redColor),
                                  ),
                                ),
                              ),
                              24.0.hrSpace,
                            ],
                          ],
                        ),
                      )),
                ),
              ),
              body: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.25,
                  child: ConditionalBuilder(
                    condition: (cubit.alertModel?.alerts ?? []).isNotEmpty,
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) => buildItemAlert(cubit.alertModel?.alerts[index], isDarkTheme),
                          separatorBuilder: (context, index) => 8.0.vrSpace,
                          itemCount: cubit.alertModel?.alerts.length ?? 0),
                    ),
                    fallback: (context) => (state is LoadingGetAlertsAppState) ?
                    Center(child: LoadingIndicator(os: getOs())) :
                    Center(
                      child: FadeInUp(
                        duration: Duration(milliseconds: 500),
                        child: Text(
                          'No Alerts',
                          style: theme.textTheme.displayMedium,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            );
          },
        );
      }
    );
  }


  Widget buildItemAlert(AlertData? alert, isDarkTheme) => FadeInUp(
    duration: Duration(milliseconds: 500),
      child: Card(
        margin: EdgeInsets.symmetric(
            horizontal: 50.0,
            vertical: 12.0
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: isDarkTheme
              ? BorderSide.none
              : BorderSide(
            width: 1.5,
            color: redColor,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: isDarkTheme ? 8.0 : 0.0,
        color: isDarkTheme ? darkColor1 : Colors.white,
        surfaceTintColor: isDarkTheme ? darkPrimary : Colors.white,
        child: LayoutBuilder(
          builder: (context, constraints) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${alert?.vehicleStatus}',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: redColor,
                      ),
                    ),
                    16.0.vrSpace,
                    Row(
                      children: [
                        Text(
                          '- - - - - > ',
                          style: TextStyle(
                            fontSize: 18.0,
                            letterSpacing: 1.0,
                          ),
                        ),
                        8.0.hrSpace,
                        Text(
                          '${alert?.plateNumber}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                    12.0.vrSpace,
                    Row(
                      children: [
                        Text(
                          '- - - - - > ',
                          style: TextStyle(
                            fontSize: 18.0,
                            letterSpacing: 1.0,
                          ),
                        ),
                        8.0.hrSpace,
                        Text(
                          DateFormat('dd/MM/yyyy \'at\' HH:mm:ss').format(DateTime.parse(alert?.dateTime)),
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    showDialogRemoveAlert(alert?.id, isDarkTheme, context);
                  },
                  tooltip: 'Remove',
                  enableFeedback: true,
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(redColor),
                  ),
                  icon: Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 26.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
}
