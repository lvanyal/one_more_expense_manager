// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CategoryLimit {
  final bool selected;
  final double limit;

  CategoryLimit({
    required this.selected,
    required this.limit,
  });

  CategoryLimit copyWith({
    bool? selected,
    double? limit,
  }) {
    return CategoryLimit(
      selected: selected ?? this.selected,
      limit: limit ?? this.limit,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'selected': selected,
      'limit': limit,
    };
  }

  factory CategoryLimit.fromMap(Map<String, dynamic> map) {
    return CategoryLimit(
      selected: map['selected'] as bool,
      limit: map['limit'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryLimit.fromJson(String source) =>
      CategoryLimit.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CategoryLimit(selected: $selected, limit: $limit)';

  @override
  bool operator ==(covariant CategoryLimit other) {
    if (identical(this, other)) return true;

    return other.selected == selected && other.limit == limit;
  }

  @override
  int get hashCode => selected.hashCode ^ limit.hashCode;
}
