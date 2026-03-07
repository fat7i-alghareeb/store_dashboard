import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:store_dashboard/core/widgets/app_notifier.dart';
import 'package:store_dashboard/features/users/data/models/user_item.dart';
import 'package:store_dashboard/features/users/view/widgets/manage_review_permissions_dialog.dart';
import 'package:store_dashboard/features/users/viewmodel/users_cubit.dart';
import 'package:store_dashboard/utils/bloc_status/bloc_status.dart';
import 'package:store_dashboard/utils/gen/app_strings.dart';

class UsersGrid extends StatelessWidget {
  const UsersGrid({super.key, required this.items, required this.actionStatus});

  final List<UserItem> items;
  final BlocStatus<void> actionStatus;

  @override
  Widget build(BuildContext context) {
    final busy = actionStatus.isLoading;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.sizeOf(context).width,
          ),
          child: DataTable(
            columnSpacing: 18,
            horizontalMargin: 16,
            columns: [
              DataColumn(label: Text(AppStrings.name)),
              DataColumn(label: Text(AppStrings.email)),
              DataColumn(label: Text(AppStrings.role)),
              DataColumn(label: Text(AppStrings.status)),
              DataColumn(label: Text(AppStrings.actions)),
            ],
            rows: items
                .map((u) {
                  final isAdmin = u.role == 'admin';
                  final displayName = u.username.trim().isEmpty
                      ? u.email
                      : u.username;
                  final roleLabel = u.role == 'admin'
                      ? AppStrings.admin
                      : AppStrings.customer;

                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      DataCell(SelectableText(u.email)),
                      DataCell(Text(roleLabel)),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              u.isBlocked
                                  ? AppStrings.blocked
                                  : AppStrings.unblocked,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: u.isBlocked
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Tooltip(
                              message: AppStrings.blockedHelp,
                              child: Icon(
                                Icons.info_outline_rounded,
                                size: 16,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch.adaptive(
                              value: u.isBlocked,
                              onChanged: (busy || isAdmin)
                                  ? null
                                  : (v) {
                                      context.read<UsersCubit>().setBlocked(
                                        userId: u.id,
                                        blocked: v,
                                      );
                                    },
                            ),
                            IconButton(
                              tooltip: AppStrings.manageReviewPermissions,
                              onPressed: (busy || isAdmin)
                                  ? null
                                  : () async {
                                      final cubit = context.read<UsersCubit>();
                                      await openManageReviewPermissionsDialog(
                                        context,
                                        userId: u.id,
                                        username: u.username,
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

                                      if (confirmed != true ||
                                          !context.mounted) {
                                        return;
                                      }

                                      final ok = await context
                                          .read<UsersCubit>()
                                          .deleteUser(userId: u.id);

                                      if (ok && context.mounted) {
                                        AppNotifier.success(
                                          context,
                                          AppStrings.userDeletedSuccessfully,
                                        );
                                      }
                                    },
                              icon: Icon(
                                Icons.delete_outline,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                })
                .toList(growable: false),
          ),
        ),
      ),
    );
  }
}
