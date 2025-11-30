// lib/screens/checkout_screen.dart
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/payment_method.dart';
import '../models/order_status.dart';
import '../services/order_service.dart';
import '../services/payment_method_service.dart';
import '../utils/app_state.dart';
import '../utils/constants.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String deliveryMethod = 'shipping';
  String? selectedPaymentMethodId;
  List<PaymentMethod> paymentMethods = [];
  bool loadingPayments = true;
  bool placing = false;

  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPaymentMethods();
    final user = AppState().currentUser;
    if (user != null && user.defaultAddress != null) {
      addressController.text = user.defaultAddress!;
    }
  }

  Future<void> loadPaymentMethods() async {
    setState(() => loadingPayments = true);
    try {
      final methods = await PaymentMethodService().getAllPaymentMethods();
      setState(() {
        paymentMethods = methods.where((m) => m.enabled).toList();
        loadingPayments = false;
      });
    } catch (e) {
      setState(() => loadingPayments = false);
    }
  }

  Future<void> placeOrder() async {
    final user = AppState().currentUser;
    final cart = AppState().currentCart;

    if (user == null || user.id == null || cart == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login and add items to cart')),
        );
      }
      return;
    }

    if (deliveryMethod == 'shipping' && addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter delivery address')),
      );
      return;
    }

    if (selectedPaymentMethodId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }

    setState(() => placing = true);

    try {
      PaymentMethod? selectedPayment;
      try {
        selectedPayment = paymentMethods.firstWhere(
          (pm) => pm.id == selectedPaymentMethodId,
        );
      } catch (e) {
        setState(() => placing = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid payment method selected')),
          );
        }
        return;
      }

      final order = Order(
        userId: user.id!,
        items: cart.items,
        subtotal: cart.subtotal,
        deliveryFee: cart.deliveryFee,
        total: cart.total,
        deliveryMethod: deliveryMethod,
        deliveryAddress:
            deliveryMethod == 'shipping' ? addressController.text.trim() : null,
        pickupLocation: "123 Corniche St., Elite Notes Store, Doha, Qatar",
        paymentStatus: 'PENDING',
        paymentMethod: selectedPayment,
        orderStatus: OrderStatus.PROCESSING,
        createdAt: DateTime.now(),
      );

      await OrderService().createOrder(order);
      AppState().clearCart();

      setState(() => placing = false);

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Order Placed!'),
            content: const Text(
                'Your order has been successfully placed. You can track it in Order History.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/perfumes', (route) => false);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() => placing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error placing order: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = AppState().currentCart;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: cart == null
          ? const Center(child: Text('No items in cart'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Delivery Method', style: AppTextStyles.h2),
                  const SizedBox(height: AppSpacing.md),
                  RadioListTile<String>(
                    title: const Text('Shipping'),
                    subtitle: const Text('Deliver to your address'),
                    value: 'shipping',
                    groupValue: deliveryMethod,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => deliveryMethod = val);
                      }
                    },
                    activeColor: AppColors.primary,
                  ),
                  RadioListTile<String>(
                    title: const Text('Pickup'),
                    subtitle: const Text(
                        '123 Corniche St., Elite Notes Store, Doha, Qatar'),
                    value: 'pickup',
                    groupValue: deliveryMethod,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => deliveryMethod = val);
                      }
                    },
                    activeColor: AppColors.primary,
                  ),
                  if (deliveryMethod == 'shipping') ...[
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: 'Delivery Address',
                        hintText: 'Enter your full address',
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppBorderRadius.md),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      maxLines: 3,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  Text('Payment Method', style: AppTextStyles.h2),
                  const SizedBox(height: AppSpacing.md),
                  loadingPayments
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: paymentMethods.where((pm) => pm.id != null).map((pm) {
                            return RadioListTile<String>(
                              title: Text(pm.name),
                              subtitle: Text(pm.type),
                              secondary: pm.imagePath != null
                                  ? Image.asset(
                                      'assets/images/payments/${pm.imagePath!.split('/').last}',
                                      width: 40,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.payment);
                                      },
                                    )
                                  : const Icon(Icons.payment),
                              value: pm.id!,
                              groupValue: selectedPaymentMethodId,
                              onChanged: (val) {
                                setState(() => selectedPaymentMethodId = val);
                              },
                              activeColor: AppColors.primary,
                            );
                          }).toList(),
                        ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Order Summary', style: AppTextStyles.h2),
                  const SizedBox(height: AppSpacing.md),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
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
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: placing ? null : placeOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppBorderRadius.md),
                        ),
                      ),
                      child: placing
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : Text('Place Order', style: AppTextStyles.button),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}