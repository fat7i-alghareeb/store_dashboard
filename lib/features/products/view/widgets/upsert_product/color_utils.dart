import 'package:flutter/material.dart';

String toHexRgb(Color color) {
  final r = (color.r * 255.0).round().clamp(0, 255);
  final g = (color.g * 255.0).round().clamp(0, 255);
  final b = (color.b * 255.0).round().clamp(0, 255);
  String to2(int x) => x.toRadixString(16).padLeft(2, '0').toUpperCase();
  return '#${to2(r)}${to2(g)}${to2(b)}';
}

Color? hexToColor(String hex) {
  final normalized = hex.replaceAll('#', '').trim();
  if (normalized.length == 6) {
    return Color(int.parse('FF$normalized', radix: 16));
  }
  if (normalized.length == 8) {
    return Color(int.parse(normalized, radix: 16));
  }
  return null;
}
