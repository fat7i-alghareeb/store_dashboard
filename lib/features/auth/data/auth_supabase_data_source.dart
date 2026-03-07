import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:store_dashboard/features/shared/data/supabase/supabase_constants.dart';

@lazySingleton
class AuthSupabaseDataSource {
  AuthSupabaseDataSource(this._supabase);

  final SupabaseClient _supabase;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Session? get currentSession => _supabase.auth.currentSession;

  Stream<AuthState> get onAuthStateChange => _supabase.auth.onAuthStateChange;

  Future<String?> tryResolveEmailFromUsername({required String username}) async {
    final u = username.trim();
    if (u.isEmpty) return null;

    final response = await _supabase
        .from(SupabaseTables.users)
        .select(SupabaseColumns.email)
        .eq(SupabaseColumns.username, u)
        .maybeSingle();

    final email = (response?[SupabaseColumns.email] ?? '').toString().trim();
    return email.isEmpty ? null : email;
  }
}
