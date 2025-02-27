class RegisterRequest {
  final String username;
  final String password;
  final String fullname;
  final String email;
  final String phoneNumber;
  final String address;
  final String role;
  final bool active;

  RegisterRequest({
    required this.username,
    required this.password,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.role,
    required this.active,
  });
}
