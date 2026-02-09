import '../../auth/controller/auth_controller.dart';
import '../../../services/api_call_method.dart';
import '../../../services/api_service.dart';
import '../../../services/storage_service.dart';
import '../models/user_profile_details_model.dart';


sealed class ProfileDetailsResult {}

class ProfileDetailsSuccess extends ProfileDetailsResult {
  ProfileDetailsSuccess(this.data);
  final UserAccountInfo data;
}

class ProfileDetailsFailure extends ProfileDetailsResult {
  ProfileDetailsFailure(this.message);
  final String message;
}


class UserProfileDetailsController {
  UserProfileDetailsController._();


  static Future<ProfileDetailsResult> fetchAccountInfo() async {
    final userId = await StorageService.getUserId();
    final token = await AuthController.getToken();

    if (userId == null || userId.isEmpty) {
      return ProfileDetailsFailure('Not logged in');
    }
    if (token == null || token.isEmpty) {
      return ProfileDetailsFailure('Session expired. Please log in again.');
    }

    final uri = Uri.parse(ApiService.getAccountInfo);
    final response = await ApiCallMethod.post(
      uri,
      body: <String, dynamic>{
        'login': userId,
        'token': token,
      },
    );

    if (response.statusCode != 200) {
      return ProfileDetailsFailure(
        response.error ?? 'Something went wrong',
      );
    }

    final data = response.data;
    final info = UserAccountInfo.fromJson(data);
    if (info == null) {
      return ProfileDetailsFailure('Invalid response');
    }
    return ProfileDetailsSuccess(info);
  }

  /// Calls GetLastFourNumbersPhone (POST with login + token).
  /// Returns the 4 digits on success, null on failure.
  static Future<String?> fetchLastFourPhone() async {
    final userId = await StorageService.getUserId();
    final token = await AuthController.getToken();
    if (userId == null || userId.isEmpty || token == null || token.isEmpty) {
      return null;
    }
    final uri = Uri.parse(ApiService.getLastFourNumbersPhpne);
    final response = await ApiCallMethod.post(
      uri,
      body: <String, dynamic>{
        'login': userId,
        'token': token,
      },
    );
    if (response.statusCode != 200) return null;
    final data = response.data;
    String? four;
    if (data is Map<String, dynamic>) {
      four = data['phone'] as String? ??
          data['lastFour'] as String? ??
          data['lastFourDigits'] as String?;
    }
    if (four == null && response.body.length == 4) four = response.body;
    if (four != null && four.length >= 4) {
      return four.length == 4 ? four : four.substring(four.length - 4);
    }
    return null;
  }
}
