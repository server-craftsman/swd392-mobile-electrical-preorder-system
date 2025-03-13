
class ApiExceptions implements Exception {
  final String message;
  final int statusCode;

  ApiExceptions({required this.message, required this.statusCode});
}
