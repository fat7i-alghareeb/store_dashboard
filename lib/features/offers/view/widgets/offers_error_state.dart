import 'package:flutter/material.dart';

import 'package:store_dashboard/utils/gen/app_strings.dart';

class OffersErrorState extends StatelessWidget {
  const OffersErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onRetry,
              child: Text(AppStrings.reset),
            ),
          ],
        ),
      ),
    );
  }
}
