// Class that uses SharedPreferences to store and retrieve user data: categories list, expenses list, and budget.

import 'package:copilot/model/budget.dart';
import 'package:copilot/model/category.dart';
import 'package:copilot/model/expense.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  // SharedPreferences instance.
  final SharedPreferences _sharedPreferences;

  // Key for storing categories list.
  static const String _categoriesKey = 'categories';

  // Key for storing expenses list.
  static const String _expensesKey = 'expenses';

  // Key for storing budget.
  static const String _budgetKey = 'budget';

  // Constructor.
  const LocalDataSource(this._sharedPreferences);

  // Returns categories list from SharedPreferences.
  List<Category> getCategories() {
    final List<String> categoriesStringList =
        _sharedPreferences.getStringList(_categoriesKey) ?? <String>[];
    return categoriesStringList
        .map((String categoryString) => Category.fromJson(categoryString))
        .toList();
  }

  // Saves categories list to SharedPreferences.
  Future<void> saveCategories(List<Category> categories) async {
    final List<String> categoriesStringList =
        categories.map((Category category) => category.toJson()).toList();
    await _sharedPreferences.setStringList(
      _categoriesKey,
      categoriesStringList,
    );
  }

  // Returns expenses list from SharedPreferences.
  List<Expense> getExpenses() {
    final List<String> expensesStringList =
        _sharedPreferences.getStringList(_expensesKey) ?? <String>[];
    return expensesStringList
        .map((String expenseString) => Expense.fromJson(expenseString))
        .toList();
  }

  // Saves expenses list to SharedPreferences.
  Future<void> saveExpenses(List<Expense> expenses) async {
    final List<String> expensesStringList =
        expenses.map((Expense expense) => expense.toJson()).toList();
    await _sharedPreferences.setStringList(
      _expensesKey,
      expensesStringList,
    );
  }

  //Get expenses for specific month
  List<Expense> getExpensesForMonth(DateTime month) {
    final List<Expense> expenses = getExpenses();
    return expenses
        .where((Expense expense) =>
            expense.date.month == month.month &&
            expense.date.year == month.year)
        .toList();
  }

  //Get expenses for specific category
  List<Expense> getExpensesForCategory(Category category) {
    final List<Expense> expenses = getExpenses();
    return expenses
        .where((Expense expense) => expense.category.id == category.id)
        .toList();
  }

  //get spent money for specific month
  double getSpentMoneyForMonth(DateTime month) {
    final List<Expense> expenses = getExpensesForMonth(month);
    return expenses.fold<double>(
      0,
      (double previousValue, Expense element) => previousValue + element.amount,
    );
  }

  //Delete expense
  Future<void> deleteExpense(Expense expense) async {
    final List<Expense> expenses = getExpenses();
    expenses.removeWhere((Expense e) => e.id == expense.id);
    await saveExpenses(expenses);
  }

  //delete category
  Future<void> deleteCategory(Category category) async {
    final List<Category> categories = getCategories();
    categories.removeWhere((Category c) => c.id == category.id);
    await saveCategories(categories);
  }

  //Save budget for specific month
  Future<void> saveBudgetForMonth(DateTime month, Budget budget) async {
    await _sharedPreferences.setString(
      _budgetKey + month.month.toString() + month.year.toString(),
      budget.toJson(),
    );
  }

  //get budget for specific month
  Budget getBudgetForMonth(DateTime month) {
    final String? budgetString = _sharedPreferences.getString(
      _budgetKey + month.month.toString() + month.year.toString(),
    );
    if (budgetString == null) {
      return const Budget(amount: 0, limitPerCategory: {});
    }
    return Budget.fromJson(budgetString);
  }

  // Calculate and returns total expenses amount.
  double getTotalExpensesAmount() {
    final List<Expense> expenses = getExpenses();
    return expenses.fold<double>(
      0,
      (double previousValue, Expense element) => previousValue + element.amount,
    );
  }

  //Save budget for specific month
  Future<void> saveBudget(Budget budget) async {
    await _sharedPreferences.setString(
      _budgetKey,
      budget.toJson(),
    );
  }

  //add Expense
  Future<void> addExpense(Expense expense) async {
    final List<Expense> expenses = getExpenses();
    expenses.add(expense);
    await saveExpenses(expenses);
  }

  //update expense
  Future<void> updateExpense(Expense expense) async {
    final List<Expense> expenses = getExpenses();
    final int index = expenses.indexWhere((Expense e) => e.id == expense.id);
    expenses[index] = expense;
    await saveExpenses(expenses);
  }

  // clears SharedPreferences.
  Future<void> clear() async {
    await _sharedPreferences.clear();
  }

  //Function that generates random initial data for budget, categories and expenses. and saves them to SharedPreferences.
  Future<void> generateInitialData() async {
    // if data already exists, do nothing
    if (_sharedPreferences.getKeys().isNotEmpty) {
      return;
    }

    await saveBudgetForMonth(
        DateTime.now(), const Budget(amount: 1000,  limitPerCategory: {}));
    await saveCategories(
      <Category>[
        const Category(
          name: 'Food',
          color: Color(0xFFEF9A9A),
          icon: Icons.fastfood,
          id: '1',
        ),
        const Category(
          name: 'Transport',
          color: Color(0xFF80CBC4),
          icon: Icons.directions_bus,
          id: '2',
        ),
        const Category(
          name: 'Entertainment',
          color: Color(0xFFCE93D8),
          icon: Icons.movie,
          id: '3',
        ),
        const Category(
          name: 'Clothes',
          color: Color(0xFF90CAF9),
          icon: Icons.shopping_basket,
          id: '4',
        ),
        const Category(
          name: 'Health',
          color: Color(0xFFA5D6A7),
          icon: Icons.local_hospital,
          id: '5',
        ),
        const Category(
          name: 'Beauty',
          color: Color(0xFFFFAB91),
          icon: Icons.face,
          id: '6',
        ),
        const Category(
          name: 'Other',
          color: Color(0xFFE6EE9C),
          icon: Icons.category,
          id: '7',
        ),
      ],
    );
    await saveExpenses(<Expense>[
      Expense(
        description: 'Pizza',
        amount: 10,
        date: DateTime.now(),
        category: const Category(
          name: 'Food',
          color: Color(0xFFEF9A9A),
          icon: Icons.fastfood,
          id: '1',
        ),
        id: '1',
      ),
      Expense(
        description: 'Bus',
        amount: 2,
        date: DateTime.now(),
        category: const Category(
          name: 'Transport',
          color: Color(0xFF80CBC4),
          icon: Icons.directions_bus,
          id: '2',
        ),
        id: '2',
      ),
      Expense(
          description: 'Cinema',
          amount: 15,
          id: '3',
          date: DateTime.now(),
          category: const Category(
            name: 'Entertainment',
            color: Color(0xFFCE93D8),
            icon: Icons.movie,
            id: '3',
          ))
    ]);
  }
}
