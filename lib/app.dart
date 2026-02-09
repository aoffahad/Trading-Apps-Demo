import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/app_shell.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/home_Screen/screens/bottom_nav_bar_screens.dart';

/// Root application widget. Shows login or home (bottom nav) based on saved session.
/// Handles connectivity, lifecycle, and supports rotation and various screen sizes.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peanut Client',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const _AuthGate(),
        '/home': (context) => const BottomNavBarScreens(),
      },
      builder: (context, child) {
        return AppShell(child: child);
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
          return const BottomNavBarScreens();
        }
        return const LoginScreen();
      },
    );
  }
}
