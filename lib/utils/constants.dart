class AppConstants {
  // Session Management
  static const int sessionTimeoutMinutes = 2;
  static const int sessionTimeoutMilliseconds = sessionTimeoutMinutes * 60 * 1000;

  // Database
  static const String hiveBoxNameTodos = 'todos';
  static const String hiveBoxNameUser = 'user';
  static const String hiveBoxNameSession = 'session';

  // Keys for Secure Storage
  static const String secureStorageKeyDbPassword = 'db_encryption_key';
  static const String secureStorageKeyMasterKey = 'master_encryption_key';
  static const String secureStorageKeyBioEnabled = 'bio_enabled';

  // Encryption
  static const int aesKeyLength = 32; // 256-bit key
  static const int aesIvLength = 16; // 128-bit IV

  // Auth
  static const int minPasswordLength = 8;
  static const String otpLength = '6';

  // Timeout messages
  static const String sessionTimeoutMessage = 'Session expired due to inactivity';
  
  // Error messages
  static const String errorBiometricNotAvailable = 'Biometric authentication not available';
  static const String errorBiometricNotEnrolled = 'No biometric enrolled on this device';
  static const String errorInvalidCredentials = 'Invalid email or password';
  static const String errorUserNotFound = 'User not found';
  static const String errorUserAlreadyExists = 'Email already registered';
  static const String errorDatabaseInitialization = 'Failed to initialize database';
}
