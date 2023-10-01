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
      final categories = await categoriesRepository.getCategories();

      // Categories hashmap. Where key is category and value if it's selected
      final categoriesMap = Map.fromEntries(categories
          .map((e) => MapEntry(e, CategoryLimit(limit: 100, selected: false))));

      emit(BudgetStateLoaded(budget: budget, categories: categoriesMap));
    } catch (e) {
      emit(BudgetStateError(e.toString()));
    }
  }

  void updateCategory(Category key, bool selected, double limit) {
    final currentState = state;
    if (currentState is BudgetStateLoaded) {
      final newCategories =
          Map<Category, CategoryLimit>.from(currentState.categories)
            ..[key] = CategoryLimit(selected: selected, limit: limit);
      emit(BudgetStateLoaded(
          budget: currentState.budget, categories: newCategories));
    }
  }

  void updateBudget(double parse) {
    final currentState = state;
    if (currentState is BudgetStateLoaded) {
      final newBudget = currentState.budget.copyWith(amount: parse);
      emit(BudgetStateLoaded(
          budget: newBudget, categories: currentState.categories));
    }
  }
}
