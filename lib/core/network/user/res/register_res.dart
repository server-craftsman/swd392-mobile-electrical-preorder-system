import 'package:uuid/uuid.dart';
import 'package:mobile_electrical_preorder_system/core/enums/user_role.dart';
import 'package:mobile_electrical_preorder_system/core/enums/user_status.dart';

class RegisterResponse {
  final String id;
  final String username;
  final String fullname;
  final String email;
  final String phoneNumber;
  final UserStatus status;
  final UserRole role;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  RegisterResponse({
    required this.id,
    required this.username,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.status,
    required this.role,
    this.isVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      id: json['id'] ?? Uuid().v4(),
      username: json['username'] ?? '',
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      status: UserStatus.values.firstWhere(
        (e) => e.toString() == 'UserStatus.${json['status']}',
      ),
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
      ),
      isVerified: json['isVerified'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
