// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;
import 'package:store_dashboard/core/theme/theme_controller.dart' as _i911;
import 'package:store_dashboard/utils/services/injection/register_module.dart'
    as _i795;
import 'package:store_dashboard/utils/services/localization/locale_service.dart'
    as _i898;
import 'package:store_dashboard/utils/services/storage/storage_service.dart'
    as _i841;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i841.StorageService>(
      () => registerModule.storageService,
      preResolve: true,
    );
    gh.lazySingleton<_i454.SupabaseClient>(() => registerModule.supabaseClient);
    gh.lazySingleton<_i519.Client>(() => registerModule.httpClient);
    gh.lazySingleton<_i911.ThemeController>(
      () => _i911.ThemeController(gh<_i841.StorageService>()),
    );
    gh.lazySingleton<_i898.LocaleService>(
      () => _i898.LocaleService(gh<_i841.StorageService>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i795.RegisterModule {}
