import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _rolePrefix = 'role_';

  Future<void> saveRoleForEmail(String email, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_rolePrefix${email.toLowerCase()}', role);
  }

  Future<String?> getRoleForEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('$_rolePrefix${email.toLowerCase()}');
  }
}