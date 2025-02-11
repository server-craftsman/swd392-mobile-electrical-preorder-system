class ROUTER_PATH {
  static const String LOGIN = '/login';
  static const String REGISTER = '/register';
  static const String UNAUTHORIZED = '/unauthorized';

  static const Map<String, String> COMMON = {
    'HOME': '/',
  };

  static const Map<String, String> USER = {
    'PROFILE': '/profile',
  };

  static const Map<String, String> ADMIN = {
    'BASE': '/admin',
  };
}
