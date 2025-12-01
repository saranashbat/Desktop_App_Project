// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/login_request.dart';
import '../utils/app_state.dart';
import '../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loading = false;
  String? error;
  bool obscurePassword = true;

  void login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      setState(() {
        error = 'Please enter both email and password';
      });
      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    try {
      final req = LoginRequest(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = await UserService().login(req);
      AppState().setUser(user);

      setState(() {
        loading = false;
      });

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/perfumes');
      }
    } catch (e) {
      setState(() {
        loading = false;
        error = 'Login failed. Check your credentials.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // ✅ Dynamic color
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'logo',
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 140,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1), // ✅ Dynamic color
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.shopping_bag, // ✅ Removed const
                          size: 60, color: AppColors.primary),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Welcome Back', style: AppTextStyles.h1), // ✅ Dynamic style
              const SizedBox(height: AppSpacing.sm),
              Text('Sign in to continue',
                  style: AppTextStyles.bodySecondary), // ✅ Dynamic style
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  filled: true,
                  fillColor: AppColors.cardBackground, // ✅ Dynamic color (changed from Colors.white)
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  filled: true,
                  fillColor: AppColors.cardBackground, // ✅ Dynamic color (changed from Colors.white)
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: loading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // ✅ Dynamic color
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    ),
                    elevation: 2,
                  ),
                  child: loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text('Login', style: AppTextStyles.button),
                ),
              ),
              if (error != null) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: AppColors.error), // ✅ Removed const
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(error!,
                            style: TextStyle(color: AppColors.error)), // ✅ Removed const
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}