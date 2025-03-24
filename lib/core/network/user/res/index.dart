class User {
  final String id;
  final String username;
  final String fullname;
  final String email;
  final String phoneNumber;
  final String address;
  final String status;
  final String role;
  final String avatar;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool verified;
  final bool deleted;

  User({
    required this.id,
    required this.username,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.status,
    required this.role,
    required this.avatar,
    required this.createdAt,
    required this.updatedAt,
    required this.verified,
    required this.deleted,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      fullname: json['fullname'] ?? 'Unknown',
      email: json['email'] ?? 'No email',
      phoneNumber: json['phoneNumber'] ?? 'No phone',
      address: json['address'] ?? '',
      status: json['status'] ?? 'INACTIVE',
      role: json['role'] ?? 'ROLE_UNKNOWN',
      avatar: json['avatar'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      verified: json['verified'] ?? false,
      deleted: json['deleted'] ?? false,
    );
  }
}
