import 'package:flutter/material.dart';

/// Theme-agnostic static colors used across the app.
///
/// Use these for semantic feedback (success, warning, etc.) that do not
/// change between light and dark themes.
class AppColors {
  AppColors._();

  /// primary Color
  static const Color primaryLight = Colors.black;
  static const Color primaryDark = Colors.white;

  /// Secondary Color
  static const Color secondaryLight = Colors.white;
  static const Color secondaryDark = Colors.black;

  /// backGround Color
  static const Color backGroundLight = Color.fromARGB(255, 246, 246, 246);
  static const Color backGroundDark = Color.fromARGB(255, 39, 39, 39);

  static const Color greyLight = Color(0xFFC4C4C4);
  static const Color greyDark = Color(0xFFC4C4C4);

  /// Color used for success/toast states.
  static const Color success = Color(0xFF60976e);

  /// Color used for warning states.
  static const Color warning = Color.fromARGB(255, 242, 153, 10);

  /// Color used for error states beyond the core [ColorScheme.error].
  static const Color error = Color(0xFFF87171);

  /// Color used for informational highlights.
  static const Color info = Color(0xFF0288D1);
}
