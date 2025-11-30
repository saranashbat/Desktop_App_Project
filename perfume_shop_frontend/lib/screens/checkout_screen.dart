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
  String? errorMessage;

  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
    final user = AppState().currentUser;
    if (user != null && user.defaultAddress != null) {
      addressController.text = user.defaultAddress!;
    }
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  // ✅ Calculate delivery fee based on delivery method
  double get deliveryFee {
    return deliveryMethod == 'pickup' ? 0.0 : 5.0;
  }

  // ✅ Calculate total with dynamic delivery fee
  double calculateTotal(double subtotal) {
    return subtotal + deliveryFee;
  }

  Future<void> _loadPaymentMethods() async {
    setState(() {
      loadingPayments = true;
      errorMessage = null;
    });

    try {
      print('🔄 Loading payment methods...');
      final methods = await PaymentMethodService().getAllPaymentMethods();
      
      print('✅ Loaded ${methods.length} payment methods');
      
      if (mounted) {
        setState(() {
          paymentMethods = methods.where((m) => m.enabled && m.id != null).toList();
          loadingPayments = false;
          
          print('✅ Filtered to ${paymentMethods.length} enabled payment methods');
          
          if (paymentMethods.isEmpty) {
            errorMessage = 'No payment methods available';
          }
        });
      }
    } catch (e) {
      print('❌ Error loading payment methods: $e');
      if (mounted) {
        setState(() {
          loadingPayments = false;
          errorMessage = 'Failed to load payment methods: $e';
        });
      }
    }
  }

  Future<void> _placeOrder() async {
    final user = AppState().currentUser;
    final cart = AppState().currentCart;

    if (user == null || user.id == null || cart == null) {
      _showError('Please login and add items to cart');
      return;
    }

    if (deliveryMethod == 'shipping' && addressController.text.trim().isEmpty) {
      _showError('Please enter delivery address');
      return;
    }

    if (selectedPaymentMethodId == null) {
      _showError('Please select a payment method');
      return;
    }

    setState(() => placing = true);

    try {
      final selectedPayment = paymentMethods.firstWhere(
        (pm) => pm.id == selectedPaymentMethodId,
        orElse: () => throw Exception('Invalid payment method selected'),
      );

      print('🛒 Creating order with payment method: ${selectedPayment.name}');

      // ✅ FIXED: Proper null handling for pickup location
      final order = Order(
        userId: user.id!,
        items: cart.items,
        subtotal: cart.subtotal,
        deliveryFee: deliveryFee,
        total: calculateTotal(cart.subtotal),
        deliveryMethod: deliveryMethod,
        deliveryAddress: deliveryMethod == 'shipping' 
            ? addressController.text.trim() 
            : null,
        pickupLocation: "123 Corniche St., Elite Notes Store, Doha, Qatar", // ✅ Always set
        paymentStatus: 'PENDING',
        paymentMethod: selectedPayment,
        orderStatus: OrderStatus.PROCESSING,
        createdAt: DateTime.now(),
      );

      await OrderService().createOrder(order);
      AppState().clearCart();

      if (mounted) {
        setState(() => placing = false);
        _showSuccessDialog();
      }
    } catch (e) {
      print('❌ Error placing order: $e');
      if (mounted) {
        setState(() => placing = false);
        _showError('Error placing order: $e');
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Order Placed!'),
        content: const Text(
          'Your order has been successfully placed. You can track it in Order History.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/perfumes',
                (route) => false,
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
      ),
      body: cart == null
          ? const Center(child: Text('No items in cart'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDeliverySection(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildPaymentSection(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildOrderSummary(cart),
                  const SizedBox(height: AppSpacing.xl),
                  _buildPlaceOrderButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildDeliverySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Delivery Method', style: AppTextStyles.h2),
        const SizedBox(height: AppSpacing.md),
        RadioListTile<String>(
          title: const Text('Shipping'),
          subtitle: const Text('Deliver to your address (+\$5.00)'),
          value: 'shipping',
          groupValue: deliveryMethod,
          onChanged: (val) {
            if (val != null) setState(() => deliveryMethod = val);
          },
          activeColor: AppColors.primary,
        ),
        RadioListTile<String>(
          title: const Text('Pickup'),
          subtitle: const Text('123 Corniche St., Elite Notes Store, Doha, Qatar (FREE)'),
          value: 'pickup',
          groupValue: deliveryMethod,
          onChanged: (val) {
            if (val != null) setState(() => deliveryMethod = val);
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
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            maxLines: 3,
          ),
        ],
      ],
    );
  }

  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method', style: AppTextStyles.h2),
        const SizedBox(height: AppSpacing.md),
        if (loadingPayments)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: CircularProgressIndicator(),
            ),
          )
        else if (errorMessage != null)
          Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(errorMessage!)),
                  TextButton(
                    onPressed: _loadPaymentMethods,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          )
        else if (paymentMethods.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Text('No payment methods available'),
            ),
          )
        else
          ...paymentMethods.map((pm) => RadioListTile<String>(
                title: Text(pm.name),
                subtitle: Text(pm.type),
                secondary: pm.imagePath != null
                    ? Image.asset(
                        'assets/images/payments/${pm.imagePath!.split('/').last}',
                        width: 40,
                        height: 40,
                        errorBuilder: (_, __, ___) => const Icon(Icons.payment),
                      )
                    : const Icon(Icons.payment),
                value: pm.id!,
                groupValue: selectedPaymentMethodId,
                onChanged: (val) {
                  setState(() => selectedPaymentMethodId = val);
                },
                activeColor: AppColors.primary,
              )),
      ],
    );
  }

  Widget _buildOrderSummary(cart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                _buildSummaryRow('Subtotal:', '\$${cart.subtotal.toStringAsFixed(2)}'),
                const SizedBox(height: AppSpacing.sm),
                if (deliveryMethod == 'shipping') ...[
                  _buildSummaryRow('Delivery Fee:', '\$${deliveryFee.toStringAsFixed(2)}'),
                  const SizedBox(height: AppSpacing.sm),
                ] else ...[
                  _buildSummaryRow('Delivery Fee:', 'FREE (Pickup)', 
                      valueColor: AppColors.success),
                  const SizedBox(height: AppSpacing.sm),
                ],
                const Divider(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total:', style: AppTextStyles.h2),
                    Text(
                      '\$${calculateTotal(cart.subtotal).toStringAsFixed(2)}',
                      style: AppTextStyles.h1.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.body),
        Text(
          value, 
          style: AppTextStyles.h3.copyWith(
            color: valueColor,
            fontWeight: valueColor != null ? FontWeight.bold : null,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceOrderButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: placing || loadingPayments ? null : _placeOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
        ),
        child: placing
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text('Place Order', style: AppTextStyles.button),
      ),
    );
  }
}