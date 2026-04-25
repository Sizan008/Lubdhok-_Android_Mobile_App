import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lubdhok/core/constants/app_colors.dart';
import 'package:lubdhok/core/router/route_names.dart';
import 'package:lubdhok/core/utils/validators.dart';
import 'package:lubdhok/core/widgets/custom_button.dart';
import 'package:lubdhok/core/widgets/custom_textfield.dart';
import 'package:lubdhok/data/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final cred = await ref.read(authRepositoryProvider).signInWithFirebase(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final firebaseUser = cred.user;
      if (firebaseUser == null) {
        throw Exception('Firebase user not found');
      }

      await firebaseUser.reload();

      if (!firebaseUser.emailVerified) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please verify your email first')),
        );
        context.go(RouteNames.verifyEmail);
        return;
      }

      final email = firebaseUser.email ?? _emailController.text.trim();
      final savedRole =
      await ref.read(authRepositoryProvider).getSavedRoleForEmail(email);

      final backendUser = await ref.read(authRepositoryProvider).syncFirebaseUser(
        fullName: firebaseUser.displayName ?? email,
        email: email,
        role: savedRole ?? 'donor',
        location: null,
      );

      ref.read(currentUserProvider.notifier).state = backendUser;

      if (!mounted) return;

      if (backendUser.role == 'admin') {
        context.go(RouteNames.adminDashboard);
      } else {
        context.go(RouteNames.donorHome);
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEDE9FE), Color(0xFFE0F2FE), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [AppColors.primary, AppColors.secondary],
                              ),
                            ),
                            child: const Icon(
                              Icons.volunteer_activism,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Welcome back',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Login with your email and password to continue.',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            controller: _emailController,
                            hintText: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.email,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            controller: _passwordController,
                            hintText: 'Password',
                            obscureText: _obscure,
                            validator: Validators.password,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() => _obscure = !_obscure);
                              },
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => context.push(RouteNames.forgotPassword),
                              child: const Text('Forgot password?'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomButton(
                            text: _loading ? 'Loading...' : 'Login',
                            onPressed: _loading ? null : _login,
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                              GestureDetector(
                                onTap: () => context.push(RouteNames.signup),
                                child: const Text(
                                  'Register now',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}