// lib/screens/perfume_list_screen.dart
import 'package:flutter/material.dart';
import '../models/perfume.dart';
import '../services/perfume_service.dart';
import '../utils/constants.dart';
import '../widgets/perfume_card.dart';
import '../widgets/app_drawer.dart';
import '../widgets/filter_dropdown.dart';

class PerfumeListScreen extends StatefulWidget {
  const PerfumeListScreen({super.key});

  @override
  State<PerfumeListScreen> createState() => _PerfumeListScreenState();
}

class _PerfumeListScreenState extends State<PerfumeListScreen> {
  List<Perfume> perfumes = [];
  List<Perfume> filteredPerfumes = [];
  bool loading = true;
  String? selectedBrand;
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
      final data = await PerfumeService().getAllPerfumes();
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

    if (selectedBrand != null) {
      temp = temp.where((p) => p.brand == selectedBrand).toList();
    }

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
      selectedBrand = null;
      selectedNote = null;
      ascendingPrice = true;
      filteredPerfumes = List.from(perfumes);
    });
    applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final brands = perfumes.map((p) => p.brand).toSet().toList();
    final notes = perfumes
        .expand((p) => p.notes)
        .map((n) => n.note?.name ?? '')
        .where((n) => n.isNotEmpty)
        .toSet()
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('All Perfumes'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: FilterDropdown(
                              hint: 'Brand',
                              value: selectedBrand,
                              items: brands,
                              onChanged: (val) {
                                setState(() => selectedBrand = val);
                                applyFilters();
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: FilterDropdown(
                              hint: 'Note',
                              value: selectedNote,
                              items: notes,
                              onChanged: (val) {
                                setState(() => selectedNote = val);
                                applyFilters();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: resetFilters,
                              icon: const Icon(Icons.clear_all),
                              label: const Text('Reset'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          OutlinedButton.icon(
                            onPressed: () {
                              setState(() => ascendingPrice = !ascendingPrice);
                              applyFilters();
                            },
                            icon: Icon(ascendingPrice
                                ? Icons.arrow_upward
                                : Icons.arrow_downward),
                            label: Text(ascendingPrice
                                ? 'Price: Low-High'
                                : 'Price: High-Low'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                            ),
                          ),
                        ],
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