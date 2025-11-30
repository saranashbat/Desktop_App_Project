// lib/widgets/cart_item_widget.dart
import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../utils/constants.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final subtotal = item.unitPrice * item.quantity;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.perfumeName, style: AppTextStyles.h3),
                  const SizedBox(height: AppSpacing.xs),
                  Text('\$${item.unitPrice.toStringAsFixed(2)} each',
                      style: AppTextStyles.bodySecondary),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Subtotal: \$${subtotal.toStringAsFixed(2)}',
                      style: AppTextStyles.price),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      color: AppColors.primary,
                      onPressed: item.quantity > 1 ? onDecrease : onRemove,
                    ),
                    Text('${item.quantity}',
                        style: AppTextStyles.h3),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      color: AppColors.primary,
                      onPressed: onIncrease,
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('Remove'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}