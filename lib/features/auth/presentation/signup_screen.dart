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

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _loading = false;
  bool _obscure = true;
  bool _obscureConfirm = true;

  // Fixed role: only donor signup allowed
  final String _role = 'donor';

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final cred = await ref.read(authRepositoryProvider).signUpWithFirebase(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await cred.user?.updateDisplayName(_nameController.text.trim());

      final backendUser =
      await ref.read(authRepositoryProvider).syncFirebaseUser(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        role: _role,
        location: _locationController.text.trim(),
      );

      ref.read(currentUserProvider.notifier).state = backendUser;

      await ref.read(authRepositoryProvider).saveRoleForEmail(
        _emailController.text.trim(),
        _role,
      );

      await ref.read(authRepositoryProvider).sendVerificationEmail();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification email sent. Please verify your email.'),
        ),
      );

      context.go(RouteNames.verifyEmail);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Registration failed')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _infoRoleBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.18),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.volunteer_activism_outlined,
            color: AppColors.primary,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'New accounts are registered as Donor only.',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
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
                constraints: const BoxConstraints(maxWidth: 440),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Create donor account',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Create your donor account and continue with Lubdhok.',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 18),
                          _infoRoleBox(),
                          const SizedBox(height: 14),
                          CustomTextField(
                            controller: _nameController,
                            hintText: 'Full name',
                            validator: (v) =>
                                Validators.required(v, fieldName: 'Name'),
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            controller: _locationController,
                            hintText: 'Location',
                            validator: (v) => Validators.required(
                              v,
                              fieldName: 'Location',
                            ),
                          ),
                          const SizedBox(height: 12),
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
                          const SizedBox(height: 12),
                          CustomTextField(
                            controller: _confirmPasswordController,
                            hintText: 'Confirm password',
                            obscureText: _obscureConfirm,
                            validator: (v) => Validators.confirmPassword(
                              v,
                              _passwordController.text,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(
                                      () => _obscureConfirm = !_obscureConfirm,
                                );
                              },
                              icon: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          CustomButton(
                            text: _loading ? 'Creating...' : 'Register',
                            onPressed: _loading ? null : _register,
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => context.go(RouteNames.login),
                            child: const Text('Back to login'),
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