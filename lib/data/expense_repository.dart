import 'package:copilot/data/local_data_source.dart';
import 'package:copilot/model/expense.dart';

class ExpenseRepository {
  final Future<LocalDataSource> localDataSource;

  ExpenseRepository({required this.localDataSource});
  //add expense
  Future<void> addExpense(Expense expense) async {
    final dataSource = await localDataSource;
    return dataSource.addExpense(expense);
  }

  //get expenses
  Future<List<Expense>> getExpenses() async {
    final dataSource = await localDataSource;
    return dataSource.getExpenses();
  }

  //update expense
  Future<void> updateExpense(Expense expense) async {
    final dataSource = await localDataSource;
    return dataSource.updateExpense(expense);
  }
}
