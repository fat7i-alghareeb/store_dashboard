import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:store_dashboard/features/users/view/widgets/users_body.dart';
import 'package:store_dashboard/features/users/view/widgets/users_header.dart';
import 'package:store_dashboard/features/users/data/users_sort.dart';
import 'package:store_dashboard/features/users/viewmodel/users_cubit.dart';
import 'package:store_dashboard/utils/services/injection/injectable.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _search = TextEditingController();
  UsersSort _sort = UsersSort.newest;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UsersCubit>(
      create: (_) =>
          getIt<UsersCubit>()..load(query: _search.text, sort: _sort),
      child: _UsersScreenBody(
        search: _search,
        sort: _sort,
        onSortChanged: (v) {
          setState(() => _sort = v);
          context.read<UsersCubit>().onSortChanged(
            query: _search.text,
            sort: _sort,
          );
        },
        onSearchChanged: () => setState(() {}),
      ),
    );
  }
}

class _UsersScreenBody extends StatelessWidget {
  const _UsersScreenBody({
    required this.search,
    required this.sort,
    required this.onSortChanged,
    required this.onSearchChanged,
  });

  final TextEditingController search;
  final UsersSort sort;
  final ValueChanged<UsersSort> onSortChanged;
  final VoidCallback onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersCubit, UsersState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UsersHeader(
              state: state,
              search: search,
              sort: sort,
              onSortChanged: onSortChanged,
              onChanged: onSearchChanged,
            ),
            const SizedBox(height: 12),
            Expanded(child: UsersBody(state: state)),
          ],
        );
      },
    );
  }
}
