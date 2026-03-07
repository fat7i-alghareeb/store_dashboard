import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:store_dashboard/core/widgets/app_notifier.dart';
import 'package:store_dashboard/features/users/view/widgets/users_error_state.dart';
import 'package:store_dashboard/features/users/view/widgets/users_grid.dart';
import 'package:store_dashboard/features/users/viewmodel/users_cubit.dart';
import 'package:store_dashboard/utils/bloc_status/bloc_status.dart';
import 'package:store_dashboard/utils/bloc_status/status_builder.dart';

class UsersBody extends StatelessWidget {
  const UsersBody({super.key, required this.state});

  final UsersState state;

  @override
  Widget build(BuildContext context) {
    return BlocListener<UsersCubit, UsersState>(
      listenWhen: (p, n) => p.actionStatus != n.actionStatus,
      listener: (context, state) {
        state.actionStatus.maybeWhen(
          failure: (message) => AppNotifier.error(context, message),
          success: (_) => context.read<UsersCubit>().clearActionStatus(),
          orElse: () {},
        );
      },
      child: StatusBuilder(
        state: state.usersStatus,
        loading: () => const Center(child: CircularProgressIndicator()),
        failure: (message) => UsersErrorState(
          message: message,
          onRetry: () {
            final q = state.lastQuery;
            context.read<UsersCubit>().load(query: q.query, sort: q.sort);
          },
        ),
        onError: () {
          final q = state.lastQuery;
          context.read<UsersCubit>().load(query: q.query, sort: q.sort);
        },
        success: (items) =>
            UsersGrid(items: items, actionStatus: state.actionStatus),
      ),
    );
  }
}
