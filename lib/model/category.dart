// Class that represents a category with field: name, color, icon and id

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/IconPicker/icons.dart';

class Category {
  // Name of the category.
  final String name;

  // Color of the category.
  final Color color;

  // Icon of the category.
  final IconData icon;

  // Id of the category.
  final String id;

  //Deleted category.
  final bool deleted;

  // Constructor.
  const Category({
    required this.name,
    required this.color,
    required this.icon,
    required this.id,
    this.deleted = false,
  });

// Data class methods
  Category copyWith({
    String? name,
    Color? color,
    IconData? icon,
    String? id,
    bool? deleted,
  }) {
    return Category(
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      id: id ?? this.id,
      deleted: deleted ?? this.deleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'color': color.value,
      'icon': icon.codePoint,
      'fontFamily': icon.fontFamily,
      'fontPackage': icon.fontPackage,
      'id': id,
      'deleted': deleted,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'],
      color: Color(map['color']),
      icon: IconData(
        map['icon'],
        fontFamily: map['fontFamily'],
        fontPackage: map['fontPackage'],
      ),
      id: map['id'],
      deleted: map['deleted'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Category(name: $name, color: $color, icon: $icon, id: $id, deleted: $deleted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category &&
        other.name == name &&
        other.color == color &&
        other.icon == icon &&
        other.id == id &&
        other.deleted == deleted;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        color.hashCode ^
        icon.hashCode ^
        id.hashCode ^
        deleted.hashCode;
  }
}
