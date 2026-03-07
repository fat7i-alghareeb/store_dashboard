import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:store_dashboard/controller/admin/admin_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:store_dashboard/core/theme/app_system_ui_overlay.dart';
import 'package:store_dashboard/core/theme/app_theme.dart';
import 'package:store_dashboard/core/theme/theme_controller.dart';
import 'package:store_dashboard/utils/constants/design_constants.dart';
import 'package:store_dashboard/utils/services/injection/injectable.dart';
import 'package:store_dashboard/utils/services/localization/locale_service.dart';
import 'package:store_dashboard/utils/services/network/logging_http_client.dart';
import 'package:store_dashboard/utils/tool/localization_config.dart';

import 'package:store_dashboard/features/auth/view/auth_gate.dart';

import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && Platform.isWindows) {
    await windowManager.ensureInitialized();
    await windowManager.setMinimumSize(AppDesign.desktopMinWindowSize);
    await windowManager.setTitleBarStyle(
      TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );
  }
  try {
    await dotenv.load();
  } catch (e) {
    runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Text(
              'Missing .env file. Create a file named .env in the project root and add SUPABASE_URL and SUPABASE_ANON_KEY.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
    return;
  }

  await EasyLocalization.ensureInitialized();

  await configureDependencies();

  await getIt<ThemeController>().initialize();

  final supabaseHttpClient = LoggingHttpClient(http.Client());

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    httpClient: supabaseHttpClient,
  );

  Locale? startLocale;
  if (getIt.isRegistered<LocaleService>()) {
    startLocale = await getIt<LocaleService>().resolveInitialLocale();
  }

  // // 1️⃣ Read the persisted session
  // final session = Supabase.instance.client.auth.currentSession;
  // // 2️⃣ Determine if we already have a user
  // final bool loggedIn = session != null;
  runApp(
    EasyLocalization(
      supportedLocales: AppLocalizationConfig.supportedLanguageCodes
          .map((e) => Locale(e))
          .toList(growable: false),
      path: AppLocalizationConfig.translationsPath,
      fallbackLocale: const Locale(AppLocalizationConfig.fallbackLanguageCode),
      startLocale: startLocale,
      child: ScreenUtilInit(
        designSize: kIsWeb || Platform.isWindows
            ? AppDesign.desktopDesignSize
            : AppDesign.mobileDesignSize,
        fontSizeResolver: (fontSize, instance) {
          return fontSize.toDouble();
        },
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [BlocProvider(create: (context) => AdminBloc())],
            child: child!,
          );
        },
        child: const StoreControlPanel(),
      ),
    ),
  );
}

class StoreControlPanel extends StatelessWidget {
  const StoreControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = getIt<ThemeController>();

    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Store Wizard Control',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeController.themeMode,
          themeAnimationDuration: AppDurations.themeAnimation,
          themeAnimationCurve: AppCurves.theme,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: const AuthGate(),
          builder: (context, child) {
            final theme = Theme.of(context);
            final overlayStyle = AppSystemUiOverlay.forTheme(theme);

            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: overlayStyle,
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
