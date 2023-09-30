// CategoriesCubit is a Cubit class which manages the state of the categories.

import 'package:copilot/categories/categories_state.dart';
import 'package:copilot/data/categories_repository.dart';
import 'package:copilot/model/category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit(
    this.categoriesRepository,
  ) : super(CategoriesStateInitial()) {
    getCategories();
  }

  final CategoriesRepository categoriesRepository;

  void getCategories() async {
    emit(CategoriesStateLoading());
    try {
      final categories = await categoriesRepository.getCategories();
      emit(CategoriesStateLoaded(categories: categories));
    } catch (e) {
      emit(CategoriesStateError(e.toString()));
    }
  }

  void addCategory(Category category) async {
    try {
      await categoriesRepository.addCategory(category);
      final currentState = state;
      if (currentState is CategoriesStateLoaded) {
        final newCategories = [...currentState.categories, category];
        emit(CategoriesStateLoaded(categories: newCategories));
      }
    } catch (e) {
      emit(CategoriesStateError(e.toString()));
    }
  }

  void updateCategory(Category category) async {
    emit(CategoriesStateLoading());
    try {
      await categoriesRepository.updateCategory(category);

      final newCategories = await categoriesRepository.getCategories();
      emit(CategoriesStateLoaded(categories: newCategories));
    } catch (e) {
      emit(CategoriesStateError(e.toString()));
    }
  }

  void deleteCategory(Category category) async {
    try {
      await categoriesRepository
          .updateCategory(category.copyWith(deleted: true));
      final currentState = state;
      if (currentState is CategoriesStateLoaded) {
        final newCategories =
            currentState.categories.where((e) => e.id != category.id).toList();
        emit(CategoriesStateLoaded(categories: newCategories));
      }
    } catch (e) {
      emit(CategoriesStateError(e.toString()));
    }
  }

  void editCategory(Category category) {
    final currentState = state;
    if (currentState is CategoriesStateLoaded) {
      emit(CategoriesStateLoaded(
        categories: currentState.categories,
        categoryCreation: currentState.categoryCreation,
        editedCategory: category,
      ));
    }
  }
}
