import 'package:shared_preferences/shared_preferences.dart';

/// Keys for stored auth data.
abstract final class StorageKeys {
  static const String token = 'auth_token';
  static const String tokenSavedAt = 'auth_token_saved_at';
  static const String userId = 'auth_user_id';
}

/// Saves and reads auth token and user id from SharedPreferences.
/// Used for session persistence and token for API calls.
class StorageService {
  StorageService._();

  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  static Future<void> saveToken(String token) async {
    final prefs = await _instance;
    await prefs.setString(StorageKeys.token, token);
    await prefs.setString(
      StorageKeys.tokenSavedAt,
      DateTime.now().toIso8601String(),
    );
  }

  static Future<String?> getToken() async {
    final prefs = await _instance;
    return prefs.getString(StorageKeys.token);
  }

  static Future<void> saveTokenSavedAt(DateTime at) async {
    final prefs = await _instance;
    await prefs.setString(StorageKeys.tokenSavedAt, at.toIso8601String());
  }

  static Future<DateTime?> getTokenSavedAt() async {
    final prefs = await _instance;
    final s = prefs.getString(StorageKeys.tokenSavedAt);
    if (s == null) return null;
    return DateTime.tryParse(s);
  }

  static Future<void> saveUserId(String userId) async {
    final prefs = await _instance;
    await prefs.setString(StorageKeys.userId, userId);
  }

  static Future<String?> getUserId() async {
    final prefs = await _instance;
    return prefs.getString(StorageKeys.userId);
  }

  /// Clears auth data (token, savedAt, userId). Call on logout.
  static Future<void> clearAuth() async {
    final prefs = await _instance;
    await prefs.remove(StorageKeys.token);
    await prefs.remove(StorageKeys.tokenSavedAt);
    await prefs.remove(StorageKeys.userId);
  }
}
