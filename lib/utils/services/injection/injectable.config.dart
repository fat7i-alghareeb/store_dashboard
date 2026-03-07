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
import 'package:store_dashboard/features/categories/data/categories_supabase_data_source.dart'
    as _i757;
import 'package:store_dashboard/features/categories/viewmodel/categories_cubit.dart'
    as _i496;
import 'package:store_dashboard/features/offers/data/offers_supabase_data_source.dart'
    as _i350;
import 'package:store_dashboard/features/offers/viewmodel/offers_cubit.dart'
    as _i377;
import 'package:store_dashboard/features/products/data/products_supabase_data_source.dart'
    as _i125;
import 'package:store_dashboard/features/products/viewmodel/products_cubit.dart'
    as _i254;
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
    gh.lazySingleton<_i757.CategoriesSupabaseDataSource>(
      () => _i757.CategoriesSupabaseDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i350.OffersSupabaseDataSource>(
      () => _i350.OffersSupabaseDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i125.ProductsSupabaseDataSource>(
      () => _i125.ProductsSupabaseDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i254.ProductsCubit>(
      () => _i254.ProductsCubit(gh<_i125.ProductsSupabaseDataSource>()),
    );
    gh.lazySingleton<_i911.ThemeController>(
      () => _i911.ThemeController(gh<_i841.StorageService>()),
    );
    gh.lazySingleton<_i898.LocaleService>(
      () => _i898.LocaleService(gh<_i841.StorageService>()),
    );
    gh.lazySingleton<_i496.CategoriesCubit>(
      () => _i496.CategoriesCubit(gh<_i757.CategoriesSupabaseDataSource>()),
    );
    gh.factory<_i377.OffersCubit>(
      () => _i377.OffersCubit(gh<_i350.OffersSupabaseDataSource>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i795.RegisterModule {}
