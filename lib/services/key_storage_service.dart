import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cypher_task_app/utils/constants.dart';

class KeyStorageService {
  final FlutterSecureStorage _secureStorage;

  KeyStorageService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Store a key securely in the device's hardware-backed storage
  Future<void> storeKey(String keyName, String keyValue) async {
    try {
      await _secureStorage.write(key: keyName, value: keyValue);
    } catch (e) {
      throw Exception('Failed to store key: $e');
    }
  }

  /// Retrieve a key from secure storage
  Future<String?> retrieveKey(String keyName) async {
    try {
      return await _secureStorage.read(key: keyName);
    } catch (e) {
      throw Exception('Failed to retrieve key: $e');
    }
  }

  /// Delete a key from secure storage
  Future<void> deleteKey(String keyName) async {
    try {
      await _secureStorage.delete(key: keyName);
    } catch (e) {
      throw Exception('Failed to delete key: $e');
    }
  }

  /// Check if a key exists
  Future<bool> containsKey(String keyName) async {
    try {
      final value = await _secureStorage.read(key: keyName);
      return value != null;
    } catch (e) {
      return false;
    }
  }

  /// Clear all stored keys
  Future<void> clearAll() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      throw Exception('Failed to clear storage: $e');
    }
  }

  /// Store database encryption key
  Future<void> storeDatabaseKey(String key) async {
    await storeKey(AppConstants.secureStorageKeyDbPassword, key);
  }

  /// Retrieve database encryption key
  Future<String?> getDatabaseKey() async {
    return retrieveKey(AppConstants.secureStorageKeyDbPassword);
  }

  /// Store master encryption key for field-level encryption
  Future<void> storeMasterKey(String key) async {
    await storeKey(AppConstants.secureStorageKeyMasterKey, key);
  }

  /// Retrieve master encryption key
  Future<String?> getMasterKey() async {
    return retrieveKey(AppConstants.secureStorageKeyMasterKey);
  }

  /// Store biometric enablement status
  Future<void> setBiometricEnabled(bool enabled) async {
    await storeKey(
      AppConstants.secureStorageKeyBioEnabled,
      enabled.toString(),
    );
  }

  /// Check if biometric is enabled
  Future<bool> isBiometricEnabled() async {
    final value =
        await retrieveKey(AppConstants.secureStorageKeyBioEnabled);
    return value == 'true';
  }
}
