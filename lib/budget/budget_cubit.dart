import 'package:copilot/budget/budget_state.dart';
import 'package:copilot/data/budget_repository.dart';
import 'package:copilot/data/categories_repository.dart';
import 'package:copilot/model/category.dart';
import 'package:copilot/model/category_limit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetCubit extends Cubit<BudgetState> {
  BudgetCubit(this.budgetRepository, this.categoriesRepository)
      : super(BudgetStateInitial()) {
    getBudget();
    categoriesRepository.addListener(() {
      getBudget();
    });
  }

  final BudgetRepository budgetRepository;
  final CategoriesRepository categoriesRepository;

  void getBudget() async {
    try {
      final budget = await budgetRepository.getBudget();
      final allCategories = await categoriesRepository.getCategories();
      final budgetCategories = budget.limitPerCategory;

      //all categories with selected and limit
      final allCategoriesWithSelectedAndLimitEntries =
          allCategories.map((category) {
        final categoryLimit = budgetCategories[category];

        return MapEntry(category,
            categoryLimit ?? CategoryLimit(limit: 100, selected: false));
      });

      final allCategoriesWithSelectedAndLimit =
          Map<Category, CategoryLimit>.fromEntries(
              allCategoriesWithSelectedAndLimitEntries);

      emit(BudgetStateLoaded(
          budget: budget, categories: allCategoriesWithSelectedAndLimit));
    } catch (e) {
      emit(BudgetStateError(e.toString()));
    }
  }

  void updateCategory(Category key, bool selected, double limit) async {
    final currentState = state;
    if (currentState is BudgetStateLoaded) {
      final newCategoriesLlimits = currentState.categories.map(
          (category, categoryLimit) => MapEntry(
              category,
              category == key
                  ? categoryLimit.copyWith(selected: selected, limit: limit)
                  : categoryLimit));

      // update budget in db
      final newBudget =
          currentState.budget.copyWith(limitPerCategory: newCategoriesLlimits);
      await budgetRepository.saveBudgetForCurrentMonth(newBudget);

      emit(BudgetStateLoaded(
          budget: currentState.budget, categories: newCategoriesLlimits));
    }
  }

  void updateBudget(double parse) async {
    final currentState = state;
    if (currentState is BudgetStateLoaded) {
      final newBudget = currentState.budget.copyWith(amount: parse);
      await budgetRepository.saveBudgetForCurrentMonth(newBudget);
      emit(BudgetStateLoaded(
          budget: newBudget, categories: currentState.categories));
    }
  }
}
