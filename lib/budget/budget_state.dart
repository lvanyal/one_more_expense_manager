// Budget screen state
import 'package:copilot/model/budget.dart';
import 'package:copilot/model/category.dart';
import 'package:copilot/model/category_limit.dart';

sealed class BudgetState {}

class BudgetStateInitial extends BudgetState {}

class BudgetStateLoading extends BudgetState {}

class BudgetStateLoaded extends BudgetState {
  BudgetStateLoaded({
    required this.categories,
    required this.budget,
  });

  final Budget budget;
  final Map<Category, CategoryLimit> categories;
}

class BudgetStateError extends BudgetState {
  BudgetStateError(this.message);

  final String message;
}

