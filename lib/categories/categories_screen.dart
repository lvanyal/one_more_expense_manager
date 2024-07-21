// Categories page with list of categories.

import 'package:copilot/categories/categories_cubit.dart';
import 'package:copilot/categories/categories_state.dart';
import 'package:copilot/model/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class CategoriesScreen extends StatelessWidget {
  // Categories screen route.
  static const String route = '/categories';

  // Categories screen title.
  static const String title = 'Categories';

  // Categories screen subtitle.
  static const String subtitle = 'Manage your categories';

  // Categories screen icon.
  static const IconData icon = Icons.category;

  // Categories screen constructor.
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoriesCubit = BlocProvider.of<CategoriesCubit>(context);
    // Categories screen body.
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (BuildContext context, CategoriesState state) {
        // If state is CategoriesStateLoading, then show loading indicator.
        if (state is CategoriesStateLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // If state is CategoriesStateError, then show error message.
        if (state is CategoriesStateError) {
          return Center(
            child: Text(state.message),
          );
        }

        // If state is CategoriesStateLoaded, then show categories list.
        if (state is CategoriesStateLoaded) {
          return ListView.builder(
            itemCount: state.categories.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == state.categories.length) {
                return const _CreateCategoryItem();
              }

              // Category.
              final category = state.categories[index];

              if (state.editedCategory?.id == category.id) {
                // Editable Category tile.
                return EditableCategoryItem(
                    key: ValueKey('${category.id}editable'),
                    category: category);
              } //the last item is an add new category button
              else {
                // Category tile.
                return Dismissible(
                  key: ValueKey(category.id),
                  onDismissed: (direction) {
                    categoriesCubit.deleteCategory(category);
                  },
                  //backgorund when swiping. red background with trash icons on side
                  background: Container(
                    color: Colors.red,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  child: CategoryItem(
                      category: category, categoriesCubit: categoriesCubit),
                );
              }
            },
          );
        }

        // Otherwise, show empty container.
        return Container();
      },
    );
  }
}

class _CreateCategoryItem extends StatelessWidget {
  const _CreateCategoryItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: const ValueKey('add_category'),
      // Category title.
      title: GestureDetector(
          onTap: () {
            context.read<CategoriesCubit>().addCategory(_generateNewCaterory());
          },
          child: Text('Add new category',
              style: Theme.of(context).textTheme.bodyMedium)),

      // Category icon.
      leading: Icon(
        Icons.add,
        color: Theme.of(context).colorScheme.primary,
      ),
      // Category trailing.
      trailing: IconButton(
        // Category edit button.
        icon: const Icon(Icons.add),
        onPressed: () {
          context.read<CategoriesCubit>().addCategory(_generateNewCaterory());
        },
      ),
    );
  }
}

Category _generateNewCaterory() {
  return Category(
    name: 'New category',
    color: Colors.blue,
    icon: Icons.category,
    id: DateTime.now().toString(),
  );
}

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.category,
    required this.categoriesCubit,
  });

  final Category category;
  final CategoriesCubit categoriesCubit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Category title.
      title: GestureDetector(
          onTap: () => categoriesCubit.editCategory(category),
          child: Text(category.name,
              style: Theme.of(context).textTheme.bodyMedium)),

      // Category icon.
      leading: Icon(
        category.icon,
        color: category.color,
      ),
      // Category trailing.
      trailing: IconButton(
        // Category edit button.
        icon: const Icon(Icons.edit),
        onPressed: () {
          categoriesCubit.editCategory(category);
        },
      ),
    );
  }
}

class EditableCategoryItem extends StatefulWidget {
  const EditableCategoryItem({
    super.key,
    required this.category,
  });

  final Category category;

  @override
  State<EditableCategoryItem> createState() => _EditableCategoryItemState();
}

class _EditableCategoryItemState extends State<EditableCategoryItem> {
//temporary icon, color and name
  IconData? temporaryIcon;
  Color? temporaryColor;
  TextEditingController temporaryName = TextEditingController();

  @override
  void initState() {
    temporaryIcon = widget.category.icon;
    temporaryColor = widget.category.color;
    temporaryName.text = widget.category.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Category title.
      title: TextFormField(
        controller: temporaryName,
        decoration: const InputDecoration(
          labelText: 'Category name',
        ),
      ),

      // Category icon.
      leading: IconButton(
        icon: Icon(
          temporaryIcon,
          color: temporaryColor,
        ),
        onPressed: () async {
          IconData? icon = await showIconPicker(context, iconPackModes: [
            IconPack.fontAwesomeIcons,
            IconPack.cupertino,
            IconPack.material,
          ]);
          if (!context.mounted) return;
          final color = await _openColorPicker(context);

          setState(() {
            temporaryIcon = icon ?? temporaryIcon;
            temporaryColor = color ?? temporaryColor;
          });
        },
      ),
      // Category trailing.
      trailing: IconButton(
        // Category edit button.
        icon: const Icon(Icons.check),
        onPressed: () {
          final category = widget.category.copyWith(
            name: temporaryName.text,
            icon: temporaryIcon,
            color: temporaryColor,
          );
          context.read<CategoriesCubit>().updateCategory(category);
        },
      ),
    );
  }

  Future<Color?> _openColorPicker(BuildContext context) {
    var color = Theme.of(context).colorScheme.primary;
    final picker = MaterialColorPicker(
      selectedColor: color,
      onColorChange: (col) => {color = col},
      onMainColorChange: (color) => {},
    );
    return showDialog<Color>(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(18.0),
          title: const Text('Select color'),
          content: picker,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, color);
              },
              child: const Text('SELECT'),
            ),
          ],
        );
      },
    );
  }
}
