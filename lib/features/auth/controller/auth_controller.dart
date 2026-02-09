import '../../../core/constants/app_strings.dart';
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


class AuthController {
  AuthController._();


  static const Duration tokenLifetime = Duration(hours: 24);


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
      if (response.statusCode == 400 || response.statusCode == 401) {
        return LoginFailure(AppStrings.invalidCredentials);
      }
      final message = response.error ??
          'Request failed (${response.statusCode})';
      return LoginFailure(message);
    }

    final data = response.data;
    if (data == null) return LoginFailure(AppStrings.invalidCredentials);

    final result = data['result'] as bool?;
    if (result != true) {
      return LoginFailure(AppStrings.invalidCredentials);
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


  static Future<bool> hasValidSession() async {
    final t = await getToken();
    return t != null && t.isNotEmpty;
  }


  static Future<String?> getUserId() async => StorageService.getUserId();

  
  static Future<void> logout() async {
    await StorageService.clearAuth();
  }
}
