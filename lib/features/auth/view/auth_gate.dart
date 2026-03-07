import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import 'package:store_dashboard/features/auth/view/login_screen.dart';
import 'package:store_dashboard/features/auth/viewmodel/auth_cubit.dart';
import 'package:store_dashboard/features/shell/view/dashboard_shell.dart';
import 'package:store_dashboard/utils/gen/app_strings.dart';
import 'package:store_dashboard/utils/services/injection/injectable.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authStream = sb.Supabase.instance.client.auth.onAuthStateChange;
    final client = sb.Supabase.instance.client;

    return StreamBuilder<sb.AuthState>(
      stream: authStream,
      builder: (context, snapshot) {
        final session =
            snapshot.data?.session ??
            sb.Supabase.instance.client.auth.currentSession;

        if (session == null) {
          return BlocProvider<AuthCubit>(
            create: (_) => getIt<AuthCubit>(),
            child: const LoginScreen(),
          );
        }

        return _AdminGuard(
          userId: session.user.id,
          client: client,
          child: const DashboardShell(),
        );
      },
    );
  }
}

class _AdminGuard extends StatefulWidget {
  const _AdminGuard({
    required this.userId,
    required this.client,
    required this.child,
  });

  final String userId;
  final sb.SupabaseClient client;
  final Widget child;

  @override
  State<_AdminGuard> createState() => _AdminGuardState();
}

class _AdminGuardState extends State<_AdminGuard> {
  late final Future<_GuardResult> _future = _check();
  bool _signingOut = false;

  Future<_GuardResult> _check() async {
    final row = await widget.client
        .from('users')
        .select('role,is_blocked')
        .eq('id', widget.userId)
        .maybeSingle();

    if (row == null) {
      return _GuardResult.unauthorized;
    }

    final role = (row['role'] ?? '').toString();
    final blocked = (row['is_blocked'] ?? false) as bool;

    if (blocked) return _GuardResult.blocked;
    if (role != 'admin') return _GuardResult.unauthorized;
    return _GuardResult.allowed;
  }

  Future<void> _signOutOnce() async {
    if (_signingOut) return;
    _signingOut = true;
    try {
      await widget.client.auth.signOut();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_GuardResult>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final result = snapshot.data!;
        if (result == _GuardResult.allowed) {
          return widget.child;
        }

        final message = result == _GuardResult.blocked
            ? AppStrings.accountSuspended
            : AppStrings.unauthorizedAccess;

        _signOutOnce();

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => widget.client.auth.signOut(),
                  child: Text(AppStrings.signIn),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 160.ms).slideY(begin: 0.03, end: 0);
      },
    );
  }
}

class _GuardResult {
  const _GuardResult._(this.value);

  final String value;

  static const allowed = _GuardResult._('allowed');
  static const blocked = _GuardResult._('blocked');
  static const unauthorized = _GuardResult._('unauthorized');

  @override
  bool operator ==(Object other) =>
      other is _GuardResult && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
