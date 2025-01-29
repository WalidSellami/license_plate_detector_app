abstract class SignInStates {}

class InitialSignInState extends SignInStates {}

class LoadingSignInState extends SignInStates {}

class SuccessSignInState extends SignInStates {

  String status;
  String msg;
  dynamic userId;
  SuccessSignInState(this.status, this.msg, this.userId);

}

class ErrorSignInState extends SignInStates {

  dynamic error;
  ErrorSignInState(this.error);

}