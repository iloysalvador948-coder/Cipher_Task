import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cypher_task_app/models/todo_model.dart';
import 'package:cypher_task_app/models/user_model.dart';
import 'package:cypher_task_app/services/key_storage_service.dart';
import 'package:cypher_task_app/utils/constants.dart';

class DatabaseService {
  final KeyStorageService keyStorageService;

  late Box<TodoModel> _todosBox;
  late Box<UserModel> _userBox;
  late Box<String> _sessionBox;

  bool _isInitialized = false;

  DatabaseService({required this.keyStorageService});

  /// Initialize the encrypted database
  Future<void> initializeDatabase() async {
    if (_isInitialized) return;

    try {
      // Initialize Hive
      await Hive.initFlutter();

      // Register adapters
      Hive.registerAdapter(TodoModelAdapter());
      Hive.registerAdapter(UserModelAdapter());

      // Get or create database encryption key
      String? dbKey = await keyStorageService.getDatabaseKey();

      if (dbKey == null) {
        // Generate new key if it doesn't exist
        final newKey = _generateEncryptionKey();
        await keyStorageService.storeDatabaseKey(newKey);
        dbKey = newKey;
      }

      // Decrypt the database key for Hive
      final encryptionKeyBytes = base64.decode(dbKey);

      // Open encrypted boxes
      _todosBox = await Hive.openBox<TodoModel>(
        AppConstants.hiveBoxNameTodos,
        encryptionCipher: HiveAesCipher(encryptionKeyBytes),
      );

      _userBox = await Hive.openBox<UserModel>(
        AppConstants.hiveBoxNameUser,
        encryptionCipher: HiveAesCipher(encryptionKeyBytes),
      );

      _sessionBox = await Hive.openBox<String>(
        AppConstants.hiveBoxNameSession,
        encryptionCipher: HiveAesCipher(encryptionKeyBytes),
      );

      _isInitialized = true;
    } catch (e) {
      throw Exception(
          '${AppConstants.errorDatabaseInitialization}: $e');
    }
  }

  /// Generate a base64 encoded encryption key
  String _generateEncryptionKey() {
  final random = Random.secure();

  final key = Uint8List.fromList(
    List<int>.generate(32, (_) => random.nextInt(256)),
  );

  return base64.encode(key);
}

  // ==================== TODO Operations ====================

  /// Add a new todo
  Future<void> addTodo(TodoModel todo) async {
    await _todosBox.put(todo.id, todo);
  }

  /// Get a todo by ID
  TodoModel? getTodo(String id) {
    return _todosBox.get(id);
  }

  /// Get all todos
  List<TodoModel> getAllTodos() {
    return _todosBox.values.toList();
  }

  /// Update a todo
  Future<void> updateTodo(TodoModel todo) async {
    await _todosBox.put(todo.id, todo);
  }

  /// Delete a todo
  Future<void> deleteTodo(String id) async {
    await _todosBox.delete(id);
  }

  /// Get todos sorted by priority
  List<TodoModel> getTodosByPriority() {
    final todos = _todosBox.values.toList();
    todos.sort((a, b) => b.priority.compareTo(a.priority));
    return todos;
  }

  /// Get incomplete todos
  List<TodoModel> getIncompleteTodos() {
    return _todosBox.values
        .where((todo) => !todo.isCompleted)
        .toList();
  }

  /// Clear all todos
  Future<void> clearAllTodos() async {
    await _todosBox.clear();
  }

  // ==================== User Operations ====================

  /// Add or update user
  Future<void> saveUser(UserModel user) async {
    await _userBox.put(user.id, user);
  }

  /// Get user by ID
  UserModel? getUser(String id) {
    return _userBox.get(id);
  }

  /// Get first user (assuming single user per device)
  UserModel? getFirstUser() {
    if (_userBox.isEmpty) return null;
    return _userBox.values.first;
  }

  /// Check if user exists
  bool userExists(String id) {
    return _userBox.containsKey(id);
  }

  /// Delete user
  Future<void> deleteUser(String id) async {
    await _userBox.delete(id);
  }

  /// Clear all users
  Future<void> clearAllUsers() async {
    await _userBox.clear();
  }

  // ==================== Session Operations ====================

  /// Store session data
  Future<void> storeSessionData(String key, String value) async {
    await _sessionBox.put(key, value);
  }

  /// Get session data
  String? getSessionData(String key) {
    return _sessionBox.get(key);
  }

  /// Clear session
  Future<void> clearSession() async {
    await _sessionBox.clear();
  }

  // ==================== Cleanup ====================

  /// Close all boxes
  Future<void> closeDatabase() async {
    await Hive.close();
    _isInitialized = false;
  }

  /// Check if database is initialized
  bool get isInitialized => _isInitialized;
}
