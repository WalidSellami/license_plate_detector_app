import 'package:animate_do/animate_do.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:license_plate_detector/presentation/modules/webModules/homeWebModule/HomeWebScreen.dart';
import 'package:license_plate_detector/shared/adaptive/loadingIndicator/LoadingIndicator.dart';
import 'package:license_plate_detector/shared/components/Components.dart';
import 'package:license_plate_detector/shared/components/Constants.dart';
import 'package:license_plate_detector/shared/components/Extensions.dart';
import 'package:license_plate_detector/shared/cubits/signInCubit/SignInCubit.dart';
import 'package:license_plate_detector/shared/cubits/signInCubit/SignInStates.dart';
import 'package:license_plate_detector/shared/network/local/CacheHelper.dart';
import 'package:license_plate_detector/shared/styles/Colors.dart';

class SignInWebScreen extends StatefulWidget {
  const SignInWebScreen({super.key});

  @override
  State<SignInWebScreen> createState() => _SignInWebScreenState();
}

class _SignInWebScreenState extends State<SignInWebScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPassword = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final FocusNode focusNode = FocusNode();
  final FocusNode focusNode2 = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {});
    });
    focusNode2.addListener(() {
      setState(() {});
    });
    passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordController.removeListener(() {
      setState(() {});
    });
    focusNode.dispose();
    focusNode2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final ThemeData theme = Theme.of(context);
      final bool isDarkTheme = isDarkThemeApplied(context);

      return BlocConsumer<SignInCubit, SignInStates>(
        listener: (context, state) {
          if (state is SuccessSignInState) {
            if (state.status == 'success') {
              showFlutterToast(
                  message: state.msg.toString(),
                  state: ToastStates.success,
                  context: context);

              if (state.userId != null) {
                CacheHelper.saveCachedData(key: 'userId', value: state.userId)
                    .then((value) {
                  userId = state.userId;
                  if (context.mounted) {
                    navigateAndNotReturn(
                        context: context, screen: HomeWebScreen());
                  }
                });
              }
            } else {
              showFlutterToast(
                  message: state.msg.toString(),
                  state: ToastStates.error,
                  context: context,
                  seconds: 5);
            }
          }

          if (state is ErrorSignInState) {
            showFlutterToast(
                message: state.error.toString(),
                state: ToastStates.error,
                context: context,
                seconds: 5);
          }
        },
        builder: (context, state) {
          var cubit = SignInCubit.get(context);

          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: ZoomIn(
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
                              ZoomIn(
                                child: Image.asset(
                                  'assets/images/license-plate.png',
                                  width: 110.0,
                                  height: 110.0,
                                  frameBuilder: (context, child, frame,
                                      wasSynchronouslyLoaded) {
                                    if (frame == null) {
                                      return shimmerImageLoading(
                                          width: 100.0,
                                          height: 100.0,
                                          radius: 60.0,
                                          theme: theme,
                                          isDarkTheme: isDarkTheme);
                                    }
                                    return ZoomIn(
                                        duration: Duration(milliseconds: 300),
                                        child: child);
                                  },
                                ),
                              ),
                              30.0.vrSpace,
                              Text(
                                'Sign In To Continue!',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: (kIsWeb) ? 1.0 : 0.6,
                                ),
                              ),
                              42.0.vrSpace,
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
                                    controller: emailController,
                                    focusNode: focusNode,
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
                                    controller: passwordController,
                                    focusNode: focusNode2,
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
                                        cubit.userSignIn(
                                            email: emailController.text,
                                            password: passwordController.text);
                                      }
                                    }),
                              ),
                              45.0.vrSpace,
                              ConditionalBuilder(
                                condition: state is! LoadingSignInState,
                                builder: (context) => defaultButton(
                                    width:
                                        MediaQuery.of(context).size.width / 2.4,
                                    height: 55.0,
                                    text: 'Sign in',
                                    onPress: () {
                                      if (formKey.currentState!.validate()) {
                                        cubit.userSignIn(
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
