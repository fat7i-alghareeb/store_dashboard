import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:store_dashboard/core/widgets/app_notifier.dart';
import 'package:store_dashboard/features/auth/viewmodel/auth_cubit.dart';
import 'package:store_dashboard/utils/bloc_status/bloc_status.dart';
import 'package:store_dashboard/utils/gen/app_strings.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final _identifier = TextEditingController();
  final _password = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    await context.read<AuthCubit>().signIn(
      identifier: _identifier.text,
      password: _password.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthViewState>(
      listenWhen: (p, n) => p.signInStatus != n.signInStatus,
      listener: (context, state) {
        state.signInStatus.maybeWhen(
          failure: (message) {
            final m = message == 'INVALID_LOGIN'
                ? AppStrings.invalidLogin
                : message;
            AppNotifier.error(context, m);
            context.read<AuthCubit>().clearSignInStatus();
          },
          success: (_) => context.read<AuthCubit>().clearSignInStatus(),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final loading = state.signInStatus.isLoading;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _identifier,
                enabled: !loading,
                decoration: InputDecoration(
                  labelText: AppStrings.emailOrUsername,
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? AppStrings.pleaseEnterEmailOrUsername
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _password,
                enabled: !loading,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: AppStrings.password,
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    onPressed: loading
                        ? null
                        : () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? AppStrings.pleaseEnterPassword
                    : null,
                onFieldSubmitted: (_) => _submit(context),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: loading ? null : () => _submit(context),
                child: Text(loading ? AppStrings.signingIn : AppStrings.signIn),
              ).animate().fadeIn(duration: 160.ms).slideY(begin: 0.06, end: 0),
            ],
          ),
        );
      },
    );
  }
}
