import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lubdhok/core/router/route_names.dart';
import 'package:lubdhok/core/utils/validators.dart';
import 'package:lubdhok/core/widgets/app_snackbar.dart';
import 'package:lubdhok/core/widgets/auth_scaffold.dart';
import 'package:lubdhok/core/widgets/custom_button.dart';
import 'package:lubdhok/core/widgets/custom_textfield.dart';
import 'package:lubdhok/data/providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendLink() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      await ref.read(authRepositoryProvider).sendPasswordResetEmail(
        _emailController.text.trim(),
      );

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Reset link sent'),
          content: const Text(
            'A password reset link has been sent to your email. After changing password, come back to login.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.go(RouteNames.login);
              },
              child: const Text('Back to login'),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      showAppSnackBar(context, e.message ?? 'Failed to send reset email', isError: true);
    } catch (e) {
      if (!mounted) return;
      showAppSnackBar(context, 'Something went wrong: $e', isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Forgot password',
      subtitle: 'Enter your email and we will send you a password reset link.',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: _emailController,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            const SizedBox(height: 18),
            CustomButton(
              text: 'Send link',
              onPressed: _sendLink,
              isLoading: _loading,
            ),
            const SizedBox(height: 14),
            TextButton.icon(
              onPressed: () => context.go(RouteNames.login),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to login'),
            ),
          ],
        ),
      ),
    );
  }
}