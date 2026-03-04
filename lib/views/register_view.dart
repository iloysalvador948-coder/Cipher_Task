import 'package:cypher_task_app/services/key_storage_service.dart';
import 'package:cypher_task_app/views/otp_verification_view.dart';
import 'package:cypher_task_app/services/encryption_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cypher_task_app/viewmodels/auth_viewmodel.dart';
import 'package:cypher_task_app/views/widgets/secure_widgets.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _enableBiometric = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthViewModel>().checkBiometricAvailability();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CipherTask - Register'),
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
                    'Create Account',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Join CipherTask to manage your secure tasks',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  SecureErrorWidget(errorMessage: authVM.errorMessage),
                  const SizedBox(height: 16),
                  SecureTextField(
                    label: 'Full Name',
                    controller: _fullNameController,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Full name is required';
                      }
                      return null;
                    },
                  ),
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
                      if (value!.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SecureTextField(
                    label: 'Confirm Password',
                    controller: _confirmPasswordController,
                    isPassword: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  if (authVM.isBiometricAvailable)
                    Card(
                      child: CheckboxListTile(
                        title: const Text('Enable Biometric Authentication'),
                        subtitle: const Text(
                          'Unlock your account with fingerprint',
                        ),
                        value: _enableBiometric,
                        onChanged: (value) {
                          setState(() {
                            _enableBiometric = value ?? false;
                          });
                        },
                      ),
                    ),
                  const SizedBox(height: 24),
                  SecureButton(
                    label: 'Create Account',
                    isLoading: authVM.isLoading,
                    onPressed: () async {
  if (_formKey.currentState!.validate()) {

    final keyStorageService = KeyStorageService();
final encryptionService =
    EncryptionService(keyStorageService: keyStorageService);
    final otp = encryptionService.generateOTP();

   await showDialog(
  context: context,
  builder: (_) => AlertDialog(
    title: const Text("Demo OTP"),
    content: Text("Your OTP is: $otp"),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text("OK"),
      )
    ],
  ),
);

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => OtpVerificationView(
      generatedOtp: otp,
      onVerified: () async {
        final success = await authVM.registerUser(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          fullName: _fullNameController.text.trim(),
          enableBiometric: _enableBiometric,
        );

        if (success && mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/todo-list',
            (route) => false,
          );
        }
      },
    ),
  ),
);
  }
},
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Already have an account? Sign in',
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
