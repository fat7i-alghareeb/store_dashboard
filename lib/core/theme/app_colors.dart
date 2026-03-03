import 'package:flutter/material.dart';

/// Theme-agnostic static colors used across the app.
///
/// Use these for semantic feedback (success, warning, etc.) that do not
/// change between light and dark themes.
class AppColors {
  AppColors._();

  /// primary Color
  static const Color primaryLight = Color(0xFF0EA5E9);
  static const Color primaryDark = Color(0xFF38BDF8);

  /// Secondary Color
  static const Color secondaryLight = Color(0xFFF1F5F9);
  static const Color secondaryDark = Color(0xFF0B132B);

  /// backGround Color
  static const Color backGroundLight = Color(0xFFF8FAFC);
  static const Color backGroundDark = Color(0xFF050B1A);

  static const Color greyLight = Color(0xFFCBD5E1);
  static const Color greyDark = Color(0xFF27324A);

  /// Color used for success/toast states.
  static const Color success = Color(0xFF60976e);

  /// Color used for warning states.
  static const Color warning = Color.fromARGB(255, 242, 153, 10);

  /// Color used for error states beyond the core [ColorScheme.error].
  static const Color error = Color(0xFFF87171);

  /// Color used for informational highlights.
  static const Color info = Color(0xFF0288D1);
}
