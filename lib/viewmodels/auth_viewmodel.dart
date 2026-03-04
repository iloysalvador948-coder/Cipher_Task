import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cypher_task_app/models/user_model.dart';
import 'package:cypher_task_app/services/database_service.dart';
import 'package:cypher_task_app/services/encryption_service.dart';
import 'package:cypher_task_app/services/key_storage_service.dart';
import 'package:cypher_task_app/services/session_service.dart';
import 'package:cypher_task_app/utils/constants.dart';
import 'package:uuid/uuid.dart';

class AuthViewModel extends ChangeNotifier {
  final DatabaseService databaseService;
  final EncryptionService encryptionService;
  final KeyStorageService keyStorageService;
  final SessionService sessionService;

  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;
  UserModel? _currentUser;
  bool _isBiometricAvailable = false;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;
  UserModel? get currentUser => _currentUser;
  bool get isBiometricAvailable => _isBiometricAvailable;

  AuthViewModel({
    required this.databaseService,
    required this.encryptionService,
    required this.keyStorageService,
    required this.sessionService,
  });

  /// Check if biometric is available on device
  Future<void> checkBiometricAvailability() async {
    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
final isDeviceSupported = await _localAuth.isDeviceSupported();

_isBiometricAvailable = canCheckBiometrics && isDeviceSupported;
      notifyListeners();
    } catch (e) {
      _isBiometricAvailable = false;
      notifyListeners();
    }
  }

  /// Initialize master encryption key
  Future<void> initializeMasterKey() async {
    try {
      await encryptionService.initializeMasterKey();
    } catch (e) {
      _errorMessage = 'Failed to initialize encryption: $e';
      notifyListeners();
    }
  }

  /// Register a new user
  Future<bool> registerUser({
    required String email,
    required String password,
    required String fullName,
    bool enableBiometric = false,
  }) async {
    try {
      _errorMessage = null;
      _isLoading = true;
      notifyListeners();

      // Validate inputs
      if (email.isEmpty || password.isEmpty) {
        _errorMessage = 'Email and password are required';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (password.length < AppConstants.minPasswordLength) {
        _errorMessage =
            'Password must be at least ${AppConstants.minPasswordLength} characters';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Check if user already exists (simple check with email pattern)
      final existingUser = databaseService.getFirstUser();
      if (existingUser != null && existingUser.email == email) {
        _errorMessage = AppConstants.errorUserAlreadyExists;
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Hash password
      final hashedPassword = encryptionService.hashPassword(password);

      // Create user
      final user = UserModel(
        id: const Uuid().v4(),
        email: email,
        hashedPassword: hashedPassword,
        isBiometricEnabled: enableBiometric && _isBiometricAvailable,
        createdAt: DateTime.now(),
        fullName: fullName,
      );

      // Save to database
      await databaseService.saveUser(user);

      // Store biometric status
      if (enableBiometric && _isBiometricAvailable) {
        await keyStorageService.setBiometricEnabled(true);
      }

      _currentUser = user;
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = 'Registration failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Login with email and password
  Future<bool> loginWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      _errorMessage = null;
      _isLoading = true;
      notifyListeners();

      if (email.isEmpty || password.isEmpty) {
        _errorMessage = 'Email and password are required';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Get user from database
      final user = databaseService.getFirstUser();

      if (user == null || user.email != email) {
        _errorMessage = AppConstants.errorInvalidCredentials;
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Verify password
      if (!encryptionService.verifyPassword(password, user.hashedPassword)) {
        _errorMessage = AppConstants.errorInvalidCredentials;
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Update last login
      final updatedUser = user.copyWith(lastLoginAt: DateTime.now());
      await databaseService.saveUser(updatedUser);

      _currentUser = updatedUser;
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();

      // Initialize session
      sessionService.initializeSession(
        onSessionTimeout: _handleSessionTimeout,
      );

      return true;
    } catch (e) {
      _errorMessage = 'Login failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Login with biometric
  Future<bool> loginWithBiometric() async {
    try {
      _errorMessage = null;
      _isLoading = true;
      notifyListeners();

      // Check if biometric is available
      if (!_isBiometricAvailable) {
        _errorMessage = AppConstants.errorBiometricNotAvailable;
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Check if biometric is enabled
      final isBioEnabled = await keyStorageService.isBiometricEnabled();
      if (!isBioEnabled) {
        _errorMessage = 'Biometric not enabled for this account';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Authenticate with biometric
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to unlock your tasks',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (!isAuthenticated) {
        _errorMessage = 'Biometric authentication failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Get user from database
      final user = databaseService.getFirstUser();

      if (user == null) {
        _errorMessage = AppConstants.errorUserNotFound;
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Update last login
      final updatedUser = user.copyWith(lastLoginAt: DateTime.now());
      await databaseService.saveUser(updatedUser);

      _currentUser = updatedUser;
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();

      // Initialize session
      sessionService.initializeSession(
        onSessionTimeout: _handleSessionTimeout,
      );

      return true;
    } catch (e) {
      _errorMessage = 'Biometric login failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      sessionService.endSession();
      _currentUser = null;
      _isAuthenticated = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Logout failed: $e';
      notifyListeners();
    }
  }

  /// Handle session timeout
  Future<void> _handleSessionTimeout() async {
    _isAuthenticated = false;
    _currentUser = null;
    _errorMessage = AppConstants.sessionTimeoutMessage;
    notifyListeners();
  }

  /// Check if user is already logged in
  Future<void> checkAuthStatus() async {
    try {
      final user = databaseService.getFirstUser();
      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
      } else {
        _isAuthenticated = false;
      }
      notifyListeners();
    } catch (e) {
      _isAuthenticated = false;
      notifyListeners();
    }
  }
}


