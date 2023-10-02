// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:copilot/model/budget.dart';
import 'package:copilot/model/expense.dart';

class DashboardData {
  // Selected month.
  final DateTime selectedMonth;

  // Budget.
  final Budget budget;

  // Spent money.
  final double spentMoney;

  // List of expenses.
  final List<Expense> expenses;

  DashboardData(
      {required this.selectedMonth,
      required this.budget,
      required this.spentMoney,
      required this.expenses});

  DashboardData copyWith({
    DateTime? selectedMonth,
    Budget? budget,
    double? spentMoney,
    List<Expense>? expenses,
  }) {
    return DashboardData(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      budget: budget ?? this.budget,
      spentMoney: spentMoney ?? this.spentMoney,
      expenses: expenses ?? this.expenses,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'selectedMonth': selectedMonth.millisecondsSinceEpoch,
      'budget': budget.toMap(),
      'spentMoney': spentMoney,
      'expenses': expenses.map((x) => x.toMap()).toList(),
    };
  }

  factory DashboardData.fromMap(Map<String, dynamic> map) {
    return DashboardData(
      selectedMonth:
          DateTime.fromMillisecondsSinceEpoch(map['selectedMonth'] as int),
      budget: Budget.fromMap(map['budget'] as Map<String, dynamic>),
      spentMoney: map['spentMoney'] as double,
      expenses: List<Expense>.from(
        (map['expenses'] as List<int>).map<Expense>(
          (x) => Expense.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory DashboardData.fromJson(String source) =>
      DashboardData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DashboardData(selectedMonth: $selectedMonth, budget: $budget, spentMoney: $spentMoney, expenses: $expenses)';
  }

  @override
  bool operator ==(covariant DashboardData other) {
    if (identical(this, other)) return true;

    return other.selectedMonth == selectedMonth &&
        other.budget == budget &&
        other.spentMoney == spentMoney &&
        listEquals(other.expenses, expenses);
  }

  @override
  int get hashCode {
    return selectedMonth.hashCode ^
        budget.hashCode ^
        spentMoney.hashCode ^
        expenses.hashCode;
  }
}
