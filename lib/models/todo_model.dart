import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? encryptedDescription; // Encrypted sensitive data

  @HiveField(3)
  final bool isCompleted;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime? updatedAt;

  @HiveField(6)
  final DateTime? dueDate;

  @HiveField(7)
  final int priority; // 1-5, 5 being highest

  TodoModel({
    required this.id,
    required this.title,
    this.encryptedDescription,
    this.isCompleted = false,
    required this.createdAt,
    this.updatedAt,
    this.dueDate,
    this.priority = 3,
  });

  TodoModel copyWith({
    String? id,
    String? title,
    String? encryptedDescription,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueDate,
    int? priority,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      encryptedDescription: encryptedDescription ?? this.encryptedDescription,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
    );
  }
}
