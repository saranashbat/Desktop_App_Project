// lib/utils/app_state.dart
import '../models/user.dart';
import '../models/cart.dart';
import '../models/cart_item.dart';

class AppState {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  User? currentUser;
  Cart? currentCart;

  void setUser(User user) {
    currentUser = user;
  }

  void clearUser() {
    currentUser = null;
    currentCart = null;
  }

  void setCart(Cart cart) {
    currentCart = cart;
  }

  void clearCart() {
    currentCart = null;
  }

  int get cartItemCount {
    if (currentCart == null) return 0;
    return currentCart!.items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get cartTotal {
    return currentCart?.total ?? 0.0;
  }

  bool isInCart(String perfumeId) {
    if (currentCart == null) return false;
    return currentCart!.items.any((item) => item.perfumeId == perfumeId);
  }

  int getQuantityInCart(String perfumeId) {
    if (currentCart == null) return 0;
    try {
      final item = currentCart!.items.firstWhere(
        (item) => item.perfumeId == perfumeId,
      );
      return item.quantity;
    } catch (e) {
      return 0;
    }
  }
}