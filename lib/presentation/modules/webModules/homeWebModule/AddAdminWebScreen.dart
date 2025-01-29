import 'package:animate_do/animate_do.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:license_plate_detector/shared/adaptive/loadingIndicator/LoadingIndicator.dart';
import 'package:license_plate_detector/shared/components/Components.dart';
import 'package:license_plate_detector/shared/components/Constants.dart';
import 'package:license_plate_detector/shared/components/Extensions.dart';
import 'package:license_plate_detector/shared/cubits/appCubit/AppCubit.dart';
import 'package:license_plate_detector/shared/cubits/appCubit/AppStates.dart';
import 'package:license_plate_detector/shared/styles/Colors.dart';

class AddAdminWebScreen extends StatefulWidget {
  const AddAdminWebScreen({super.key});

  @override
  State<AddAdminWebScreen> createState() => _AddAdminWebScreenState();
}

class _AddAdminWebScreenState extends State<AddAdminWebScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPassword = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final FocusNode focusNode = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {});
    });
    focusNode2.addListener(() {
      setState(() {});
    });
    focusNode3.addListener(() {
      setState(() {});
    });
    passwordController.addListener(() {
      setState(() {});
    });
  }


  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordController.removeListener(() {
      setState(() {});
    });
    focusNode.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final bool isDarkTheme = isDarkThemeApplied(context);

      return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {

          if(state is SuccessAddNewAdminAppState) {
            showFlutterToast(message: 'Done with success', state: ToastStates.success, context: context);
            Navigator.pop(context);
          }

          if(state is ErrorAddNewAdminAppState) {
            showFlutterToast(message: state.error.toString(), state: ToastStates.error, context: context, seconds: 5);
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
                                'New Admin',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: (kIsWeb) ? 1.4 : 0.6,
                                ),
                              ),
                              36.0.vrSpace,
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
                                    controller: nameController,
                                    focusNode: focusNode,
                                    hintText: 'Name',
                                    isWithBorder: false,
                                    prefixIcon: Icons.person,
                                    onComplete: () {
                                      FocusScope.of(context).nextFocus();
                                    },
                                    validate: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Name must not be empty';
                                      }
                                      if (!RegExp(r'^(?:[^ ]* ?){0,2}[^ ]+$').hasMatch(v) || v.length < 4) {
                                        return 'Name must be at least 4 characters and have a maximum of two spaces';
                                      }

                                      bool validName = nameRegExp.hasMatch(v);
                                      if (!validName) {
                                        return 'Enter a valid Name!';
                                      }

                                      return null;
                                    }),
                              ),
                              24.0.vrSpace,
                              Container(
                                width: MediaQuery.of(context).size.width / 2.4,
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: (focusNode2.hasFocus)
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
                                    controller: emailController,
                                    focusNode: focusNode2,
                                    hintText: 'Email',
                                    isWithBorder: false,
                                    prefixIcon: Icons.email_outlined,
                                    onComplete: () {
                                      FocusScope.of(context).nextFocus();
                                    },
                                    validate: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Email must not be empty';
                                      }

                                      bool validEmail = emailRegExp.hasMatch(v);
                                      if (!validEmail) {
                                        return 'Enter a valid Email!';
                                      }

                                      return null;
                                    }),
                              ),
                              24.0.vrSpace,
                              Container(
                                width: MediaQuery.of(context).size.width / 2.4,
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: (focusNode3.hasFocus)
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
                                    controller: passwordController,
                                    focusNode: focusNode3,
                                    hintText: 'Password',
                                    isPassword: isPassword,
                                    isWithBorder: false,
                                    prefixIcon: Icons.lock_outline_rounded,
                                    suffixIcon: isPassword
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                    onPress: () {
                                      setState(() {
                                        isPassword = !isPassword;
                                      });
                                    },
                                    validate: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Password must not be empty';
                                      }

                                      if (v.length < 8) {
                                        return 'Password must be at least 8 characters';
                                      }
                                      bool passwordValid =
                                          passRegExp.hasMatch(v);
                                      if (!passwordValid) {
                                        return 'Enter a strong password with a mix of uppercase letters, lowercase letters, numbers, special characters(@#%&!?), and at least 8 characters.';
                                      }

                                      return null;
                                    },
                                    onSubmit: (v) {
                                      if (formKey.currentState!.validate()) {
                                        cubit.addNewAdmin(
                                            name: nameController.text,
                                            email: emailController.text,
                                            password: passwordController.text);
                                      }
                                    }),
                              ),
                              45.0.vrSpace,
                              ConditionalBuilder(
                                condition: state is! LoadingAddNewAdminAppState,
                                builder: (context) => defaultButton(
                                    width: MediaQuery.of(context).size.width / 2.4,
                                    height: 55.0,
                                    text: 'Add',
                                    onPress: () {
                                      if (formKey.currentState!.validate()) {
                                        cubit.addNewAdmin(
                                            name: nameController.text,
                                            email: emailController.text,
                                            password: passwordController.text);
                                      }
                                    },
                                    context: context),
                                fallback: (context) => Center(
                                    child: LoadingIndicator(os: getOs())),
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
