import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cypher_task_app/viewmodels/auth_viewmodel.dart';
import 'package:cypher_task_app/views/widgets/secure_widgets.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Check biometric availability on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthViewModel>().checkBiometricAvailability();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CipherTask - Secure Login'),
        elevation: 0,
      ),
      body: Consumer<AuthViewModel>(
        builder: (context, authVM, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to access your secure tasks',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  SecureErrorWidget(errorMessage: authVM.errorMessage),
                  const SizedBox(height: 16),
                  SecureTextField(
                    label: 'Email',
                    controller: _emailController,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Email is required';
                      }
                      if (!value!.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SecureTextField(
                    label: 'Password',
                    controller: _passwordController,
                    isPassword: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SecureButton(
                    label: 'Sign In',
                    isLoading: authVM.isLoading,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final success = await authVM.loginWithPassword(
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                        );

                        if (success && mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/todo-list',
                            (route) => false,
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  if (authVM.isBiometricAvailable)
                    SecureButton(
                      label: 'Unlock with Fingerprint',
                      isLoading: authVM.isLoading,
                      onPressed: () async {
                        final success = await authVM.loginWithBiometric();

                        if (success && mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/todo-list',
                            (route) => false,
                          );
                        }
                      },
                    ),
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/register');
                      },
                      child: const Text(
                        'Don\'t have an account? Sign up',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
