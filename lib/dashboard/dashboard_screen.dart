// Dashboard screen with circular diagram at the top that shows money spent already this month and the rest of budget. And list of expenses below.

import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:copilot/dashboard/bloc/dashboard_cubit.dart';
import 'package:copilot/dashboard/bloc/dashboard_state.dart';
import 'package:copilot/model/expense.dart';
import 'package:copilot/widget/month_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

final _monthFormatter = DateFormat("MMMM");

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  static const String routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // The FAB button with plus icon in the bottom right corner.
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
            DashboardStateLoaded() => Column(
                children: <Widget>[
                  // Circular diagram at the top that shows money spent already this month and the rest of budget.
                  _CircularDiagram(state),
                  // List of expenses below.
                  _ExpensesList(state),
                ],
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

// Circular diagram at the top that shows money spent already this month and the rest of budget.
class _CircularDiagram extends StatelessWidget {
  final DashboardStateLoaded state;

  const _CircularDiagram(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DashboardCubit>();
    return Column(
      children: [
        AnimatedCircularChart(
          key: UniqueKey(),
          size: const Size.square(200),
          initialChartData: <CircularStackEntry>[
            CircularStackEntry(
              <CircularSegmentEntry>[
                CircularSegmentEntry(
                  33.33,
                  Theme.of(context).colorScheme.primary,
                  rankKey: 'completed',
                ),
                CircularSegmentEntry(
                  66.67,
                  Theme.of(context).colorScheme.outline,
                  rankKey: 'remaining',
                ),
              ],
              rankKey: 'progress',
            ),
          ],
          chartType: CircularChartType.Radial,
          edgeStyle: SegmentEdgeStyle.round,
          holeLabel:
              '\$${state.dashboardData.spentMoney}/${state.dashboardData.budget}',
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          percentageValues: true,
        ),
        // Current month label. Click on the label should open a date picker.
        SizedBox(
          width: 250,
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
                  label: Text(
                    //Format date, take name of the month. Example: January 2021.
                    _monthFormatter.format(state.dashboardData.selectedMonth),

                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
              IconButton.outlined(
                  onPressed: () {
                    context.read<DashboardCubit>().nextMonth();
                  },
                  icon: const Icon(Icons.chevron_right)),
            ],
          ),
        )
      ],
    );
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
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: expense.category.color.withOpacity(0.4),
          child: Icon(
            expense.category.icon,
            color: Theme.of(context).colorScheme.primary,
          )),
      title: Text(
        expense.name,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Text(
        expense.category.name,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Text(
        expense.amount.toString(),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
