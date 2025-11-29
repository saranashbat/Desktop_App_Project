import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global/global_parameters.dart';
import '../models/payment_method.dart';

class PaymentMethodService {
  // -------------------------------
  // GET ALL PAYMENT METHODS
  // -------------------------------
  Future<List<PaymentMethod>> getAllPaymentMethods() async {
    final response = await http.get(Uri.parse(GlobalParameters.paymentMethodsEndpoint));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => PaymentMethod.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load payment methods');
    }
  }

  // -------------------------------
  // CREATE PAYMENT METHOD
  // -------------------------------
  Future<PaymentMethod> createPaymentMethod(PaymentMethod pm) async {
    final response = await http.post(
      Uri.parse(GlobalParameters.paymentMethodsEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pm.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return PaymentMethod.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create payment method');
    }
  }
}
