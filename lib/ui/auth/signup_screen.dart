import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/viewmodels/auth_viewmodels.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _userCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _pwCtrl    = TextEditingController();
  final _formKey   = GlobalKey<FormState>();

  @override
  void dispose() {
    _userCtrl.dispose();
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  Widget _glassInput({required String label, required TextEditingController ctrl, bool obscure = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: TextFormField(
          controller: ctrl,
          obscureText: obscure,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Colors.white.withValues(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (v) => v == null || v.isEmpty ? 'Enter $label' : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    ref.listen<AuthState>(authVMProvider, (prev, state) {
      state.when(
        idle:    ()    => null,
        loading: ()    => null,
        success: (_)   => GoRouter.of(context).go('/tasks'),
        error:   (msg) => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(msg))),
      );
    });

    final authState = ref.watch(authVMProvider);

    return Scaffold(
      backgroundColor: cs.surface.withValues(),
      body: Center(
        child: Card(
          elevation: 8,
          color: cs.surface.withValues(),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline, size: 48, color: cs.primary),
                const SizedBox(height: 16),

                // Glass-style inputs
                _glassInput(label: 'Username', ctrl: _userCtrl),
                const SizedBox(height: 12),
                _glassInput(label: 'Email',    ctrl: _emailCtrl),
                const SizedBox(height: 12),
                _glassInput(label: 'Password', ctrl: _pwCtrl, obscure: true),
                const SizedBox(height: 24),

                // Submit button
                authState.maybeWhen(
                  loading: () => const CircularProgressIndicator(),
                  orElse: () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ref.read(authVMProvider.notifier).signup(
                            _userCtrl.text.trim(),
                            _emailCtrl.text.trim(),
                            _pwCtrl.text.trim(),
                          );
                        }
                      },
                      child: const Text('Create Account'),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => GoRouter.of(context).go('/login'),
                  child: const Text('Already have an account? Log in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
