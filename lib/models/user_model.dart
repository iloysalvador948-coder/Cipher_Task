import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String hashedPassword; // Never store plain password

  @HiveField(3)
  final bool isBiometricEnabled;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime? lastLoginAt;

  @HiveField(6)
  final String? fullName;

  UserModel({
    required this.id,
    required this.email,
    required this.hashedPassword,
    this.isBiometricEnabled = false,
    required this.createdAt,
    this.lastLoginAt,
    this.fullName,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? hashedPassword,
    bool? isBiometricEnabled,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? fullName,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      hashedPassword: hashedPassword ?? this.hashedPassword,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      fullName: fullName ?? this.fullName,
    );
  }
}
