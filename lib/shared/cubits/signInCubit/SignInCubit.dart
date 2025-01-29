import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:license_plate_detector/shared/cubits/signInCubit/SignInStates.dart';
import 'package:license_plate_detector/shared/network/remot/DioHelper.dart';

class SignInCubit extends Cubit<SignInStates> {

  SignInCubit() : super(InitialSignInState());

  static SignInCubit get(context) => BlocProvider.of(context);


  void userSignIn({
    required String email,
    required String password
}) async {

    emit(LoadingSignInState());

    await DioHelper.postData(
        pathUrl: '/login',
        data: {
          'email': email,
          'password': password
        },
    ).then((value) {

      if(kDebugMode) {
        print(value?.data);
      }

      emit(SuccessSignInState(value?.data['status'], value?.data['message'], value?.data['user_id']));

    }).catchError((error) {

      if(kDebugMode) {
        print('${error.toString()}  --> in user sign in');
      }

      emit(ErrorSignInState(error));
    });

  }



}