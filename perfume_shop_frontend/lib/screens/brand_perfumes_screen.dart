// lib/screens/brand_perfumes_screen.dart
import 'package:flutter/material.dart';
import '../models/brand.dart';
import '../models/perfume.dart';
import '../services/perfume_service.dart';
import '../utils/constants.dart';
import '../widgets/perfume_card.dart';
import '../widgets/filter_dropdown.dart';

class BrandPerfumesScreen extends StatefulWidget {
  final Brand brand;

  const BrandPerfumesScreen({super.key, required this.brand});

  @override
  State<BrandPerfumesScreen> createState() => _BrandPerfumesScreenState();
}

class _BrandPerfumesScreenState extends State<BrandPerfumesScreen> {
  List<Perfume> perfumes = [];
  List<Perfume> filteredPerfumes = [];
  bool loading = true;
  String? selectedNote;
  bool ascendingPrice = true;

  @override
  void initState() {
    super.initState();
    fetchPerfumes();
  }

  Future<void> fetchPerfumes() async {
    setState(() => loading = true);
    try {
      final data =
          await PerfumeService().getPerfumesByBrand(widget.brand.name);
      setState(() {
        perfumes = data;
        filteredPerfumes = List.from(perfumes);
        loading = false;
      });
      applyFilters();
    } catch (e) {
      setState(() => loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading perfumes: $e')),
        );
      }
    }
  }

  void applyFilters() {
    List<Perfume> temp = List.from(perfumes);

    if (selectedNote != null) {
      temp = temp
          .where((p) => p.notes.any((n) =>
              (n.note?.name ?? '').toLowerCase() ==
              selectedNote!.toLowerCase()))
          .toList();
    }

    temp.sort((a, b) {
      return ascendingPrice
          ? a.price.compareTo(b.price)
          : b.price.compareTo(a.price);
    });

    setState(() {
      filteredPerfumes = temp;
    });
  }

  void resetFilters() {
    setState(() {
      selectedNote = null;
      ascendingPrice = true;
      filteredPerfumes = List.from(perfumes);
    });
    applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final notes = perfumes
        .expand((p) => p.notes)
        .map((n) => n.note?.name ?? '')
        .where((n) => n.isNotEmpty)
        .toSet()
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.brand.name),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      if (widget.brand.description != null) ...[
                        Text(
                          widget.brand.description!,
                          style: AppTextStyles.bodySecondary,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: FilterDropdown(
                              hint: 'Filter by Note',
                              value: selectedNote,
                              items: notes,
                              onChanged: (val) {
                                setState(() => selectedNote = val);
                                applyFilters();
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: resetFilters,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                              ),
                              child: const Text('Reset'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() => ascendingPrice = !ascendingPrice);
                          applyFilters();
                        },
                        icon: Icon(ascendingPrice
                            ? Icons.arrow_upward
                            : Icons.arrow_downward),
                        label: Text(ascendingPrice
                            ? 'Price: Low to High'
                            : 'Price: High to Low'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: filteredPerfumes.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.search_off,
                                  size: 64, color: AppColors.textSecondary),
                              const SizedBox(height: AppSpacing.md),
                              Text('No perfumes found',
                                  style: AppTextStyles.h3),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            crossAxisSpacing: AppSpacing.md,
                            mainAxisSpacing: AppSpacing.md,
                          ),
                          itemCount: filteredPerfumes.length,
                          itemBuilder: (context, index) {
                            final perfume = filteredPerfumes[index];
                            final isBestSeller = bestSellingNames
                                .contains(perfume.name);
                            return PerfumeCard(
                              perfume: perfume,
                              isBestSeller: isBestSeller,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/perfume-detail',
                                  arguments: perfume,
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}