// lib/screens/perfume_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/perfume.dart';
import '../models/cart_item.dart';
import '../services/cart_service.dart';
import '../utils/app_state.dart';
import '../utils/constants.dart';

class PerfumeDetailScreen extends StatefulWidget {
  final Perfume perfume;

  const PerfumeDetailScreen({super.key, required this.perfume});

  @override
  State<PerfumeDetailScreen> createState() => _PerfumeDetailScreenState();
}

class _PerfumeDetailScreenState extends State<PerfumeDetailScreen> {
  bool adding = false;
  final isBestSeller = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> addToCart() async {
    if (AppState().currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login first')),
      );
      return;
    }

    setState(() => adding = true);

    try {
      final item = CartItem(
        perfumeId: widget.perfume.id ?? '',
        perfumeName: widget.perfume.name,
        unitPrice: widget.perfume.price,
        quantity: 1,
      );

      final cart = await CartService()
          .addItem(AppState().currentUser!.id!, item);
      AppState().setCart(cart);

      setState(() => adding = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to cart!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() => adding = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final topNotes =
        widget.perfume.notes.where((n) => n.type == 'TOP').toList();
    final middleNotes =
        widget.perfume.notes.where((n) => n.type == 'MIDDLE').toList();
    final baseNotes =
        widget.perfume.notes.where((n) => n.type == 'BASE').toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.perfume.name),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'perfume-${widget.perfume.id}',
              child: Container(
                height: 400,
                width: double.infinity,
                color: Colors.white,
                child: widget.perfume.imagePath != null
                    ? Image.asset(
                        'assets/images/perfumes/${widget.perfume.imagePath!.split('/').last}',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image_not_supported,
                              size: 100, color: AppColors.textSecondary);
                        },
                      )
                    : const Icon(Icons.image_not_supported,
                        size: 100, color: AppColors.textSecondary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.perfume.name,
                                style: AppTextStyles.h1),
                            const SizedBox(height: AppSpacing.xs),
                            Text(widget.perfume.brand,
                                style: AppTextStyles.h3.copyWith(
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      if (bestSellingIds
                          .contains(widget.perfume.id ?? ''))
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.bestSellerOrange,
                            borderRadius:
                                BorderRadius.circular(AppBorderRadius.sm),
                          ),
                          child: const Text(
                            'BEST SELLER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('\$${widget.perfume.price.toStringAsFixed(2)}',
                      style: AppTextStyles.h1
                          .copyWith(color: AppColors.primary)),
                  const SizedBox(height: AppSpacing.lg),
                  if (widget.perfume.description != null) ...[
                    Text('Description', style: AppTextStyles.h2),
                    const SizedBox(height: AppSpacing.sm),
                    Text(widget.perfume.description!,
                        style: AppTextStyles.body),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  Text('Fragrance Notes', style: AppTextStyles.h2),
                  const SizedBox(height: AppSpacing.md),
                  if (topNotes.isNotEmpty)
                    _buildNoteSection('Top Notes', topNotes),
                  if (middleNotes.isNotEmpty)
                    _buildNoteSection('Middle Notes', middleNotes),
                  if (baseNotes.isNotEmpty)
                    _buildNoteSection('Base Notes', baseNotes),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
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
          child: SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: adding ? null : addToCart,
              icon: adding
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.shopping_cart),
              label: Text(adding ? 'Adding...' : 'Add to Cart',
                  style: AppTextStyles.button),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoteSection(String title, List notes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: AppTextStyles.h3.copyWith(color: AppColors.primary)),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: notes.map((n) {
            final noteName = n.note?.name ?? 'Unknown';
            final notePhoto = n.note?.photo;
            return Chip(
              avatar: notePhoto != null
                  ? CircleAvatar(
                      backgroundImage: AssetImage(
                          'assets/images/notes/${notePhoto.split('/').last}'),
                    )
                  : const CircleAvatar(
                      child: Icon(Icons.spa, size: 16),
                    ),
              label: Text(noteName),
              backgroundColor: AppColors.primary.withOpacity(0.1),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}