import 'package:animate_do/animate_do.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:license_plate_detector/data/models/dataModel/DataModel.dart';
import 'package:license_plate_detector/presentation/modules/webModules/homeWebModule/AddAdminWebScreen.dart';
import 'package:license_plate_detector/presentation/modules/webModules/homeWebModule/AddItemWebScreen.dart';
import 'package:license_plate_detector/presentation/modules/webModules/homeWebModule/AlertsWebScreen.dart';
import 'package:license_plate_detector/presentation/modules/webModules/homeWebModule/EditItemWebScreen.dart';
import 'package:license_plate_detector/presentation/modules/webModules/startUpWebModule/signInWebModule/SignInWebScreen.dart';
import 'package:license_plate_detector/shared/adaptive/loadingIndicator/LoadingIndicator.dart';
import 'package:license_plate_detector/shared/components/Components.dart';
import 'package:license_plate_detector/shared/components/Constants.dart';
import 'package:license_plate_detector/shared/components/Extensions.dart';
import 'package:license_plate_detector/shared/cubits/appCubit/AppCubit.dart';
import 'package:license_plate_detector/shared/cubits/appCubit/AppStates.dart';
import 'package:license_plate_detector/shared/network/local/CacheHelper.dart';
import 'package:license_plate_detector/shared/notification/web/WebNotification.dart';
import 'package:license_plate_detector/shared/styles/Colors.dart';

class HomeWebScreen extends StatefulWidget {
  const HomeWebScreen({super.key});

  @override
  State<HomeWebScreen> createState() => _HomeWebScreenState();
}

