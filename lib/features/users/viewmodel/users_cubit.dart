import 'package:bloc/bloc.dart';
import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:store_dashboard/features/users/data/models/user_item.dart';
import 'package:store_dashboard/features/users/data/users_supabase_data_source.dart';
import 'package:store_dashboard/features/users/data/users_sort.dart';
import 'package:store_dashboard/utils/bloc_status/bloc_status.dart';
import 'package:store_dashboard/utils/gen/app_strings.dart';

part 'users_state.dart';
part 'users_cubit.freezed.dart';

@injectable
class UsersCubit extends Cubit<UsersState> {
  UsersCubit(this._dataSource) : super(UsersState.initial());

  final UsersSupabaseDataSource _dataSource;
  Timer? _debounce;

  void _safeEmit(UsersState newState) {
    if (isClosed) return;
    emit(newState);
  }

  Future<void> load({
    required String query,
    required UsersSort sort,
    bool showLoading = true,
  }) async {
    _safeEmit(
      state.copyWith(
        lastQuery: UsersQuery(query: query, sort: sort),
      ),
    );
    if (showLoading) {
      _safeEmit(state.copyWith(usersStatus: const BlocStatus.loading()));
    }
    try {
      final rows = await _dataSource.fetchUsers(query: query, sort: sort);
      final items = rows.map(UserItem.fromJson).toList(growable: false);
      _safeEmit(state.copyWith(usersStatus: BlocStatus.success(items)));
    } catch (e) {
      _safeEmit(state.copyWith(usersStatus: BlocStatus.failure(e.toString())));
    }
  }

  Future<bool> deleteUser({required String userId}) async {
    if (state.actionStatus.isLoading) return false;

    final isAdmin = state.usersStatus.maybeWhen(
      success: (items) => items.any((u) => u.id == userId && u.role == 'admin'),
      orElse: () => false,
    );
    if (isAdmin) {
      _safeEmit(
        state.copyWith(
          actionStatus: BlocStatus.failure(AppStrings.unauthorizedAccess),
        ),
      );
      return false;
    }

    _safeEmit(state.copyWith(actionStatus: const BlocStatus.loading()));
    try {
      await _dataSource.deleteUserFull(userId: userId);
      _safeEmit(state.copyWith(actionStatus: const BlocStatus.success(null)));
      final last = state.lastQuery;
      await load(query: last.query, sort: last.sort);
      return true;
    } catch (e) {
      _safeEmit(state.copyWith(actionStatus: BlocStatus.failure(e.toString())));
      return false;
    }
  }

  void onSearchChanged({required String query, required UsersSort sort}) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      load(query: query, sort: sort, showLoading: false);
    });
  }

  void onSortChanged({required String query, required UsersSort sort}) {
    _debounce?.cancel();
    load(query: query, sort: sort);
  }

  Future<void> setBlocked({
    required String userId,
    required bool blocked,
  }) async {
    final isAdmin = state.usersStatus.maybeWhen(
      success: (items) => items.any((u) => u.id == userId && u.role == 'admin'),
      orElse: () => false,
    );
    if (isAdmin) {
      _safeEmit(
        state.copyWith(
          actionStatus: BlocStatus.failure(AppStrings.unauthorizedAccess),
        ),
      );
      return;
    }

    _safeEmit(state.copyWith(actionStatus: const BlocStatus.loading()));
    try {
      await _dataSource.setUserBlocked(userId: userId, blocked: blocked);
      _safeEmit(state.copyWith(actionStatus: const BlocStatus.success(null)));
      final last = state.lastQuery;
      await load(query: last.query, sort: last.sort);
    } catch (e) {
      _safeEmit(state.copyWith(actionStatus: BlocStatus.failure(e.toString())));
    }
  }

  Future<List<Map<String, dynamic>>> fetchProductsForPermissions() {
    return _dataSource.fetchProductsForPermissions();
  }

  Future<Set<int>> fetchUserAllowedReviewProductIds({required String userId}) {
    return _dataSource.fetchUserAllowedReviewProductIds(userId: userId);
  }

  Future<void> replaceUserReviewPermissions({
    required String userId,
    required Set<int> allowedProductIds,
  }) async {
    if (state.actionStatus.isLoading) return;

    final isAdmin = state.usersStatus.maybeWhen(
      success: (items) => items.any((u) => u.id == userId && u.role == 'admin'),
      orElse: () => false,
    );
    if (isAdmin) {
      _safeEmit(
        state.copyWith(
          actionStatus: BlocStatus.failure(AppStrings.unauthorizedAccess),
        ),
      );
      return;
    }

    _safeEmit(state.copyWith(actionStatus: const BlocStatus.loading()));
    try {
      await _dataSource.replaceUserReviewPermissions(
        userId: userId,
        allowedProductIds: allowedProductIds,
      );
      _safeEmit(state.copyWith(actionStatus: const BlocStatus.success(null)));
    } catch (e) {
      _safeEmit(state.copyWith(actionStatus: BlocStatus.failure(e.toString())));
    }
  }

  void clearActionStatus() {
    _safeEmit(state.copyWith(actionStatus: const BlocStatus.initial()));
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
