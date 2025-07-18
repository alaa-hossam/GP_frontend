import 'package:shared_preferences/shared_preferences.dart';

class Token {
  static const _uuidKey = 'UUID';
  static const _tokenKey = 'TOKEN';
  static const _expiredKey = 'EXPIRED';
  static const _roleKey = 'ROLE';
  static const _emailKey = 'EMAIL';

  Future<void> saveTokenData({
    required String uuid,
    required String token,
    required String expired,
    required String role,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_uuidKey, uuid);
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_expiredKey, expired);
    await prefs.setString(_roleKey, role);
    await prefs.setString(_emailKey, email);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<String?> getUUID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_uuidKey);
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> isEmpty() async {
    final prefs = await SharedPreferences.getInstance();
    return !prefs.containsKey(_tokenKey);
  }

  Future<bool> isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final expired = prefs.getString(_expiredKey);

    if (token == null || expired == null) return false;

    final expiryDate = DateTime.tryParse(expired);
    if (expiryDate == null) return false;

    return DateTime.now().isBefore(expiryDate);
  }

}
