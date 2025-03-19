class User {
  final String id;
  final String username;
  final String fullname;
  final String email;
  final String phoneNumber;
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
      id: json['id'],
      username: json['username'],
      fullname: json['fullname'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      status: json['status'],
      role: json['role'],
      avatar: json['avatar'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      verified: json['verified'],
      deleted: json['deleted'],
    );
  }
}
