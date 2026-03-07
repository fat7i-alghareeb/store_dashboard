import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:store_dashboard/features/users/data/users_sort.dart';
import 'package:store_dashboard/features/users/viewmodel/users_cubit.dart';
import 'package:store_dashboard/utils/gen/app_strings.dart';

class UsersHeader extends StatelessWidget {
  const UsersHeader({
    super.key,
    required this.state,
    required this.search,
    required this.sort,
    required this.onSortChanged,
    required this.onChanged,
  });

  final UsersState state;
  final TextEditingController search;
  final UsersSort sort;
  final ValueChanged<UsersSort> onSortChanged;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppStrings.users,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: scheme.outlineVariant.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.security_rounded,
                    size: 16,
                    color: scheme.onSurface.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.role,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: search,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded),
                  hintText: AppStrings.searchUsers,
                ),
                onChanged: (_) {
                  context.read<UsersCubit>().onSearchChanged(
                    query: search.text,
                    sort: sort,
                  );
                  onChanged();
                },
              ),
            ),
            const SizedBox(width: 10),
            DropdownButtonHideUnderline(
              child: DropdownButton<UsersSort>(
                value: sort,
                onChanged: (v) {
                  if (v == null) return;
                  onSortChanged(v);
                },
                items: [
                  DropdownMenuItem(
                    value: UsersSort.newest,
                    child: Text(AppStrings.usersSortNewest),
                  ),
                  DropdownMenuItem(
                    value: UsersSort.oldest,
                    child: Text(AppStrings.usersSortOldest),
                  ),
                  DropdownMenuItem(
                    value: UsersSort.usernameAz,
                    child: Text(AppStrings.usersSortUsernameAz),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.02, end: 0);
  }
}
