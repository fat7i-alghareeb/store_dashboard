import 'package:store_dashboard/features/shared/data/supabase/supabase_constants.dart';

class UserItem {
  const UserItem({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
    required this.isBlocked,
  });

  final String id;
  final String email;
  final String username;
  final String role;
  final bool isBlocked;

  factory UserItem.fromJson(Map<String, dynamic> json) {
    return UserItem(
      id: (json[SupabaseColumns.id] ?? '').toString(),
      email: (json[SupabaseColumns.email] ?? '').toString(),
      username: (json[SupabaseColumns.username] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      isBlocked: (json['is_blocked'] ?? false) as bool,
    );
  }
}
