// Expense class is a simple data class that holds information about an expense. It has a constructor that takes in all the properties and a toJson() method that converts the object to a JSON string. It also has a fromJson() method that converts a JSON string to an Expense object.

import 'dart:convert';

import 'package:copilot/model/category.dart';

class Expense {
  // Name of the expense.
  final String name;

  // Amount of the expense.
  final double amount;

  // Date of the expense.
  final DateTime date;

  // Category of the expense.
  final Category category;

  // Id of the expense.
  final String id;

  // Constructor.
  const Expense({
    required this.name,
    required this.amount,
    required this.date,
    required this.category,
    required this.id,
  });

  // Returns expense from json.
  factory Expense.fromJson(String json) =>
      Expense.fromMap(jsonDecode(json) as Map<String, dynamic>);

  // Returns expense from map.
  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
        name: map['name'] as String,
        amount: map['amount'] as double,
        date: DateTime.parse(map['date'] as String),
        category: Category.fromMap(map['category'] as Map<String, dynamic>),
        id: map['id'] as String,
      );

  // Returns expense as json.
  String toJson() => jsonEncode(toMap());

  // Returns expense as map.
  Map<String, dynamic> toMap() => <String, dynamic>{
        'name': name,
        'amount': amount,
        'date': date.toIso8601String(),
        'category': category.toMap(),
        'id': id,
      };

  // Returns expense as string.
  @override
  String toString() {
    return 'Expense{name: $name, amount: $amount, date: $date, category: $category, id: $id}';
  }
}