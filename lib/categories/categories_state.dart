// CategoriesState is the state class for the CategoriesBloc.
// It is a sealed class, which means that it can have only the following subclasses:
// CategoriesStateInitial
// CategoriesStateLoading
// CategoriesStateError
// CategoriesStateLoaded
//
import 'package:copilot/model/category.dart';

sealed class CategoriesState {}

class CategoriesStateInitial extends CategoriesState {}

class CategoriesStateLoading extends CategoriesState {}

class CategoriesStateError extends CategoriesState {
  // Error message.
  final String message;

  // Constructor.
  CategoriesStateError(
    this.message,
  ) : super() {
    @override
    String toString() => 'CategoriesStateError(message: $message)';
  }
}

class CategoriesStateLoaded extends CategoriesState {
  // List of categories.
  final List<Category> categories;
  final bool categoryCreation;
  final Category? editedCategory;

  CategoriesStateLoaded(
      {required this.categories,
      this.categoryCreation = false,
      this.editedCategory});

  // Copy of the state with new categories.
  CategoriesStateLoaded copyWith({
    List<Category>? categories,
    bool? categoryCreation,
    Category? editedCategory,
  }) {
    return CategoriesStateLoaded(
      categories: categories ?? this.categories,
      categoryCreation: categoryCreation ?? this.categoryCreation,
      editedCategory: editedCategory ?? this.editedCategory,
    );
  }
}
