import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:store_dashboard/features/shared/data/supabase/supabase_constants.dart';
import 'package:store_dashboard/features/users/data/users_sort.dart';

@lazySingleton
class UsersSupabaseDataSource {
  UsersSupabaseDataSource(this._supabase);

  final SupabaseClient _supabase;

  Future<List<Map<String, dynamic>>> fetchUsers({
    required String query,
    required UsersSort sort,
  }) async {
    final q = query.trim();

    final base = _supabase
        .from(SupabaseTables.users)
        .select(
          '${SupabaseColumns.id},'
          '${SupabaseColumns.email},'
          '${SupabaseColumns.username},'
          'role,'
          'is_blocked',
        )
        .neq('role', 'admin');

    final filtered = q.isEmpty
        ? base
        : base.or(
            '${SupabaseColumns.username}.ilike.%$q%,${SupabaseColumns.email}.ilike.%$q%',
          );

    final response = await switch (sort) {
      UsersSort.newest => filtered.order(
        SupabaseColumns.createdAt,
        ascending: false,
      ),
      UsersSort.oldest => filtered.order(
        SupabaseColumns.createdAt,
        ascending: true,
      ),
      UsersSort.usernameAz => filtered.order(
        SupabaseColumns.username,
        ascending: true,
      ),
    };

    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<void> setUserBlocked({
    required String userId,
    required bool blocked,
  }) async {
    await _supabase
        .from(SupabaseTables.users)
        .update({'is_blocked': blocked})
        .eq(SupabaseColumns.id, userId);
  }

  Future<List<Map<String, dynamic>>> fetchProductsForPermissions() async {
    final response = await _supabase
        .from(SupabaseTables.products)
        .select('${SupabaseColumns.id},${SupabaseColumns.title}')
        .order(SupabaseColumns.createdAt, ascending: false);

    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<Set<int>> fetchUserAllowedReviewProductIds({
    required String userId,
  }) async {
    final response = await _supabase
        .from(SupabaseTables.productReviewPermissions)
        .select('${SupabaseColumns.productId},can_rate')
        .eq(SupabaseColumns.userId, userId)
        .eq('can_rate', true);

    final rows = List<Map<String, dynamic>>.from(response as List);
    return rows
        .map((e) => (e[SupabaseColumns.productId] as num).toInt())
        .toSet();
  }

  Future<void> replaceUserReviewPermissions({
    required String userId,
    required Set<int> allowedProductIds,
  }) async {
    await _supabase
        .from(SupabaseTables.productReviewPermissions)
        .delete()
        .eq(SupabaseColumns.userId, userId);

    if (allowedProductIds.isEmpty) return;

    await _supabase
        .from(SupabaseTables.productReviewPermissions)
        .insert(
          allowedProductIds
              .map(
                (pid) => {
                  SupabaseColumns.userId: userId,
                  SupabaseColumns.productId: pid,
                  'can_rate': true,
                },
              )
              .toList(growable: false),
        );
  }

  Future<void> deleteUserFull({required String userId}) async {
    await _supabase
        .from(SupabaseTables.productReviewPermissions)
        .delete()
        .eq(SupabaseColumns.userId, userId);

    await _supabase
        .from(SupabaseTables.productFavorites)
        .delete()
        .eq(SupabaseColumns.userId, userId);

    await _supabase
        .from(SupabaseTables.productReview)
        .delete()
        .eq(SupabaseColumns.userId, userId);

    await _supabase
        .from(SupabaseTables.users)
        .delete()
        .eq(SupabaseColumns.id, userId);
  }
}
