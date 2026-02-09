/// Application string constants.
abstract final class AppStrings {
  AppStrings._();

  static const String appName = 'Trading App';

  // Network & connectivity
  static const String noInternet =
      'No internet connection. Please check your network and try again.';
  static const String requestTimeout =
      'The request took too long. Please try again.';
  static const String connectionError =
      'Unable to reach the server. Please check your connection and try again.';
  static const String somethingWentWrong =
      'Something went wrong. Please try again later.';
  static const String youAreOffline = 'You\'re offline';
  static const String backOnline = 'Back online';

  // Exit confirmation
  static const String exitConfirmTitle = 'Exit app?';
  static const String exitConfirmMessage = 'Do you want to exit?';
  static const String exit = 'Exit';
  static const String cancel = 'Cancel';

  // Logout confirmation
  static const String logoutConfirmTitle = 'Log out?';
  static const String logoutConfirmMessage = 'Are you sure you want to log out?';
  static const String logout = 'Log out';

  // Auth
  static const String invalidCredentials = 'User Id or Password wrong';
}
