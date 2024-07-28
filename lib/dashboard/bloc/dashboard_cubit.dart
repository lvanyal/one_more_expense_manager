import 'dart:math';

import 'package:copilot/dashboard/bloc/dashboard_state.dart';
import 'package:copilot/data/categories_repository.dart';
import 'package:copilot/data/dashboard_repository.dart';
import 'package:copilot/data/expense_repository.dart';
import 'package:copilot/model/expense.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this.dashboardRepository, this.categoriesRepository,
      this.expenseRepository)
      : super(DashboardStateInitial()) {
    getDashboardData(DateTime.now());
  }

  final DashboardRepository dashboardRepository;
  final CategoriesRepository categoriesRepository;
  final ExpenseRepository expenseRepository;

  void getDashboardData(DateTime selectedMonth) async {
    emit(DashboardStateLoading());
    try {
      final dashboardData =
          await dashboardRepository.getDashboardData(selectedMonth);
      final categories = await categoriesRepository.getCategories();

      emit(DashboardStateLoaded(
          dashboardData: dashboardData, categories: categories));
    } catch (e) {
      emit(DashboardStateError(e.toString()));
    }
  }

  void nextMonth() {
    final currentState = state;
    if (currentState is DashboardStateLoaded) {
      final newSelectedMonth = DateTime(
        currentState.dashboardData.selectedMonth.year,
        currentState.dashboardData.selectedMonth.month + 1,
      );
      getDashboardData(newSelectedMonth);
    }
  }

  void previousMonth() {
    final currentState = state;
    if (currentState is DashboardStateLoaded) {
      final newSelectedMonth = DateTime(
        currentState.dashboardData.selectedMonth.year,
        currentState.dashboardData.selectedMonth.month - 1,
      );
      getDashboardData(newSelectedMonth);
    }
  }

  void addExpense(Expense expense) async {
    final currentState = state;
    if (currentState is DashboardStateLoaded) {
      expenseRepository.addExpense(expense);
      final dashboardData = await dashboardRepository
          .getDashboardData(currentState.dashboardData.selectedMonth);

      emit(DashboardStateLoaded(
        dashboardData: dashboardData,
        categories: currentState.categories,
      ));
    }
  }

  // update expense
  void updateExpense(Expense expense) async {
    final currentState = state;
    if (currentState is DashboardStateLoaded) {
      expenseRepository.updateExpense(expense);
      final dashboardData = await dashboardRepository
          .getDashboardData(currentState.dashboardData.selectedMonth);

      emit(DashboardStateLoaded(
        dashboardData: dashboardData,
        categories: currentState.categories,
      ));
    }
  }

  void removeExpense(Expense expense) async{
    final currentState = state;
    if (currentState is DashboardStateLoaded) {
      expenseRepository.removeExpense(expense);
      final dashboardData = await dashboardRepository
          .getDashboardData(currentState.dashboardData.selectedMonth);

      emit(DashboardStateLoaded(
        dashboardData: dashboardData,
        categories: currentState.categories,
      ));
    }
  }
}
