// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:copilot/model/category.dart';
import 'package:flutter/foundation.dart' as foundation;

class Budget {
  final double amount;
  final Map<Category, double> limitPerCategory;

  const Budget({
    required this.amount,
    required this.limitPerCategory,
  });

  Budget copyWith({
    double? amount,
    Map<Category, double>? limitPerCategory,
  }) {
    return Budget(
      amount: amount ?? this.amount,
      limitPerCategory: limitPerCategory ?? this.limitPerCategory,
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'amount': amount,
      'limitPerCategory': jsonEncode(
          limitPerCategory.map((key, value) => MapEntry(key.toMap(), value))),
    };
    return map;
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    final limitsJson = jsonDecode(map['limitPerCategory']);
    var parsedLimits = limitsJson.map(
        (key, value) => MapEntry(Category.fromJson(key), double.parse(value)));
    final limits = parsedLimits.length == 0
        ? <Category, double>{}
        : Map<Category, double>.fromEntries(parsedLimits);
    return Budget(
      amount: map['amount'] as double,
      limitPerCategory: limits,
    );
  }

  String toJson() => json.encode(toMap());

  factory Budget.fromJson(String source) =>
      Budget.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Budget(amount: $amount, limitPerCategory: $limitPerCategory)';

  @override
  bool operator ==(covariant Budget other) {
    if (identical(this, other)) return true;

    return other.amount == amount &&
        foundation.mapEquals(other.limitPerCategory, limitPerCategory);
  }

  @override
  int get hashCode => amount.hashCode ^ limitPerCategory.hashCode;
}
