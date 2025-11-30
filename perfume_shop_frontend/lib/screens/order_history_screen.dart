// lib/screens/order_history_screen.dart
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../services/order_service.dart';
import '../utils/app_state.dart';
import '../utils/constants.dart';
import '../widgets/app_drawer.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<Order> orders = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    if (AppState().currentUser == null) return;

    setState(() => loading = true);
    try {
      final data =
          await OrderService().getUserOrders(AppState().currentUser!.id!);
      setState(() {
        orders = data..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading orders: $e')),
        );
      }
    }
  }

  Color getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.PROCESSING:
        return AppColors.warning;
      case OrderStatus.SHIPPED:
        return Colors.blue;
      case OrderStatus.DELIVERED:
        return AppColors.success;
      case OrderStatus.CANCELED:
        return AppColors.error;
    }
  }

  String formatStatus(OrderStatus status) {
    return status.toString().split('.').last;
  }

  @override
  Widget build(BuildContext context) {
    final ongoingOrders = orders
        .where((o) =>
            o.orderStatus != OrderStatus.DELIVERED &&
            o.orderStatus != OrderStatus.CANCELED)
        .toList();
    final pastOrders = orders
        .where((o) =>
            o.orderStatus == OrderStatus.DELIVERED ||
            o.orderStatus == OrderStatus.CANCELED)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Order History'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.receipt_long_outlined,
                          size: 100, color: AppColors.textSecondary),
                      const SizedBox(height: AppSpacing.lg),
                      Text('No orders yet', style: AppTextStyles.h2),
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
              : ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    if (ongoingOrders.isNotEmpty) ...[
                      Text('Ongoing Orders', style: AppTextStyles.h2),
                      const SizedBox(height: AppSpacing.md),
                      ...ongoingOrders.map((order) => _buildOrderCard(order)),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    if (pastOrders.isNotEmpty) ...[
                      Text('Past Orders', style: AppTextStyles.h2),
                      const SizedBox(height: AppSpacing.md),
                      ...pastOrders.map((order) => _buildOrderCard(order)),
                    ],
                  ],
                ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: getStatusColor(order.orderStatus).withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          ),
          child: Icon(
            order.orderStatus == OrderStatus.DELIVERED
                ? Icons.check_circle
                : order.orderStatus == OrderStatus.SHIPPED
                    ? Icons.local_shipping
                    : order.orderStatus == OrderStatus.CANCELED
                        ? Icons.cancel
                        : Icons.hourglass_empty,
            color: getStatusColor(order.orderStatus),
          ),
        ),
        title: Text(
          'Order - ${order.createdAt.toString().split(' ')[0]}',
          style: AppTextStyles.h3,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xs),
            Text(
              formatStatus(order.orderStatus),
              style: TextStyle(
                color: getStatusColor(order.orderStatus),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Text(
          '\$${order.total.toStringAsFixed(2)}',
          style: AppTextStyles.price,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                Text('Items:', style: AppTextStyles.h3),
                const SizedBox(height: AppSpacing.sm),
                ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text('${item.perfumeName} (x${item.quantity})'),
                          ),
                          Text('\$${(item.unitPrice * item.quantity).toStringAsFixed(2)}'),
                        ],
                      ),
                    )),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal:', style: AppTextStyles.body),
                    Text('\$${order.subtotal.toStringAsFixed(2)}'),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delivery Fee:', style: AppTextStyles.body),
                    Text('\$${order.deliveryFee.toStringAsFixed(2)}'),
                  ],
                ),
                const Divider(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total:', style: AppTextStyles.h3),
                    Text('\$${order.total.toStringAsFixed(2)}',
                        style: AppTextStyles.price),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Delivery Method:',
                    style: AppTextStyles.bodySecondary),
                Text(
                  order.deliveryMethod == 'shipping'
                      ? 'Shipping to: ${order.deliveryAddress}'
                      : 'Pickup at: ${order.pickupLocation}',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text('Payment:', style: AppTextStyles.bodySecondary),
                Text(
                  '${order.paymentMethod.name} - ${order.paymentStatus}',
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}