// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:copilot/model/category.dart';
import 'package:copilot/model/category_limit.dart';

class Budget {
  final double amount;
  final Map<Category, CategoryLimit> limitPerCategory;

  const Budget({
    required this.amount,
    required this.limitPerCategory,
  });

  Budget copyWith({
    double? amount,
    Map<Category, CategoryLimit>? limitPerCategory,
  }) {
    return Budget(
      amount: amount ?? this.amount,
      limitPerCategory: limitPerCategory ?? this.limitPerCategory,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amount': amount,
      'limitPerCategory': limitPerCategory.map(
          (key, value) => MapEntry(json.encode(key.toMap()), value.toMap())),
    };
  }

  //fromMap
  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      amount: map['amount'] as double,
      limitPerCategory: (map['limitPerCategory'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
              Category.fromMap(json.decode(key) as Map<String, dynamic>),
              CategoryLimit.fromMap(value as Map<String, dynamic>))),
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
    final mapEquals = const DeepCollectionEquality().equals;

    return other.amount == amount &&
        mapEquals(other.limitPerCategory, limitPerCategory);
  }

  @override
  int get hashCode => amount.hashCode ^ limitPerCategory.hashCode;
}
