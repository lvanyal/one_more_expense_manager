import 'package:copilot/budget/budget_cubit.dart';
import 'package:copilot/budget/budget_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

final _formKey = GlobalKey<FormBuilderState>();
final _emailFieldKey = GlobalKey();

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Budget form. Contains total budget input and budget limits for each category.

    return BlocBuilder<BudgetCubit, BudgetState>(
      builder: (context, state) {
        return switch (state) {
          BudgetStateInitial() || BudgetStateLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          BudgetStateError() => const Placeholder(),
          BudgetStateLoaded() => _LoadedScreen(state)
        };
      },
    );
  }
}

class _LoadedScreen extends StatelessWidget {
  const _LoadedScreen(
    this.state, {
    super.key,
  });

  final BudgetStateLoaded state;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: FormBuilderTextField(
                key: _emailFieldKey,
                name: 'budget',
                onChanged: (value) {
                  final budget = double.tryParse(value as String) ?? 0.0;
                  context.read<BudgetCubit>().updateBudget(budget);
                  _validateForm();
                },
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                //outlined decoration
                decoration: InputDecoration(
                  labelText: 'Budget',
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                initialValue: 1000.toString(),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                  categoryLimitsValidator(
                      errorText: 'Budget exceeded', state: state)
                ]),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              children: state.categories.entries.map((entry) {
                return FilterChip(
                  avatar: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(entry.key.icon),
                  ),
                  label: Text(entry.key.name),
                  showCheckmark: false,
                  selectedColor: entry.key.color,
                  backgroundColor: entry.key.color.withOpacity(0.2),
                  selected: entry.value.selected,
                  onSelected: (bool selected) {
                    final cubit = context.read<BudgetCubit>();
                    cubit.updateCategory(entry.key, selected, 100);
                    _validateForm();
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // ListView of selected categories.
            Expanded(
              child: ListView.builder(
                itemCount: state.categories.entries
                    .where((e) => e.value.selected)
                    .length,
                itemBuilder: (BuildContext context, int index) {
                  final entry = state.categories.entries
                      .where((e) => e.value.selected)
                      .elementAt(index);
                  return ListTile(
                    key: ValueKey(entry.key.id),
                    leading: CircleAvatar(
                      backgroundColor: entry.key.color.withOpacity(0.4),
                      child: Icon(
                        entry.key.icon,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    title: Text(
                      entry.key.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: SizedBox(
                      width: 80,
                      child: FormBuilderTextField(
                        key: ValueKey(entry.key.id),
                        name: entry.key.id,
                        textAlign: TextAlign.center,
                        //outlined decoration
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(2),
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        initialValue: 100.toString(),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                        ]),
                        onChanged: (newValue) {
                          final limit =
                              double.tryParse(newValue as String) ?? 0.0;
                          context
                              .read<BudgetCubit>()
                              .updateCategory(entry.key, true, limit);
                          _validateForm();
                        },
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _validateForm() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _formKey.currentState?.saveAndValidate());
  }

  FormFieldValidator<T> categoryLimitsValidator<T>({
    required BudgetStateLoaded state,
    required String errorText,
  }) {
    return (T? valueCandidate) {
      // returns error text if sum of category limits is greater than total budget
      var sum = state.categories.entries
          .where((e) => e.value.selected)
          .map((e) => e.value.limit)
          .fold<double>(0, (previousValue, element) => previousValue + element);
      if (sum > state.budget.amount) {
        return errorText;
      }

      return null;
    };
  }
}
