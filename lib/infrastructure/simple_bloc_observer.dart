import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class SimpleBlocObserver extends BlocObserver {
  Logger logger = Logger();

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logger.e(error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    if (change.nextState.runtimeType
        .toString()
        .toLowerCase()
        .contains('error')) {
      logger.e(change);
    } else {
      logger.i(change);
    }
    super.onChange(bloc, change);
  }
}
