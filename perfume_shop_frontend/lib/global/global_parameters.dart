// lib/global/global_parameters.dart

class GlobalParameters {
  // Base URL of your Spring Boot backend
  // Change this if your backend runs elsewhere (e.g., LAN IP, production)
  static const String apiBaseUrl = 'http://127.0.0.1:8080/api';

  // Perfumes endpoint
  static const String perfumesEndpoint = '$apiBaseUrl/perfumes';

  // Brands endpoint
  static const String brandsEndpoint = '$apiBaseUrl/brands';

  // Cart endpoint
  static const String cartsEndpoint = '$apiBaseUrl/carts';

  // Notes endpoint
  static const String notesEndpoint = '$apiBaseUrl/notes';

  // Orders endpoint
  static const String ordersEndpoint = '$apiBaseUrl/orders';

  // Users endpoint
  static const String paymentMethodsEndpoint = '$apiBaseUrl/payment-methods';

  // Users endpoint
  static const String usersEndpoint = '$apiBaseUrl/users';



}
