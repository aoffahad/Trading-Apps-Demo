import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/loading_indicator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginController =
      TextEditingController(text: '');
  final TextEditingController _passwordController =
      TextEditingController(text: '');

  bool _isLoading = false;

  Future<void> _login() async {
    final userId = _loginController.text.trim();
    final password = _passwordController.text.trim();

    if (userId.isEmpty || password.isEmpty) {
      _showMessage('Please enter User ID and password');
      return;
    }

    setState(() => _isLoading = true);

    final result = await AuthController.login(userId, password);

    if (!mounted) return;
    setState(() => _isLoading = false);

    switch (result) {
      case LoginSuccess():
        _showMessage('Login successful');
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/home');
      case LoginFailure(:final message):
        _showMessage(message);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.profileBackground,
      
      body: _isLoading
          ? const LoadingIndicator()
          : Theme(
              data: Theme.of(context).copyWith(
                textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: AppColors.profileText,
                  displayColor: AppColors.profileText,
                ),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: AppColors.profileCard,
                  hintStyle: TextStyle(
                    color: AppColors.profileTextSecondary.withValues(alpha: 0.8),
                  ),
                  labelStyle: TextStyle(
                    color: AppColors.profileTextSecondary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.profileTextSecondary.withValues(alpha: 0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.profileTextSecondary.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.profileAccent,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              child: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final padding = Helpers.responsivePadding(context);
                    final minHeight =
                        constraints.maxHeight - padding.top - padding.bottom;
                    return SingleChildScrollView(
                      padding: padding,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: minHeight),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 40),
                            const Text(
                              'Login',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.profileText,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 40),
                            CustomTextField(
                              controller: _loginController,
                              hint: 'User ID',
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _passwordController,
                              hint: 'Password',
                            ),
                            const SizedBox(height: 24),
                            _LoginButton(
                              onPressed: _login,
                              isLoading: _isLoading,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}


class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.onPressed,
    required this.isLoading,
  });

  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.profileAccent,
          foregroundColor: AppColors.profileBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                color: AppColors.profileBackground,
                strokeWidth: 2,
              )
            : const Text(
                'Login',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
