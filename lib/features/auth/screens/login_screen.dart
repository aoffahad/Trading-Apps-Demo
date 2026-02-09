import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/loading_indicator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginController =
      TextEditingController(text: '2088888');
  final TextEditingController _passwordController =
      TextEditingController(text: 'ral11lod');

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
      appBar: AppBar(title: const Text('Login')),
      body: _isLoading
          ? const LoadingIndicator()
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'Peanut Client Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
                    CustomButton(
                      text: 'Login',
                      onPressed: _login,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
