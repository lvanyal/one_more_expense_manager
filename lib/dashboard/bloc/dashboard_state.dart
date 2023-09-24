// ignore_for_file: public_member_api_docs, sort_constructors_first
// Dashboard state with selected month, budget, spent money and list of expenses.
import 'dart:convert';

import 'package:copilot/model/dashboard_data.dart';
import 'package:copilot/model/expense.dart';

sealed class DashboardState {}

class DashboardStateInitial extends DashboardState {}

class DashboardStateLoading extends DashboardState {}

class DashboardStateError extends DashboardState {
  // Error message.
  final String message;

  // Constructor.
  DashboardStateError(
    this.message,
  ) : super() {
    @override
    String toString() => 'DashboardStateError(message: $message)';
  }
}

class DashboardStateLoaded extends DashboardState {
  final DashboardData dashboardData;

  // Constructor.
  DashboardStateLoaded({required this.dashboardData}) : super();

  // Copy of the state with new selected month.
  DashboardStateLoaded copyWith({
    DateTime? selectedMonth,
    double? budget,
    double? spentMoney,
    List<Expense>? expenses,
  }) {
    return DashboardStateLoaded(
      dashboardData: dashboardData,
    );
  }
}
