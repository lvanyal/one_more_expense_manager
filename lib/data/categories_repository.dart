import 'package:copilot/data/local_data_source.dart';
import 'package:copilot/model/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesRepository extends ValueNotifier<List<Category>> {
  final Future<LocalDataSource> localDataSource;

  CategoriesRepository({required this.localDataSource}) : super([]);

  Future<List<Category>> getCategories() async {
    final dataSource = await localDataSource;
    return dataSource
        .getCategories()
        .where((element) => false == element.deleted)
        .toList();
  }

  Future<void> addCategory(Category category) async {
    final dataSource = await localDataSource;
    final categories = dataSource.getCategories();
    final newCategories = [...categories, category];
    await dataSource.saveCategories(newCategories);
    notifyListeners();
  }

  Future<void> updateCategory(Category category) async {
    final dataSource = await localDataSource;
    final categories = dataSource.getCategories();
    final newCategories =
        categories.map((e) => e.id == category.id ? category : e).toList();
    await dataSource.saveCategories(newCategories);
    notifyListeners();
  }
}
