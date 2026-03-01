// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:store_dashboard/utils/bloc_status/bloc_status.dart'
    show BlocStatus, BlocStatusPatterns;

import 'package:store_dashboard/utils/gen/app_strings.dart';

class StatusBuilder<T> extends StatelessWidget {
  const StatusBuilder({
    super.key,
    required this.success,
    this.loading,
    this.init,
    this.onError,
    this.onRefresh,
    required this.state,
    this.errorMessage,
    this.showLoadingProgress = true,
    this.showInitWidget = true,
  });

  final BlocStatus<T> state;
  final Widget Function()? loading;
  final Widget Function()? init;
  final Widget Function(T data) success;
  final Function()? onError;
  final Future<void> Function()? onRefresh;
  final String? errorMessage;
  final bool showLoadingProgress;
  final bool showInitWidget;

  @override
  Widget build(BuildContext context) {
    late final Widget next;

    defaultLoading() => showLoadingProgress
        ? const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Center(child: CircularProgressIndicator())],
          )
        : const SizedBox.shrink();

    defaultInit() => const SizedBox.shrink();

    state.when(
      initial: () => next = init?.call() ?? defaultInit(),
      loading: () => next = loading?.call() ?? defaultLoading(),
      success: (data) => next = success(data),
      failure: (message) {
        next = Column(
          children: [
            Text(message),
            ElevatedButton(onPressed: onError, child: Text(AppStrings.reset)),
          ],
        );
      },
    );

    return next;
  }
}
