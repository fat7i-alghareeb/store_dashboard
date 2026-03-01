// lib/utils.dart
import 'package:flutter/material.dart';

class Utils {
  /// Hides any current SnackBar and shows a new one with [message].
  static void showSnackBar(BuildContext context, String message) {
    // If there’s already one showing, hide it first
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
