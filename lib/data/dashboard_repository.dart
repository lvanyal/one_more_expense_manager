import 'package:copilot/data/local_data_source.dart';
import 'package:copilot/model/dashboard_data.dart';

class DashboardRepository {
  final Future<LocalDataSource> localDataSource;

  DashboardRepository({required this.localDataSource});

  Future<DashboardData> getDashboardData(DateTime selectedMonth) async {
    final dataSource = await localDataSource;
    final expenses = dataSource.getExpensesForMonth(selectedMonth);
    final budget = dataSource.getBudgetForMonth(selectedMonth);
    final spentMoney = dataSource.getSpentMoneyForMonth(selectedMonth);
    return DashboardData(
        selectedMonth: selectedMonth,
        budget: budget,
        spentMoney: spentMoney,
        expenses: expenses);
  }
}
