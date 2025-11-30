import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global/global_parameters.dart';
import '../models/cart.dart';
import '../models/cart_item.dart';

class CartService {
  // -------------------------------
  // GET CART BY USER ID
  // -------------------------------
  Future<Cart?> getCartByUser(String userId) async {
    final response = await http.get(Uri.parse('${GlobalParameters.cartsEndpoint}/user/$userId'));

    if (response.statusCode == 200) {
      return Cart.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception("Failed to load user's cart");
    }
  }

  // -------------------------------
  // ADD ITEM TO CART
  // -------------------------------
  Future<Cart> addItem(String userId, CartItem item) async {
    final response = await http.post(
      Uri.parse('${GlobalParameters.cartsEndpoint}/user/$userId/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );

    if (response.statusCode == 200) {
      return Cart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to add item to cart");
    }
  }

  // -------------------------------
  // REMOVE ITEM FROM CART
  // -------------------------------
 Future<Cart> removeItem(String userId, String perfumeName) async {
  final response = await http.delete(
    Uri.parse('${GlobalParameters.cartsEndpoint}/user/$userId/remove/$perfumeName'),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    return Cart.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to remove item from cart");
  }
}

}
