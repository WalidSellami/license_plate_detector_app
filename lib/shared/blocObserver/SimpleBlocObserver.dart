
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {

  @override
  void onTransition(Bloc bloc, Transition transition) {
    if(kDebugMode) {
      print(transition);
    }
    super.onTransition(bloc, transition);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    if(kDebugMode) {
      print(change);
    }
    super.onChange(bloc, change);
  }

}