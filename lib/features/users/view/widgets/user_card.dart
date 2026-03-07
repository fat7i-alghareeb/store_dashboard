  import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:store_dashboard/core/widgets/app_notifier.dart';
import 'package:store_dashboard/features/users/data/models/user_item.dart';
import 'package:store_dashboard/features/users/view/widgets/manage_review_permissions_dialog.dart';
import 'package:store_dashboard/features/users/viewmodel/users_cubit.dart';
import 'package:store_dashboard/utils/bloc_status/bloc_status.dart';
import 'package:store_dashboard/utils/gen/app_strings.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user, required this.actionStatus});

  final UserItem user;
  final BlocStatus<void> actionStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final busy = actionStatus.isLoading;

    final isAdmin = user.role == 'admin';
    final displayName = user.username.trim().isEmpty
        ? user.email
        : user.username;

    final roleLabel = user.role == 'admin'
        ? AppStrings.admin
        : AppStrings.customer;
    final roleColor = user.role == 'admin' ? scheme.primary : scheme.onSurface;

    return Material(
      color: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.person_rounded, color: scheme.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: roleColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: roleColor.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Text(
                            roleLabel,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: roleColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      runSpacing: 6,
                      spacing: 16,
                      children: [
                        _LabeledValue(
                          label: AppStrings.email,
                          value: user.email,
                          selectable: true,
                        ),
                        _LabeledValue(
                          label: AppStrings.status,
                          value: user.isBlocked
                              ? AppStrings.blocked
                              : AppStrings.unblocked,
                          valueColor: user.isBlocked
                              ? scheme.error
                              : scheme.primary,
                          trailing: Tooltip(
                            message: AppStrings.blockedHelp,
                            child: Icon(
                              Icons.info_outline_rounded,
                              size: 16,
                              color: scheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 210,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppStrings.actions,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: scheme.onSurface.withValues(alpha: 0.75),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Switch.adaptive(
                          value: user.isBlocked,
                          onChanged: (busy || isAdmin)
                              ? null
                              : (v) {
                                  context.read<UsersCubit>().setBlocked(
                                    userId: user.id,
                                    blocked: v,
                                  );
                                },
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          tooltip: AppStrings.manageReviewPermissions,
                          onPressed: (busy || isAdmin)
                              ? null
                              : () async {
                                  final cubit = context.read<UsersCubit>();
                                  await openManageReviewPermissionsDialog(
                                    context,
                                    userId: user.id,
                                    username: user.username,
                                    cubit: cubit,
                                  );
                                },
                          icon: const Icon(Icons.rate_review_outlined),
                        ),
                        IconButton(
                          tooltip: AppStrings.delete,
                          onPressed: (busy || isAdmin)
                              ? null
                              : () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text(AppStrings.confirmDelete),
                                      content: Text(
                                        AppStrings.areYouSureDeleteUser,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(false),
                                          child: Text(AppStrings.cancel),
                                        ),
                                        FilledButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(true),
                                          child: Text(AppStrings.delete),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirmed != true || !context.mounted) {
                                    return;
                                  }

                                  final ok = await context
                                      .read<UsersCubit>()
                                      .deleteUser(userId: user.id);

                                  if (ok && context.mounted) {
                                    AppNotifier.success(
                                      context,
                                      AppStrings.userDeletedSuccessfully,
                                    );
                                  }
                                },
                          icon: Icon(Icons.delete_outline, color: scheme.error),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 160.ms).slideY(begin: 0.02, end: 0);
  }
}

class _LabeledValue extends StatelessWidget {
  const _LabeledValue({
    required this.label,
    required this.value,
    this.selectable = false,
    this.valueColor,
    this.trailing,
  });

  final String label;
  final String value;
  final bool selectable;
  final Color? valueColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final valueStyle = theme.textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.w800,
      color: valueColor ?? scheme.onSurface,
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w700,
            ),
          ),
          Flexible(
            child: selectable
                ? SelectableText(value, style: valueStyle)
                : Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: valueStyle,
                  ),
          ),
          if (trailing != null) ...[const SizedBox(width: 6), trailing!],
        ],
      ),
    );
  }
}
