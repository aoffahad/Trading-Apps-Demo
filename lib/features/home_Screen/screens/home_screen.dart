import 'package:flutter/material.dart';

import '../../auth/controller/auth_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.profileBackground,
      appBar: AppBar(
        backgroundColor: AppColors.profileBackground,
        elevation: 0,
        foregroundColor: AppColors.profileText,
        title: Text(
          AppStrings.appName,
          style: const TextStyle(
            color: AppColors.profileText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            color: AppColors.profileText,
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (ctx) => AlertDialog(
                  backgroundColor: AppColors.profileCard,
                  title: Text(
                    AppStrings.logoutConfirmTitle,
                    style: const TextStyle(color: AppColors.profileText),
                  ),
                  content: Text(
                    AppStrings.logoutConfirmMessage,
                    style: TextStyle(
                      color: AppColors.profileTextSecondary.withValues(alpha: 0.9),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: Text(
                        AppStrings.cancel,
                        style: const TextStyle(color: AppColors.profileAccent),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: Text(
                        AppStrings.logout,
                        style: const TextStyle(color: AppColors.tradeLoss),
                      ),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await AuthController.logout();
                if (!context.mounted) return;
                Navigator.of(context).pushReplacementNamed('/');
              }
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
                Text(
                  'Logged in as User ID: $userId',
                  style: const TextStyle(
                    color: AppColors.profileText,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
               
              ],
            ),
          );
        },
      ),
    );
  }
}
