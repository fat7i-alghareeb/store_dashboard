import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:store_dashboard/utils/gen/app_strings.dart';

class ProductsHeader extends StatelessWidget {
  const ProductsHeader({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 14),
      child: Row(
        children: [
          Text(
            AppStrings.products,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Spacer(),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const FaIcon(FontAwesomeIcons.plus, size: 14),
            label: Text(AppStrings.addNewProduct),
          ).animate().fadeIn(duration: 220.ms).slideX(begin: 0.04),
        ],
      ),
    );
  }
}
