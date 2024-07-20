import 'package:flutter/material.dart';

extension ColorExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
