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
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl  = TextEditingController();
  final _ageCtrl       = TextEditingController();
  final _usernameCtrl  = TextEditingController();
  final _emailCtrl     = TextEditingController();
  final _pwCtrl        = TextEditingController();
  final _formKey       = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _ageCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  Widget _glassField({
    required String label,
    required TextEditingController ctrl,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
  }) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: TextFormField(
          controller: ctrl,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: TextStyle(color: cs.onSurface),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: cs.onSurfaceVariant),
            filled: true,
            fillColor: cs.surfaceContainerHighest.withOpacity(0.4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Enter $label';
            if (label == 'Age' && int.tryParse(v) == null) {
              return 'Age must be a number';
            }
            return null;
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final authState = ref.watch(authVMProvider);

    ref.listen<AuthState>(authVMProvider, (prev, state) {
      state.whenOrNull(
        success: (_) => context.go('/tasks'),
        error:   (msg) => ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(msg))),
      );
    });

    return Scaffold(
      backgroundColor: cs.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              color: cs.surfaceContainerHighest.withOpacity(0.5),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(vertical: 32),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person_add, size: 48, color: cs.primary),
                      const SizedBox(height: 16),

                      _glassField(
                        label: 'First Name',
                        ctrl: _firstNameCtrl,
                      ),
                      const SizedBox(height: 12),

                      _glassField(
                        label: 'Last Name',
                        ctrl: _lastNameCtrl,
                      ),
                      const SizedBox(height: 12),

                      _glassField(
                        label: 'Age',
                        ctrl: _ageCtrl,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),

                      _glassField(
                        label: 'Username',
                        ctrl: _usernameCtrl,
                      ),
                      const SizedBox(height: 12),

                      _glassField(
                        label: 'Email',
                        ctrl: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),

                      _glassField(
                        label: 'Password',
                        ctrl: _pwCtrl,
                        obscure: true,
                      ),
                      const SizedBox(height: 24),

                      authState.maybeWhen(
                        loading: () => const CircularProgressIndicator(),
                        orElse: () => SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cs.primary,
                              foregroundColor: cs.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) return;

                              ref.read(authVMProvider.notifier).signup(
                                firstName: _firstNameCtrl.text.trim(),
                                lastName:  _lastNameCtrl.text.trim(),
                                age:       int.parse(_ageCtrl.text.trim()),
                                username:  _usernameCtrl.text.trim(),
                                email:     _emailCtrl.text.trim(),
                                password:  _pwCtrl.text.trim(),
                              );
                            },
                            child: const Text('Create Account'),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: Text(
                          'Already have an account? Log in',
                          style: TextStyle(color: cs.primary),
                        ),
                      ),
                    ],
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
