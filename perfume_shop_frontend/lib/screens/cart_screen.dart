// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../services/cart_service.dart';
import '../utils/app_state.dart';
import '../utils/constants.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/app_drawer.dart';

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
  }

  Future<void> loadCart() async {
    final user = AppState().currentUser;
    if (user == null || user.id == null) return;

    setState(() => loading = true);
    try {
      final cart = await CartService().getCartByUser(user.id!);
      AppState().setCart(cart!);
      setState(() => loading = false);
    } catch (e) {
      setState(() => loading = false);
    }
  }

  Future<void> updateQuantity(String perfumeId, int change) async {
    final user = AppState().currentUser;
    final cart = AppState().currentCart;
    
    if (user == null || user.id == null || cart == null) return;

    setState(() => loading = true);

    try {
      final currentItem = cart.items.firstWhere(
        (item) => item.perfumeId == perfumeId,
        orElse: () => CartItem(
          perfumeId: '',
          perfumeName: '',
          unitPrice: 0,
          quantity: 0,
        ),
      );

      if (currentItem.perfumeId.isEmpty) {
        setState(() => loading = false);
        return;
      }

      final newQuantity = currentItem.quantity + change;

      if (newQuantity <= 0) {
        await removeItem(perfumeId);
        return;
      }

      final updatedItem = CartItem(
        perfumeId: currentItem.perfumeId,
        perfumeName: currentItem.perfumeName,
        unitPrice: currentItem.unitPrice,
        quantity: newQuantity,
      );

      await CartService().removeItem(user.id!, perfumeId);
      final updatedCart = await CartService().addItem(user.id!, updatedItem);
      AppState().setCart(updatedCart);

      setState(() => loading = false);
    } catch (e) {
      setState(() => loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> removeItem(String perfumeId) async {
    final user = AppState().currentUser;
    if (user == null || user.id == null) return;

    setState(() => loading = true);

    try {
      final updatedCart = await CartService().removeItem(user.id!, perfumeId);
      AppState().setCart(updatedCart);

      setState(() => loading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item removed from cart'),
            backgroundColor: AppColors.warning,
          ),
        );
      }
    } catch (e) {
      setState(() => loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = AppState().currentCart;
    final hasItems = cart != null && cart.items.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : !hasItems
              ? Center(
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
                          Navigator.pushReplacementNamed(
                              context, '/perfumes');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Start Shopping'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: cart.items.length,
                        itemBuilder: (context, index) {
                          final item = cart.items[index];
                          return CartItemWidget(
                            item: item,
                            onIncrease: () =>
                                updateQuantity(item.perfumeId, 1),
                            onDecrease: () =>
                                updateQuantity(item.perfumeId, -1),
                            onRemove: () => removeItem(item.perfumeId),
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
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Subtotal:', style: AppTextStyles.body),
                                Text(
                                    '\$${cart.subtotal.toStringAsFixed(2)}',
                                    style: AppTextStyles.h3),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Delivery Fee:',
                                    style: AppTextStyles.body),
                                Text(
                                    '\$${cart.deliveryFee.toStringAsFixed(2)}',
                                    style: AppTextStyles.h3),
                              ],
                            ),
                            const Divider(height: AppSpacing.lg),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
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
                                    borderRadius: BorderRadius.circular(
                                        AppBorderRadius.md),
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