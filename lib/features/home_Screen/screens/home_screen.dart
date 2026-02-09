import 'package:flutter/material.dart';

import '../../auth/controller/auth_controller.dart';
import '../../../core/constants/app_strings.dart';

/// Placeholder home after login. Shows session and logout.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthController.logout();
              if (!context.mounted) return;
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: FutureBuilder<String?>(
        future: AuthController.getUserId(),
        builder: (context, snapshot) {
          final userId = snapshot.data ?? '—';
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Logged in as User ID: $userId'),
                const SizedBox(height: 16),
                const Text('Session saved. Token is used for API calls.'),
              ],
            ),
          );
        },
      ),
    );
  }
}
