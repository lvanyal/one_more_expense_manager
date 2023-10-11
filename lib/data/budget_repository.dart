import 'package:copilot/data/local_data_source.dart';
import 'package:copilot/model/budget.dart';

class BudgetRepository {
  final Future<LocalDataSource> localDataSource;

  BudgetRepository({required this.localDataSource});

  Future<Budget> getBudget() async {
    final dataSource = await localDataSource;
    return dataSource.getBudgetForMonth(DateTime.now());
  }

  Future<void> saveBudgetForCurrentMonth(Budget budget) async {
    final dataSource = await localDataSource;

    await dataSource.saveBudgetForMonth(DateTime.now(), budget);
  }
}
