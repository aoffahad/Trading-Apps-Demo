class ApiService {
  ApiService._();

  // ─── Base URLs ─────────────────────────────────────────────────────────────
  static const String baseUrl = 'https://peanut.ifxdb.com/api/';

  static const String login =
      '${baseUrl}ClientCabinetBasic/IsAccountCredentialsCorrect';
  static const String getAccountInfo =
      '${baseUrl}ClientCabinetBasic/GetAccountInformation';
  static const String getLastFourNumbersPhpne =
      '${baseUrl}ClientCabinetBasic/GetLastFourNumbersPhone';
  static const String openTrades =
      '${baseUrl}ClientCabinetBasic/GetOpenTrades';
}
