// lib/widgets/perfume_card.dart
import 'package:flutter/material.dart';
import '../models/perfume.dart';
import '../utils/constants.dart';

class PerfumeCard extends StatelessWidget {
  final Perfume perfume;
  final bool isBestSeller;
  final VoidCallback onTap;

  const PerfumeCard({
    super.key,
    required this.perfume,
    required this.isBestSeller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        color: AppColors.cardBackground, // ✅ Dynamic color
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppBorderRadius.md),
                    ),
                    child: perfume.imagePath != null
                        ? Image.asset(
                            'assets/images/perfumes/${perfume.imagePath!.split('/').last}',
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.divider, // ✅ Dynamic color
                                child: Icon(Icons.image_not_supported, // ✅ Removed const
                                    size: 48, color: AppColors.textSecondary),
                              );
                            },
                          )
                        : Container(
                            color: AppColors.divider, // ✅ Dynamic color
                            child: Icon(Icons.image_not_supported, // ✅ Removed const
                                size: 48, color: AppColors.textSecondary),
                          ),
                  ),
                  if (isBestSeller)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bestSellerOrange,
                          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                        ),
                        child: const Text(
                          'BEST SELLER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Text section
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    perfume.name,
                    style: AppTextStyles.h3, // ✅ Dynamic style
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    perfume.brand,
                    style: AppTextStyles.caption, // ✅ Dynamic style
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '\$${perfume.price.toStringAsFixed(2)}',
                    style: AppTextStyles.price, // ✅ Dynamic style
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}