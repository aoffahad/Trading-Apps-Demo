import '../../../services/api_call_method.dart';
import '../../../services/api_service.dart';
import '../../../services/storage_service.dart';

/// Result of a login attempt.
sealed class LoginResult {}

class LoginSuccess extends LoginResult {
  LoginSuccess({required this.token});
  final String token;
}

class LoginFailure extends LoginResult {
  LoginFailure(this.message);
  final String message;
}

/// Handles login API call, token storage, and session validity.
/// Use [login] from the login screen; use [token] for authenticated API calls.
class AuthController {
  AuthController._();

  /// Token lifetime when API does not return expiry. After this, token is treated as expired.
  static const Duration tokenLifetime = Duration(hours: 24);

  /// Performs login via POST. Saves token and userId on success.
  /// Payload: { "login": userId, "password": password }.
  static Future<LoginResult> login(String userId, String password) async {
    final uri = Uri.parse(ApiService.login);
    final response = await ApiCallMethod.post(
      uri,
      body: <String, dynamic>{
        'login': userId,
        'password': password,
      },
    );

    if (response.statusCode != 200) {
      final message = response.data?['message'] as String? ??
          response.error ??
          'Request failed (${response.statusCode})';
      return LoginFailure(message);
    }

    final data = response.data;
    if (data == null) return LoginFailure('Invalid response');

    final result = data['result'] as bool?;
    if (result != true) {
      return LoginFailure(
        data['message'] as String? ?? 'Invalid credentials',
      );
    }

    final token = data['token'] as String?;
    if (token == null || token.isEmpty) {
      return LoginFailure('No token in response');
    }

    await StorageService.saveToken(token);
    await StorageService.saveTokenSavedAt(DateTime.now());
    await StorageService.saveUserId(userId);

    return LoginSuccess(token: token);
  }

  /// Returns the stored token for use in Authorization headers in other API calls.
  /// Returns null if not logged in or token is expired (and clears stored token).
  static Future<String?> getToken() async {
    final token = await StorageService.getToken();
    if (token == null || token.isEmpty) return null;

    final savedAt = await StorageService.getTokenSavedAt();
    if (savedAt == null) return token;

    if (DateTime.now().difference(savedAt) > tokenLifetime) {
      await StorageService.clearAuth();
      return null;
    }
    return token;
  }

  /// Whether we have a valid (non-expired) token. Use to decide if user must see login.
  static Future<bool> hasValidSession() async {
    final t = await getToken();
    return t != null && t.isNotEmpty;
  }

  /// Saved user id (login) for display. Does not imply valid token.
  static Future<String?> getUserId() async => StorageService.getUserId();

  /// Clears token and user id. Call on logout.
  static Future<void> logout() async {
    await StorageService.clearAuth();
  }
}
