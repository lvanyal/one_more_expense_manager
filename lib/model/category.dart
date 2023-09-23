// Class that represents a category with field: name, color, icon and id

import 'dart:convert';

import 'package:flutter/material.dart';

class Category {
  // Name of the category.
  final String name;

  // Color of the category.
  final Color color;

  // Icon of the category.
  final IconData icon;

  // Id of the category.
  final String id;

  // Constructor.
  const Category({
    required this.name,
    required this.color,
    required this.icon,
    required this.id,
  });

  // Returns category from json.
  factory Category.fromJson(String json) =>
      Category.fromMap(jsonDecode(json) as Map<String, dynamic>);

  // Returns category from map.
  factory Category.fromMap(Map<String, dynamic> map) => Category(
        name: map['name'] as String,
        color: Color(map['color'] as int),
        icon: IconData(map['icon'] as int, fontFamily: 'MaterialIcons'),
        id: map['id'] as String,
      );

  // Returns category as json.
  String toJson() => jsonEncode(toMap());

  // Returns category as map.
  Map<String, dynamic> toMap() => <String, dynamic>{
        'name': name,
        'color': color.value,
        'icon': icon.codePoint,
        'id': id,
      };

  // Returns category as string.
  @override
  String toString() {
    return 'Category{name: $name, color: $color, icon: $icon, id: $id}';
  }
}
