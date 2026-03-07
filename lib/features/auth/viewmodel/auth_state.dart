part of 'auth_cubit.dart';

@freezed
sealed class AuthViewState with _$AuthViewState {
  const AuthViewState._();

  const factory AuthViewState({required BlocStatus<void> signInStatus}) =
      _AuthViewState;

  factory AuthViewState.initial() =>
      const AuthViewState(signInStatus: BlocStatus.initial());
}
