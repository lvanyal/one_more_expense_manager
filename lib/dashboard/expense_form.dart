// Dashboard screen with circular diagram at the top that shows money spent already this month and the rest of budget. And list of expenses below.

import 'package:copilot/model/category.dart';
import 'package:copilot/model/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm(
    this.categories, {
    this.expense,
    super.key,
  });

  final List<Category> categories;
  final Expense? expense;

  @override
  State<ExpenseForm> createState() => ExpenseFormState();
}

class ExpenseFormState extends State<ExpenseForm> {
  Category? _selectedCategory;

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    _selectedCategory = widget.expense?.category ?? widget.categories.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            right: 8,
            left: 8,
            top: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Expense name input.
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    child: FormBuilderTextField(
                      autofocus: true,
                      // focusNode: focusNode,
                      name: 'budget',
                      onChanged: (value) {},
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                      //outlined decoration
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.next,
                      initialValue:
                          widget.expense?.amount.toString() ?? 100.toString(),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                      ]),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    child: FormBuilderTextField(
                      name: 'description',
                      autofocus: false,
                      onChanged: (value) {},
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                      initialValue: widget.expense?.description,
                      //outlined decoration
                      decoration: InputDecoration(
                        labelText: 'Description',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 8),
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),

                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minWordsCount(1),
                      ]),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              // Expense amount input.
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 8.0,
                  children: [
                    // Expense date input.
                    Container(
                        margin: const EdgeInsets.only(top: 4),
                        width: 100,
                        height: 40,
                        alignment: Alignment.center,
                        child: FormBuilderDateTimePicker(
                          name: 'date',
                          onChanged: (value) {}, scrollPadding: EdgeInsets.zero,
                          initialDate: DateTime.now(),
                          initialValue: widget.expense?.date ?? DateTime.now(),
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                          //outlined decoration
                          decoration: InputDecoration(
                            hintText: 'Date',
                            floatingLabelAlignment:
                                FloatingLabelAlignment.center,
                            labelText: 'Date',
                            contentPadding: const EdgeInsets.all(2.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          inputType: InputType.date,

                          format: DateFormat('dd MMM'),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                        )),
                    const SizedBox(
                      width: 1,
                    ),
                    ...widget.categories.map((category) {
                      return ChoiceChip(
                        avatar: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(category.icon),
                        ),
                        label: Text(category.name),
                        showCheckmark: false,
                        selectedColor: category.color,
                        backgroundColor: category.color.withOpacity(0.2),
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        selected: _selectedCategory == category,
                      );
                    }).toList()
                  ],
                ),
              ),
              // Expense date input.
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      final valid =
                          _formKey.currentState?.saveAndValidate() ?? false;
                      if (valid) {
                        final expense = Expense(
                          id: widget.expense?.id ?? DateTime.now().toString(),
                          amount: double.parse(
                              _formKey.currentState?.value['budget'] ?? '0'),
                          description:
                              _formKey.currentState?.value['description'] ?? '',
                          date: _formKey.currentState?.value['date'] ??
                              DateTime.now(),
                          category: _selectedCategory!,
                        );
                        Navigator.of(context)
                            .pop(ExpenseFormResult(expense: expense));
                      }
                    },
                    child: Text(
                      widget.expense != null ? 'Update' : 'Save',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  if (widget.expense != null)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(ExpenseFormResult(isRemoved: true));
                      },
                      child: Text(
                        'Remove',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpenseFormResult {
  final Expense? expense;
  final bool? isRemoved;

  ExpenseFormResult({this.expense, this.isRemoved});
}
