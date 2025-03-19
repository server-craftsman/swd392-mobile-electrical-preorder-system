class API_PATH {
  static const String CATEGORIES = '/categories';
  static const String PRODUCTS = '/products';
  static const String USERS = '/users';
  static const String ORDERS = '/orders';
  static const String AUTH = '/auth';

  // Method to get admin endpoint
  static String ADMIN(String endpoint) => '/admin$endpoint';
}
