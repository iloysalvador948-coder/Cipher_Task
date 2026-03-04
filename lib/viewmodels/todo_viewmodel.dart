import 'package:flutter/material.dart';
import 'package:cypher_task_app/models/todo_model.dart';
import 'package:cypher_task_app/services/database_service.dart';
import 'package:cypher_task_app/services/encryption_service.dart';
import 'package:cypher_task_app/services/session_service.dart';
import 'package:uuid/uuid.dart';

class TodoViewModel extends ChangeNotifier {
  final DatabaseService databaseService;
  final EncryptionService encryptionService;
  final SessionService sessionService;

  List<TodoModel> _todos = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<TodoModel> get todos => _todos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  TodoViewModel({
    required this.databaseService,
    required this.encryptionService,
    required this.sessionService,
  });

  /// Load all todos
  Future<void> loadTodos() async {
    try {
      _errorMessage = null;
      _isLoading = true;
      notifyListeners();

      _todos = databaseService.getAllTodos();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load todos: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add a new todo with optional encryption
  Future<bool> addTodo({
    required String title,
    String? description,
    DateTime? dueDate,
    int priority = 3,
  }) async {
    try {
      _errorMessage = null;
      _isLoading = true;
      notifyListeners();

      if (title.isEmpty) {
        _errorMessage = 'Title cannot be empty';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Encrypt description if provided
      String? encryptedDescription;
      if (description != null && description.isNotEmpty) {
        encryptedDescription =
            await encryptionService.encryptData(description);
      }

      final todo = TodoModel(
        id: const Uuid().v4(),
        title: title,
        encryptedDescription: encryptedDescription,
        dueDate: dueDate,
        priority: priority,
        createdAt: DateTime.now(),
      );

      await databaseService.addTodo(todo);
      _todos.add(todo);

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = 'Failed to add todo: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update a todo
  Future<bool> updateTodo({
    required String id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
    int? priority,
  }) async {
    try {
      _errorMessage = null;
      _isLoading = true;
      notifyListeners();

      final todo = databaseService.getTodo(id);
      if (todo == null) {
        _errorMessage = 'Todo not found';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Encrypt description if provided
      String? encryptedDescription = todo.encryptedDescription;
      if (description != null && description.isNotEmpty) {
        encryptedDescription = await encryptionService.encryptData(description);
      }

      final updatedTodo = todo.copyWith(
        title: title,
        encryptedDescription: encryptedDescription,
        isCompleted: isCompleted,
        dueDate: dueDate,
        priority: priority,
        updatedAt: DateTime.now(),
      );

      await databaseService.updateTodo(updatedTodo);

      final index = _todos.indexWhere((t) => t.id == id);
      if (index != -1) {
        _todos[index] = updatedTodo;
      }

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = 'Failed to update todo: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Toggle todo completion status
  Future<void> toggleTodoCompletion(String id) async {
    try {
      final todo = databaseService.getTodo(id);
      if (todo != null) {
        await updateTodo(id: id, isCompleted: !todo.isCompleted);
      }
    } catch (e) {
      _errorMessage = 'Failed to toggle todo: $e';
      notifyListeners();
    }
  }

  /// Delete a todo
  Future<bool> deleteTodo(String id) async {
    try {
      _errorMessage = null;
      _isLoading = true;
      notifyListeners();

      await databaseService.deleteTodo(id);
      _todos.removeWhere((todo) => todo.id == id);

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete todo: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get decrypted description for a todo
  Future<String?> getDecryptedDescription(String todoId) async {
    try {
      final todo = databaseService.getTodo(todoId);
      if (todo?.encryptedDescription != null) {
        return await encryptionService.decryptData(
          todo!.encryptedDescription!,
        );
      }
      return null;
    } catch (e) {
      _errorMessage = 'Failed to decrypt description: $e';
      notifyListeners();
      return null;
    }
  }

  /// Get todos sorted by priority
  List<TodoModel> getTodosByPriority() {
    return databaseService.getTodosByPriority();
  }

  /// Get incomplete todos
  List<TodoModel> getIncompleteTodos() {
    return databaseService.getIncompleteTodos();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear all todos
  Future<void> clearAllTodos() async {
    try {
      await databaseService.clearAllTodos();
      _todos.clear();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to clear todos: $e';
      notifyListeners();
    }
  }

  /// Reset session on user interaction
  void onUserInteraction() {
    sessionService.resetInactivityTimer();
  }
}
