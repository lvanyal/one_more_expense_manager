// Dashboard screen with circular diagram at the top that shows money spent already this month and the rest of budget. And list of expenses below.

import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  static const String routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // The body of the screen with circular diagram at the top that shows money spent already this month and the rest of budget. And list of expenses below.
        body: const Column(
          children: <Widget>[
            // Circular diagram at the top that shows money spent already this month and the rest of budget.
            _CircularDiagram(),
            // List of expenses below.
            _ExpensesList(),
          ],
        ),
        // FAB button with plus icon in the bottom right corner.
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
        ));
  }
}

// Circular diagram at the top that shows money spent already this month and the rest of budget.
class _CircularDiagram extends StatelessWidget {
  const _CircularDiagram({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedCircularChart(
        key: UniqueKey(),
        size: const Size.square(300),
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
        holeLabel: '\$1883/2000',
        labelStyle: Theme.of(context).textTheme.bodyLarge,
        percentageValues: true,
      ),
    );
  }
}

// List of expenses below.
class _ExpensesList extends StatelessWidget {
  const _ExpensesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