class _HomeWebScreenState extends State<HomeWebScreen> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });

    AppCubit.get(context).getDataProfile();
    AppCubit.get(context).getLicensePlates();
    AppCubit.get(context).getAlerts();

  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    searchController.removeListener(() {
      setState(() {});
    });
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {

     final ThemeData theme = Theme.of(context);

     bool isDarkTheme = isDarkThemeApplied(context);

      return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {

          var cubit = AppCubit.get(context);

          if(state is ErrorGetLicensePlatesAppState) {
            showFlutterToast(message: state.error.toString(), state: ToastStates.error, context: context, seconds: 5);
          }

          if(state is SuccessRemoveLicensePlateAppState) {
            showFlutterToast(message: 'Done with success', state: ToastStates.success, context: context);
            cubit.getLicensePlates();
          }

          if(state is ErrorRemoveLicensePlateAppState) {
            showFlutterToast(message: state.error.toString(), state: ToastStates.error, context: context, seconds: 5);
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
                flexibleSpace: PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: AppBar(
                      clipBehavior: Clip.antiAlias,
                      title: (!cubit.isSearch)
                          ? FadeIn(
                              duration: Duration(milliseconds: 500),
                              child: Text(
                                'Hello Admin!',
                              ))
                          : ZoomIn(
                              duration: Duration(milliseconds: 300),
                              child: TextFormField(
                                clipBehavior: Clip.antiAlias,
                                controller: searchController,
                                keyboardType: TextInputType.text,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                  hintText: 'Plate Number ...',
                                  hintStyle: TextStyle(
                                    letterSpacing: (kIsWeb) ? 1.0 : 0.6,
                                  ),
                                ),
                                onChanged: (v) {
                                  if(v.isNotEmpty) {
                                    cubit.searchLicensePlate(pltNumber: v);
                                  } else {
                                    cubit.getLicensePlates();
                                  }
                                },
                              ),
                            ),
                      actions: [
                        FadeIn(
                          duration: Duration(milliseconds: 500),
                          child: Visibility(
                            visible: !cubit.isSearch,
                            child: defaultIconButton(
                                onPress: () {
                                  Navigator.of(context).push(
                                      createRoute(screen: AddItemWebScreen()));
                                },
                                icon: Icons.add_circle_outline_rounded,
                                tooltipMsg: 'New Item',
                                isDarkTheme: isDarkTheme,
                                lightThemeColor: lightColorIcnBtn,
                                darkThemeColor: darkColorIcnBtn,
                                size: 28.0),
                          ),
                        ),
                        20.0.hrSpace,
                        FadeIn(
                          duration: Duration(milliseconds: 500),
                          child: Visibility(
                            visible: !cubit.isSearch,
                            child: defaultIconButton(
                                onPress: () {
                                  cubit.activateSearch();
                                },
                                icon: Icons.search_rounded,
                                tooltipMsg: 'Search Item',
                                isDarkTheme: isDarkTheme,
                                lightThemeColor: lightColorIcnBtn,
                                darkThemeColor: darkColorIcnBtn,
                                size: 28.0),
                          ),
                        ),
                        20.0.hrSpace,
                        FadeIn(
                          duration: Duration(milliseconds: 500),
                          child: Visibility(
                            visible: !cubit.isSearch,
                            child: defaultIconButton(
                                onPress: () {
                                  Navigator.of(context).push(
                                      createRoute(screen: AddAdminWebScreen()));
                                },
                                icon: Icons.person_add_alt_1_rounded,
                                tooltipMsg: 'Add New Admin',
                                isDarkTheme: isDarkTheme,
                                lightThemeColor: lightColorIcnBtn,
                                darkThemeColor: darkColorIcnBtn,
                                size: 28.0),
                          ),
                        ),
                        20.0.hrSpace,
                        FadeIn(
                          duration: Duration(milliseconds: 500),
                          child: Visibility(
                            visible: !cubit.isSearch,
                            child: (cubit.numberOfAlerts > 0) ?
                            Badge(
                              alignment: Alignment.topRight,
                              backgroundColor: redColor,
                              label: (cubit.numberOfAlerts < 100) ? Text(
                                '${cubit.numberOfAlerts}',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ) : Text(
                                  '+99',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  )),
                              child: defaultIconButton(
                                  onPress: () {
                                    Navigator.of(context).push(
                                        createRoute(screen: AlertsWebScreen()));
                                  },
                                  icon: EvaIcons.bellOutline,
                                  tooltipMsg: 'Alerts',
                                  isDarkTheme: isDarkTheme,
                                  lightThemeColor: lightColorIcnBtn,
                                  darkThemeColor: darkColorIcnBtn,
                                  size: 28.0),
                            ) :
                            defaultIconButton(
                                onPress: () {
                                  Navigator.of(context).push(
                                      createRoute(screen: AlertsWebScreen()));
                                },
                                icon: EvaIcons.bellOutline,
                                tooltipMsg: 'Alerts',
                                isDarkTheme: isDarkTheme,
                                lightThemeColor: lightColorIcnBtn,
                                darkThemeColor: darkColorIcnBtn,
                                size: 28.0),
                          ),
                        ),
                        50.0.hrSpace,
                        if (!cubit.isSearch) ...[
                          FadeIn(
                            duration: Duration(milliseconds: 500),
                            child: defaultIconButton(
                                onPress: ()  {},
                                icon: Icons.person,
                                tooltipMsg: '${cubit.profileModel?.name}\n${cubit.profileModel?.email}',
                                isDarkTheme: isDarkTheme,
                                lightThemeColor: lightColorIcnBtn,
                                darkThemeColor: darkColorIcnBtn,
                                size: 28.0),
                          ),
                          20.0.hrSpace,
                          FadeIn(
                              duration: Duration(milliseconds: 500),
                              child: IconButton(
                                onPressed: () {
                                  showDialogSignOut(
                                      context,
                                      onPress: () async {
                                        await CacheHelper.removeCachedData(key: 'userId').then((value) {
                                          if(value == true) {
                                            userId = null;
                                          }
                                        });
                                        if(context.mounted) {
                                          showLoading(context, isDarkTheme);
                                          Future.delayed(Duration(milliseconds: 750)).then((value) {
                                            if(context.mounted) {
                                              Navigator.pop(context);
                                              navigateAndNotReturn(context: context, screen: SignInWebScreen());
                                            }
                                          });
                                        }
                                      },
                                  );
                                },
                                tooltip: 'Sign Out',
                                enableFeedback: true,
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(redColor),
                                ),
                                icon: Icon(
                                  Icons.logout_rounded,
                                  color: Colors.white,
                                  size: 28.0,
                                ),
                              )),
                        ] else ...[
                          ZoomIn(
                            duration: Duration(milliseconds: 500),
                            child: defaultIconButton(
                                onPress: () {
                                  cubit.activateSearch();
                                  if(searchController.text.isNotEmpty) {
                                    searchController.clear();
                                  }
                                  cubit.getLicensePlates();
                                },
                                icon: Icons.close_rounded,
                                tooltipMsg: 'Cancel',
                                isDarkTheme: isDarkTheme,
                                lightThemeColor: lightColorIcnBtn,
                                darkThemeColor: darkColorIcnBtn,
                                size: 28.0),
                          ),
                        ],
                        20.0.hrSpace,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: ConditionalBuilder(
              condition: (cubit.dataModel?.licensePlates ?? []).isNotEmpty,
              builder: (context) => Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: ListView.separated(
                    clipBehavior: Clip.antiAlias,
                    physics: const BouncingScrollPhysics(),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemBuilder: (context, index) =>
                        buildItemData(cubit.dataModel?.licensePlates[index], theme, isDarkTheme, context),
                    separatorBuilder: (context, index) => 8.0.vrSpace,
                    itemCount: cubit.dataModel?.licensePlates.length ?? 0),
              ),
              fallback: (context) => (state is LoadingGetLicensePlatesAppState) ? Center(
                  child: FadeIn(
                      duration: Duration(milliseconds: 300),
                      child: LoadingIndicator(os: getOs()))) :
              Center(
                child: FadeIn(
                  duration: Duration(milliseconds: 500),
                  child: Text(
                    'There are no License Plates yet',
                    style: theme.textTheme.displayMedium,
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget buildItemData(LicensePlateData? data, ThemeData theme, isDarkTheme, context) => FadeIn(
    duration: Duration(milliseconds: 500),
    child: Card(
          margin: EdgeInsets.symmetric(
            horizontal: 50.0,
            vertical: 12.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: isDarkTheme
                ? BorderSide.none
                : BorderSide(
                    width: 1.5,
                    color: isDarkTheme ? Colors.white : Colors.black,
                  ),
          ),
          clipBehavior: Clip.antiAlias,
          elevation: isDarkTheme ? 8.0 : 0.0,
          color: isDarkTheme ? darkColor1 : Colors.white,
          surfaceTintColor: isDarkTheme ? darkPrimary : Colors.white,
          child: LayoutBuilder(
            builder: (context, constraints) => Row(
              children: [
                InkWell(
                 mouseCursor: SystemMouseCursors.click,
                  onTap: () {
                    showFullImage(data?.image, context, isDarkTheme);
                  },
                  child: Image.network(
                    '${data?.image}',
                    width: MediaQuery.of(context).size.width / 5,
                    height: MediaQuery.of(context).size.height / 7,
                    fit: BoxFit.cover,
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                      if (frame == null) {
                        return shimmerImageLoading(
                            width: MediaQuery.of(context).size.width / 5,
                            height: MediaQuery.of(context).size.height / 7,
                            radius: 16.0,
                            theme: theme,
                            isDarkTheme: isDarkTheme,
                            isItem: true,
                        );
                      }
                      return FadeIn(
                          duration: Duration(milliseconds: 300),
                          child: child);
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: MediaQuery.of(context).size.width / 5,
                        height: MediaQuery.of(context).size.height / 7,
                        color: theme.colorScheme.primary,
                        child: Center(
                          child: Icon(
                            Icons.error_outline_rounded,
                            color: Colors.white,
                            size: 28.0,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                30.0.hrSpace,
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 7,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${data?.plateNumber}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy \'at\' HH:mm:ss').format(DateTime.parse(data?.dateTime)),
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context, createRoute(screen: EditItemWebScreen(data: data,)));
                      },
                      tooltip: 'Edit',
                      enableFeedback: true,
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(greenColor),
                      ),
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 26.0,
                      ),
                    ),
                    20.0.hrSpace,
                    IconButton(
                      onPressed: () {
                        showDialogRemoveItem(data?.id, isDarkTheme, context);
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
                20.0.hrSpace,
              ],
            ),
          ),
        ),
  );
}
