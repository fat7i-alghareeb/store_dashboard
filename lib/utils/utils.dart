// lib/utils.dart
import 'package:flutter/material.dart';

import 'package:store_dashboard/core/widgets/app_notifier.dart';

class Utils {
  /// Hides any current SnackBar and shows a new one with [message].
  static void showSnackBar(BuildContext context, String message) {
    AppNotifier.error(context, message);
  }
}
