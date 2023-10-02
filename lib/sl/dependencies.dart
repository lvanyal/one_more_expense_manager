// application service locator
// initialize dependencies using GetIt

import 'package:copilot/budget/budget_cubit.dart';
import 'package:copilot/categories/categories_cubit.dart';
import 'package:copilot/dashboard/bloc/dashboard_cubit.dart';
import 'package:copilot/data/budget_repository.dart';
import 'package:copilot/data/categories_repository.dart';
import 'package:copilot/data/dashboard_repository.dart';
import 'package:copilot/data/expense_repository.dart';
import 'package:copilot/data/local_data_source.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.I;

Future<void> initializeDependencies() async {
  // Register LocalDataSource instance.
  getIt.registerLazySingletonAsync<LocalDataSource>(() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    return LocalDataSource(
      sharedPreferences,
    );
  });

  getIt.registerLazySingleton(
      () => DashboardRepository(localDataSource: getIt.getAsync()));
  getIt.registerLazySingleton(
      () => CategoriesRepository(localDataSource: getIt.getAsync()));
  getIt.registerLazySingleton(
      () => BudgetRepository(localDataSource: getIt.getAsync()));
  getIt.registerLazySingleton(
      () => ExpenseRepository(localDataSource: getIt.getAsync()));

  getIt.registerLazySingleton(() => DashboardCubit(getIt(), getIt(), getIt()));
  getIt.registerLazySingleton(() => CategoriesCubit(getIt()));
  getIt.registerLazySingleton(() => BudgetCubit(getIt(), getIt()));
}
