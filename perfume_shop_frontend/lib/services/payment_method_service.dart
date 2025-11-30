// lib/services/payment_method_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global/global_parameters.dart';
import '../models/payment_method.dart';

class PaymentMethodService {
  // GET ALL PAYMENT METHODS
  Future<List<PaymentMethod>> getAllPaymentMethods() async {
    try {
      print('🔄 Fetching payment methods from: ${GlobalParameters.paymentMethodsEndpoint}');
      
      final response = await http.get(
        Uri.parse(GlobalParameters.paymentMethodsEndpoint),
        headers: {'Content-Type': 'application/json'},
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        print('✅ Found ${data.length} payment methods');
        
        List<PaymentMethod> methods = data.map((e) {
          print('🔧 Parsing payment method: $e');
          return PaymentMethod.fromJson(e);
        }).toList();

        print('✅ Successfully parsed ${methods.length} payment methods');
        for (var method in methods) {
          print('  - ID: ${method.id}, Name: ${method.name}, Enabled: ${method.enabled}');
        }
        
        return methods;
      } else {
        throw Exception('Failed to load payment methods: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error loading payment methods: $e');
      rethrow;
    }
  }

  // CREATE PAYMENT METHOD
  Future<PaymentMethod> createPaymentMethod(PaymentMethod pm) async {
    try {
      final response = await http.post(
        Uri.parse(GlobalParameters.paymentMethodsEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(pm.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return PaymentMethod.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create payment method: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error creating payment method: $e');
      rethrow;
    }
  }
}