import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:store_dashboard/features/auth/data/auth_supabase_data_source.dart';
import 'package:store_dashboard/utils/bloc_status/bloc_status.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

@injectable
class AuthCubit extends Cubit<AuthViewState> {
  AuthCubit(this._dataSource) : super(AuthViewState.initial());

  final AuthSupabaseDataSource _dataSource;

  void _safeEmit(AuthViewState newState) {
    if (isClosed) return;
    emit(newState);
  }

  Future<void> signIn({
    required String identifier,
    required String password,
  }) async {
    final id = identifier.trim();
    final pass = password.trim();

    _safeEmit(state.copyWith(signInStatus: const BlocStatus.loading()));

    try {
      String? email;
      if (id.contains('@')) {
        email = id;
      } else {
        email = await _dataSource.tryResolveEmailFromUsername(username: id);
      }

      if (email == null || email.trim().isEmpty) {
        throw Exception('INVALID_LOGIN');
      }

      await _dataSource.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      _safeEmit(state.copyWith(signInStatus: const BlocStatus.success(null)));
    } on AuthException catch (_) {
      _safeEmit(
        state.copyWith(signInStatus: const BlocStatus.failure('INVALID_LOGIN')),
      );
    } catch (e) {
      final msg = e.toString().contains('INVALID_LOGIN')
          ? 'INVALID_LOGIN'
          : e.toString();
      _safeEmit(state.copyWith(signInStatus: BlocStatus.failure(msg)));
    }
  }

  void clearSignInStatus() {
    _safeEmit(state.copyWith(signInStatus: const BlocStatus.initial()));
  }
}
