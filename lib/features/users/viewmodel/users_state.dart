part of 'users_cubit.dart';

@freezed
sealed class UsersState with _$UsersState {
  const UsersState._();

  const factory UsersState({
    required BlocStatus<List<UserItem>> usersStatus,
    required BlocStatus<void> actionStatus,
    required UsersQuery lastQuery,
  }) = _UsersState;

  factory UsersState.initial() => const UsersState(
    usersStatus: BlocStatus.initial(),
    actionStatus: BlocStatus.initial(),
    lastQuery: UsersQuery.initial,
  );
}

@freezed
sealed class UsersQuery with _$UsersQuery {
  const factory UsersQuery({required String query, required UsersSort sort}) =
      _UsersQuery;

  static const initial = UsersQuery(query: '', sort: UsersSort.newest);
}
