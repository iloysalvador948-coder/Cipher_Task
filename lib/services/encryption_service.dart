import 'dart:convert';
import 'dart:math';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:cypher_task_app/services/key_storage_service.dart';
import 'package:cypher_task_app/utils/constants.dart';

class EncryptionService {
  final KeyStorageService keyStorageService;

  EncryptionService({required this.keyStorageService});

  /// Initialize or retrieve the master encryption key
  Future<String> initializeMasterKey() async {
    String? existingKey =
        await keyStorageService.getMasterKey();

    if (existingKey != null) {
      return existingKey;
    }

    // Generate a new key if it doesn't exist
    final key = encrypt.Key.fromSecureRandom(AppConstants.aesKeyLength);
    final keyString = base64.encode(key.bytes);

    await keyStorageService.storeMasterKey(keyString);

    return keyString;
  }

  /// Encrypt plain text using AES-256
  Future<String> encryptData(String plainText) async {
    try {
      final masterKeyString = await keyStorageService.getMasterKey();

      if (masterKeyString == null) {
        throw Exception('Master key not initialized');
      }

      final key = encrypt.Key(base64.decode(masterKeyString));
      final iv = encrypt.IV.fromSecureRandom(AppConstants.aesIvLength);

      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc),
      );

      final encrypted = encrypter.encrypt(plainText, iv: iv);

      // Return IV + ciphertext for decryption
      final result = base64.encode(iv.bytes) + ':' + encrypted.base64;

      return result;
    } catch (e) {
      throw Exception('Encryption failed: $e');
    }
  }

  /// Decrypt AES-256 encrypted text
  Future<String> decryptData(String encryptedText) async {
    try {
      final masterKeyString = await keyStorageService.getMasterKey();

      if (masterKeyString == null) {
        throw Exception('Master key not initialized');
      }

      final key = encrypt.Key(base64.decode(masterKeyString));

      // Extract IV and ciphertext
      final parts = encryptedText.split(':');
      if (parts.length != 2) {
        throw Exception('Invalid encrypted format');
      }

      final iv = encrypt.IV(base64.decode(parts[0]));
      final ciphertext = parts[1];

      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc),
      );

      final decrypted = encrypter.decrypt64(ciphertext, iv: iv);

      return decrypted;
    } catch (e) {
      throw Exception('Decryption failed: $e');
    }
  }

  /// Hash a password using simple encoding (in production, use bcrypt)
  String hashPassword(String password) {
    // This is a simple implementation. For production, use a proper hashing library.
    return base64.encode(utf8.encode(password));
  }

  /// Verify a password against its hash
  bool verifyPassword(String password, String hash) {
    return base64.encode(utf8.encode(password)) == hash;
  }

  /// Generate a random string for OTP or tokens
  String generateRandomString(int length) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    String result = '';
    for (int i = 0; i < length; i++) {
      result += chars[random.nextInt(chars.length)];
    }
    return result;
  }

  /// Generate OTP (6 digits)
  String generateOTP() {
    const chars = '0123456789';
    final random = Random.secure();
    String result = '';
    for (int i = 0; i < 6; i++) {
      result += chars[random.nextInt(chars.length)];
    }
    return result;
  }
}
