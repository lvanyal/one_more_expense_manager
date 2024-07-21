// Dashboard screen with circular diagram at the top that shows money spent already this month and the rest of budget. And list of expenses below.

import 'package:copilot/dashboard/bloc/dashboard_cubit.dart';
import 'package:copilot/dashboard/bloc/dashboard_state.dart';
import 'package:copilot/dashboard/expense_form.dart';
import 'package:copilot/infrastructure/extensions.dart';
import 'package:copilot/model/expense.dart';
import 'package:copilot/widget/month_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pie_chart/pie_chart.dart';

final _monthFormatter = DateFormat("MMMM");

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  static const String routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DashboardCubit>();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // The FAB button with plus icon in the bottom right corner.
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffac255e),
        onPressed: () async {
          final state = cubit.state;
          if (state is DashboardStateLoaded) {
            final expense = await showModalBottomSheet<Expense?>(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return ExpenseForm(
                  state.categories,
                );
              },
            );
            if (expense != null) {
              cubit.addExpense(expense);
            }
          }
        },
        tooltip: 'Add expense',
        child: const Icon(Icons.add),
      ),
      // The body of the screen with circular diagram at the top that shows money spent already this month and the rest of budget. And list of expenses below.
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (_, state) {
          return switch (state) {
            DashboardStateInitial() ||
            DashboardStateLoading() =>
              const LoadingShimmer(),
            DashboardStateError() => const Placeholder(),
            DashboardStateLoaded() => Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                      Color(0xff1f005c),
                      Color(0xff5b0060),
                      Color(0xff870160),
                      Color(0xffac255e),
                      Color(0xffca485c),
                      Color(0xffe16b5c),
                      Color(0xfff39060),
                      Color(0xffffb56b),
                    ],
                    // Gradient from https://learnui.design/tools/gradient-generator.html
                    tileMode: TileMode.mirror,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    // Circular diagram at the top that shows money spent already this month and the rest of budget.
                    const SizedBox(
                      height: 54,
                    ),
                    _CircularDiagram(state),
                    // List of expenses below.
                    const SizedBox(
                      height: 24,
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Color(0xFF1a1a1a),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24.0),
                                topRight: Radius.circular(24.0)),
                            boxShadow: [BoxShadow()]),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            _MonthSelector(state),
                            _ExpensesList(state),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
          };
        },
      ),
    );
  }
}

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: Colors.grey.withOpacity(0.6),
      enabled: true,
      child: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 24,
            ),
            Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
                height: 60,
                width: 150,
                decoration: const BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.white)),
            const SizedBox(
              height: 16,
            ),
            Container(
                height: 60,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: const BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.white)),
            Container(
                height: 60,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: const BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.white)),
            Container(
                height: 60,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: const BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.white)),
            Container(
                height: 60,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: const BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class _MonthSelector extends StatelessWidget {
  final DashboardStateLoaded state;

  const _MonthSelector(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DashboardCubit>();
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton.outlined(
                onPressed: () {
                  context.read<DashboardCubit>().previousMonth();
                },
                icon: const Icon(Icons.chevron_left)),
            OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final selectedMonth = await showMonthPicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2050),
                  );
                  if (selectedMonth != null) {
                    cubit.getDashboardData(selectedMonth);
                  }
                },
                label: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    //Format date, take name of the month. Example: January 2021.
                    _monthFormatter.format(state.dashboardData.selectedMonth),
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                )),
            IconButton.outlined(
                onPressed: () {
                  context.read<DashboardCubit>().nextMonth();
                },
                icon: const Icon(Icons.chevron_right)),
          ],
        ),
      ),
    );
  }
}

// Circular diagram at the top that shows money spent already this month and the rest of budget.
class _CircularDiagram extends StatelessWidget {
  final DashboardStateLoaded state;

  const _CircularDiagram(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      SizedBox.square(
        dimension: 248,
        child: PieChart(
          dataMap: {
            'spent': state.dashboardData.spentMoney,
          },
          legendOptions: const LegendOptions(
            showLegends: false,
          ),
          chartType: ChartType.ring,
          baseChartColor: Colors.grey[50]!.withOpacity(0.15),
          colorList: [context.colorScheme.primary, Colors.white38],
          ringStrokeWidth: 8,
          chartValuesOptions: const ChartValuesOptions(
            showChartValuesOutside: false,
            showChartValues: false,
            showChartValuesInPercentage: false,
          ),
          totalValue: state.dashboardData.budget.amount,
        ),
      ),
      Column(
        children: [
          Text(
            '\$${state.dashboardData.spentMoney.toInt()}',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w700, fontSize: 32),
          ),
          SizedBox(
            width: 150,
            child: Divider(
              thickness: 2,
              color: context.colorScheme.onPrimary,
            ),
          ),
          Text(
            '\$${state.dashboardData.budget.amount.toInt().toString()}',
            style: GoogleFonts.montserrat(
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w500, fontSize: 24),
            ),
          ),
        ],
      )
    ]);
  }
}

// List of expenses below.
class _ExpensesList extends StatelessWidget {
  const _ExpensesList(
    this.state, {
    Key? key,
  }) : super(key: key);

  final DashboardStateLoaded state;

  @override
  Widget build(BuildContext context) {
    // List of expenses below.
    return Expanded(
      child: ListView.builder(
        itemCount: state.dashboardData.expenses.length,
        itemBuilder: (BuildContext context, int index) {
          final expense = state.dashboardData.expenses[index];
          return ExpenseListItem(expense: expense);
        },
      ),
    );
  }
}

class ExpenseListItem extends StatelessWidget {
  const ExpenseListItem({
    super.key,
    required this.expense,
  });

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DashboardCubit>();

    return ListTile(
      onTap: () async {
        final state = cubit.state;
        if (state is DashboardStateLoaded) {
          final expense = await showModalBottomSheet<Expense?>(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return ExpenseForm(
                state.categories,
                expense: this.expense,
              );
            },
          );
          if (expense != null) {
            cubit.updateExpense(expense);
          }
        }
      },
      leading: CircleAvatar(
          radius: 24,
          backgroundColor: expense.category.color.withOpacity(0.4),
          child: Icon(
            expense.category.icon,
            color: Theme.of(context).colorScheme.primary,
          )),
      title: Text(
        expense.description,
        style: GoogleFonts.lato(
          textStyle: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      subtitle: Text(expense.category.name,
          style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.bodySmall,
          )),
      trailing: Text(
        '\$${expense.amount}',
        style: GoogleFonts.montserrat(
          textStyle: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
