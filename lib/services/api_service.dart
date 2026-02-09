
class ApiService {
  ApiService._();

  // ─── Base URLs ─────────────────────────────────────────────────────────────
  static const String baseUrl = 'https://peanut.ifxdb.com/api/';

  static const String login =
      '${baseUrl}ClientCabinetBasic/IsAccountCredentialsCorrect';
}
