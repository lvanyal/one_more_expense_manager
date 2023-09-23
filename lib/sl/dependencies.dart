// application service locator
// initialize dependencies using GetIt

import 'package:copilot/data/local_data_source.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initializeDependencies() async {
  // Register LocalDataSource instance.
  GetIt.I.registerLazySingletonAsync<LocalDataSource>(() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    return LocalDataSource(
      sharedPreferences,
    );
  });
}
