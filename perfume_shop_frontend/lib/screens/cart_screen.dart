// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../services/cart_service.dart';
import '../utils/app_state.dart';
import '../utils/constants.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/app_drawer.dart';
import '../models/user.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadCart();

    // TEMP: fake user for testing (remove when auth is ready)
    if (AppState().currentUser == null) {
      AppState().setUser(User(
        id: 'test123',
        username: 'Test User',
        email: 'test@test.com',
        imagePath: null,
        passwordHash: "hi",
      ));
    }
  }

  Future<void> loadCart() async {
    final user = AppState().currentUser;
    if (user == null || user.id == null) return;

    setState(() => loading = true);
    try {
      final cart = await CartService().getCartByUser(user.id!);
      if (cart != null) AppState().setCart(cart);
    } catch (e) {
      debugPrint('Error loading cart: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> updateQuantity(String perfumeName, int change) async {
    final user = AppState().currentUser;
    final cart = AppState().currentCart;

    if (user == null || user.id == null || cart == null) return;

    setState(() => loading = true);

    try {
      // Find item by perfumeName
      final currentItem = cart.items.firstWhere(
        (item) => item.perfumeName.toLowerCase() == perfumeName.toLowerCase(),
        orElse: () => CartItem(
          perfumeName: '',
          unitPrice: 0,
          quantity: 0,
        ),
      );

      if (currentItem.perfumeName.isEmpty) return;

      final newQuantity = currentItem.quantity + change;

      if (newQuantity <= 0) {
        await removeItem(perfumeName);
        return;
      }

      final updatedItem = CartItem(
        perfumeName: currentItem.perfumeName,
        unitPrice: currentItem.unitPrice,
        quantity: newQuantity,
      );

      // Remove old item and add updated
      await CartService().removeItem(user.id!, currentItem.perfumeName);
      final updatedCart = await CartService().addItem(user.id!, updatedItem);
      AppState().setCart(updatedCart);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> removeItem(String perfumeName) async {
    final user = AppState().currentUser;
    if (user == null || user.id == null) return;

    setState(() => loading = true);

    try {
      final updatedCart = await CartService().removeItem(user.id!, perfumeName);
      AppState().setCart(updatedCart);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item removed from cart'),
            backgroundColor: AppColors.warning,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = AppState().currentCart;

    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (cart == null || cart.items.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Shopping Cart'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        drawer: const AppDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_cart_outlined,
                  size: 100, color: AppColors.textSecondary),
              const SizedBox(height: AppSpacing.lg),
              Text('Your cart is empty', style: AppTextStyles.h2),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/perfumes');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Start Shopping'),
              ),
            ],
          ),
        ),
      );
    }

    // Safe: cart is non-null and has items
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return CartItemWidget(
                  item: item,
                  onIncrease: () => updateQuantity(item.perfumeName, 1),
                  onDecrease: () => updateQuantity(item.perfumeName, -1),
                  onRemove: () => removeItem(item.perfumeName),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal:', style: AppTextStyles.body),
                      Text('\$${cart.subtotal.toStringAsFixed(2)}',
                          style: AppTextStyles.h3),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delivery Fee:', style: AppTextStyles.body),
                      Text('\$${cart.deliveryFee.toStringAsFixed(2)}',
                          style: AppTextStyles.h3),
                    ],
                  ),
                  const Divider(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total:', style: AppTextStyles.h2),
                      Text('\$${cart.total.toStringAsFixed(2)}',
                          style: AppTextStyles.h1
                              .copyWith(color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/checkout');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppBorderRadius.md),
                        ),
                      ),
                      child: Text('Proceed to Checkout',
                          style: AppTextStyles.button),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
