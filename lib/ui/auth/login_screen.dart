import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/viewmodels/auth_viewmodels.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameCtrl   = TextEditingController();
  final _passwordCtrl   = TextEditingController();
  final _formKey        = GlobalKey<FormState>();
  bool  _obscurePassword = true;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    ref.listen<AuthState>(authVMProvider, (previous, state) {
      state.whenOrNull(
        success: (_) => context.go('/tasks'),
        error:   (msg) {
          ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
        },
      );
    });

    final authState = ref.watch(authVMProvider);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Username field
                  TextFormField(
                    controller: _usernameCtrl,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Enter username' : null,
                  ),
                  const SizedBox(height: 16),

                  
                  TextFormField(
                    controller: _passwordCtrl,
                    textAlign: TextAlign.center,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Enter password' : null,
                  ),
                  const SizedBox(height: 24),

                  
                  authState.maybeWhen(
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    orElse: () => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ref.read(authVMProvider.notifier).login(
                              _usernameCtrl.text.trim(),
                              _passwordCtrl.text.trim(),
                            );
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Login'),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.go('/signup'),
                    child: const Text("Don't have an account? Sign Up"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
