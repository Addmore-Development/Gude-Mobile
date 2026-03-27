// frontend/lib/services/user_role_service.dart
class UserRoleService {
  static final UserRoleService _instance = UserRoleService._internal();
  factory UserRoleService() => _instance;
  UserRoleService._internal();

  String _role = 'student';
  String _institutionId = '';
  String _institutionName = '';
  String _userType = 'student'; // student, institution, buyer

  String get role => _role;
  set role(String value) => _role = value;

  String get institutionId => _institutionId;
  set institutionId(String value) => _institutionId = value;

  String get institutionName => _institutionName;
  set institutionName(String value) => _institutionName = value;

  String get userType => _userType;
  set userType(String value) => _userType = value;

  bool get isInstitution => _userType == 'institution';
  bool get isStudent => _userType == 'student';
  bool get isBuyer => _userType == 'buyer';

  void clear() {
    _role = 'student';
    _institutionId = '';
    _institutionName = '';
    _userType = 'student';
  }
}
