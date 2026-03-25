// lib/core/services/user_role_service.dart
//
// Simple singleton — holds the logged-in user's role.
// Set BEFORE calling context.go() at signup and login.

class UserRoleService {
  static final UserRoleService _instance = UserRoleService._();
  factory UserRoleService() => _instance;
  UserRoleService._();

  /// 'student' | 'buyer' | '' (not yet set)
  String role = '';

  bool get isBuyer => role == 'buyer';
  bool get isStudent => role == 'student';

  void clear() => role = '';
}
