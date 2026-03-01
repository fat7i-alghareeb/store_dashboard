import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:store_dashboard/utils/services/network/logging_http_client.dart';

import '../storage/storage_service.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<StorageService> get storageService => StorageService.createDefault();

  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;

  @lazySingleton
  http.Client get httpClient => LoggingHttpClient(http.Client());
}
