import 'package:copilot/data/local_data_source.dart';
import 'package:copilot/model/category.dart';

class CategoriesRepository {
  final Future<LocalDataSource> localDataSource;

  CategoriesRepository({required this.localDataSource});

  Future<List<Category>> getCategories() async {
    final dataSource = await localDataSource;
    return dataSource
        .getCategories()
        .where((element) => false == element.deleted)
        .toList();
  }

  Future<void> addCategory(Category category) async {
    final dataSource = await localDataSource;
    final categories =  dataSource.getCategories();
    final newCategories = [...categories, category];
    await dataSource.saveCategories(newCategories);
  }

  Future<void> updateCategory(Category category) async {
    final dataSource = await localDataSource;
    final categories = dataSource.getCategories();
    final newCategories =
        categories.map((e) => e.id == category.id ? category : e).toList();
    await dataSource.saveCategories(newCategories);
  }

}
