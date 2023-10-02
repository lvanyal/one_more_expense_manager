// ignore_for_file: public_member_api_docs, sort_constructors_first
// Dashboard state with selected month, budget, spent money and list of expenses.

import 'package:copilot/model/category.dart';
import 'package:copilot/model/dashboard_data.dart';

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
  final List<Category> categories;

  // Constructor.
  DashboardStateLoaded({
    required this.dashboardData,
    required this.categories,
  }) : super();
}
