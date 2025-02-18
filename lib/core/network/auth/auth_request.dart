class AuthRequest {
  Map<String, String> loginRequest(String username, String password,
      String googleAccountId, String email) {
    return {
      'username': username,
      'password': password,
      'googleAccountId': googleAccountId,
      'email': email
    };
  }
}

