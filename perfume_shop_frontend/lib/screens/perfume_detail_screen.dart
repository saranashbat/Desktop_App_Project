// lib/screens/perfume_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/perfume.dart';
import '../models/cart_item.dart';
import '../services/cart_service.dart';
import '../utils/app_state.dart';
import '../utils/constants.dart';
import '../models/user.dart';

class PerfumeDetailScreen extends StatefulWidget {
  final Perfume perfume;

  const PerfumeDetailScreen({super.key, required this.perfume});

  @override
  State<PerfumeDetailScreen> createState() => _PerfumeDetailScreenState();
}

class _PerfumeDetailScreenState extends State<PerfumeDetailScreen> {
  bool adding = false;
  final CartService _cartService = CartService();

  Future<void> _addToCart() async {
    
    final user = AppState().currentUser;
    

    if (user == null || user.id == null) {
      _showError('Please login first');
      return;
    }

    setState(() => adding = true);

    final item = CartItem(
      perfumeName: widget.perfume.name,
      unitPrice: widget.perfume.price,
      quantity: 1,
    );

    print('🛒 Adding to cart: ${widget.perfume.name}');

    try {
      final cart = await _cartService.addItem(user.id!, item);

      if (cart != null) {
        AppState().setCart(cart);
        _showSuccess('Added to cart!');
      }
    } catch (e) {
      print('❌ Error: $e');
      _showError('Failed to add to cart');
    } finally {
      if (mounted) setState(() => adding = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.success),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topNotes = widget.perfume.notes.where((n) => n.type == 'TOP').toList();
    final middleNotes = widget.perfume.notes.where((n) => n.type == 'MIDDLE').toList();
    final baseNotes = widget.perfume.notes.where((n) => n.type == 'BASE').toList();

    return Scaffold(
      backgroundColor: AppColors.background, // ✅ Dynamic color
      appBar: AppBar(
        title: Text(widget.perfume.name),
        backgroundColor: AppColors.primary, // ✅ Dynamic color
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroImage(),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    '\$${widget.perfume.price.toStringAsFixed(2)}',
                    style: AppTextStyles.h1.copyWith(color: AppColors.primary), // ✅ Dynamic style
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (widget.perfume.description != null) ...[
                    Text('Description', style: AppTextStyles.h2), // ✅ Dynamic style
                    const SizedBox(height: AppSpacing.sm),
                    Text(widget.perfume.description!, style: AppTextStyles.body), // ✅ Dynamic style
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  Text('Fragrance Notes', style: AppTextStyles.h2), // ✅ Dynamic style
                  const SizedBox(height: AppSpacing.md),
                  if (topNotes.isNotEmpty) _buildNoteSection('Top Notes', topNotes),
                  if (middleNotes.isNotEmpty) _buildNoteSection('Middle Notes', middleNotes),
                  if (baseNotes.isNotEmpty) _buildNoteSection('Base Notes', baseNotes),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildAddToCartButton(),
    );
  }

  Widget _buildHeroImage() {
    return Hero(
      tag: 'perfume-${widget.perfume.name}',
      child: Container(
        height: 400,
        width: double.infinity,
        color: AppColors.cardBackground, // ✅ Dynamic color (changed from Colors.white)
        child: widget.perfume.imagePath != null
            ? Image.asset(
                'assets/images/perfumes/${widget.perfume.imagePath!.split('/').last}',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon( // ✅ Removed const
                  Icons.image_not_supported,
                  size: 100,
                  color: AppColors.textSecondary,
                ),
              )
            : Icon(Icons.image_not_supported, size: 100, color: AppColors.textSecondary), // ✅ Removed const
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.perfume.name, style: AppTextStyles.h1), // ✅ Dynamic style
              const SizedBox(height: AppSpacing.xs),
              Text(
                widget.perfume.brand,
                style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary), // ✅ Dynamic style
              ),
            ],
          ),
        ),
        if (bestSellingNames.contains(widget.perfume.name))
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.bestSellerOrange,
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
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
    );
  }

  Widget _buildNoteSection(String title, List notes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.h3.copyWith(color: AppColors.primary)), // ✅ Dynamic style
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: notes.map((n) {
            final noteName = n.note?.name ?? 'Unknown';
            final notePhoto = n.note?.photo;
            return _buildNoteCard(noteName, notePhoto);
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  Widget _buildNoteCard(String noteName, String? notePhoto) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardBackground, // ✅ Dynamic color (changed from Colors.white)
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)), // ✅ Dynamic color
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1), // ✅ Dynamic color
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: notePhoto != null
                  ? Image.asset(
                      'assets/images/notes/${notePhoto.split('/').last}',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon( // ✅ Removed const
                        Icons.spa,
                        size: 24,
                        color: AppColors.primary,
                      ),
                    )
                  : Icon( // ✅ Removed const
                      Icons.spa,
                      size: 24,
                      color: AppColors.primary,
                    ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            noteName,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith( // ✅ Dynamic style
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground, // ✅ Dynamic color (changed from Colors.white)
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            onPressed: adding ? null : _addToCart,
            icon: adding
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.shopping_cart),
            label: Text(
              adding ? 'Adding...' : 'Add to Cart',
              style: AppTextStyles.button,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, // ✅ Dynamic color
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
            ),
          ),
        ),
      ),
    );
  }
}