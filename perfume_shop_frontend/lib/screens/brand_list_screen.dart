// lib/screens/brand_list_screen.dart
import 'package:flutter/material.dart';
import '../models/brand.dart';
import '../services/brand_service.dart';
import '../utils/constants.dart';
import '../widgets/app_drawer.dart';

class BrandListScreen extends StatefulWidget {
  const BrandListScreen({super.key});

  @override
  State<BrandListScreen> createState() => _BrandListScreenState();
}

class _BrandListScreenState extends State<BrandListScreen> {
  List<Brand> brands = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchBrands();
  }

  Future<void> fetchBrands() async {
    setState(() => loading = true);
    try {
      final data = await BrandService().getAllBrands();
      setState(() {
        brands = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading brands: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // ✅ Dynamic color
      appBar: AppBar(
        title: const Text('Luxury Brands'),
        backgroundColor: AppColors.primary, // ✅ Dynamic color
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : brands.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.business_outlined, // ✅ Removed const
                          size: 64, color: AppColors.textSecondary),
                      const SizedBox(height: AppSpacing.md),
                      Text('No brands available',
                          style: AppTextStyles.h3), // ✅ Dynamic style
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  itemCount: brands.length,
                  itemBuilder: (context, index) {
                    final brand = brands[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/brand-perfumes',
                          arguments: brand,
                        );
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppBorderRadius.md),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (brand.logoPath != null)
                              Image.asset(
                                'assets/images/brands/${brand.logoPath!.split('/').last}',
                                height: 60,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.business, // ✅ Removed const
                                      size: 60, color: AppColors.primary);
                                },
                              )
                            else
                              Icon(Icons.business, // ✅ Removed const
                                  size: 60, color: AppColors.primary),
                            const SizedBox(height: AppSpacing.md),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm),
                              child: Text(
                                brand.name,
                                style: AppTextStyles.h3, // ✅ Dynamic style
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (brand.description != null) ...[
                              const SizedBox(height: AppSpacing.xs),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm),
                                child: Text(
                                  brand.description!,
                                  style: AppTextStyles.caption, // ✅ Dynamic style
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}