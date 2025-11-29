import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global/global_parameters.dart';
import '../models/order.dart';
import '../models/order_status.dart';

class OrderService {
  // -------------------------------
  // CREATE ORDER
  // -------------------------------
  Future<Order> createOrder(Order order) async {
    final response = await http.post(
      Uri.parse(GlobalParameters.ordersEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(order.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Order.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create order');
    }
  }

  // -------------------------------
  // GET ALL ORDERS (admin)
  // -------------------------------
  Future<List<Order>> getAllOrders() async {
    final response = await http.get(Uri.parse(GlobalParameters.ordersEndpoint));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Order.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  // -------------------------------
  // GET ORDERS BY USER
  // -------------------------------
  Future<List<Order>> getUserOrders(String userId) async {
    final response = await http.get(
      Uri.parse('${GlobalParameters.ordersEndpoint}/user/$userId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Order.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load orders for user $userId');
    }
  }

  // -------------------------------
  // UPDATE ORDER STATUS
  // -------------------------------
  Future<Order> updateOrderStatus(String orderId, OrderStatus status) async {
    final response = await http.patch(
      Uri.parse('${GlobalParameters.ordersEndpoint}/$orderId/status?status=${orderStatusToString(status)}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Order.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update order status');
    }
  }
}
