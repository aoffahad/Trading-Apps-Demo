import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/home_Screen/screens/home_screen.dart';
import 'features/auth/screens/login_screen.dart';

/// Root application widget. Shows login or home based on saved session.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peanut Client',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const _AuthGate(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

/// Checks auth session. If valid token exists, shows home; otherwise login.
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthController.hasValidSession(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final isLoggedIn = snapshot.data ?? false;
        if (isLoggedIn) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
