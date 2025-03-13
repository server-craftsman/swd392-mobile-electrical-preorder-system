class AuthRequest {
  Future<Map<String, String>> loginRequest(
    String username,
    String password,
    String googleAccountId,
    String fullName,
  ) {
    // TODO: Implement login request logic
    // Return a Future with login response
    return Future.value({
      'username': username,
      'password': password,
      'googleAccountId': googleAccountId,
      'fullName': fullName,
    });
  }
}
