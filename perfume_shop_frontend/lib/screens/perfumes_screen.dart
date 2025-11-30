import 'package:flutter/material.dart';
import '../models/perfume.dart';
import '../services/perfume_service.dart';

class PerfumesScreen extends StatefulWidget {
  const PerfumesScreen({super.key});

  @override
  State<PerfumesScreen> createState() => _PerfumesScreenState();
}

class _PerfumesScreenState extends State<PerfumesScreen> {
  final PerfumeService _perfumeService = PerfumeService();
  List<Perfume> _perfumes = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPerfumes();
  }

  Future<void> _loadPerfumes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final perfumes = await _perfumeService.getAllPerfumes();
      setState(() {
        _perfumes = perfumes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfume Collection'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading perfumes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPerfumes,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_perfumes.isEmpty) {
      return const Center(
        child: Text('No perfumes found'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPerfumes,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _perfumes.length,
        itemBuilder: (context, index) {
          final perfume = _perfumes[index];
          return _buildPerfumeCard(perfume);
        },
      ),
    );
  }

  Widget _buildPerfumeCard(Perfume perfume) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: perfume.imagePath != null
                  ? Image.asset(
                      'assets${perfume.imagePath}',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported),
                        );
                      },
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image),
                    ),
            ),
            const SizedBox(width: 16),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    perfume.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    perfume.brand,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${perfume.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                  if (perfume.description != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      perfume.description!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (perfume.notes.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: perfume.notes
                          .where((note) => note.note?.name != null)
                          .take(3)
                          .map((note) => Chip(
                                label: Text(
                                  note.note!.name!,
                                  style: const TextStyle(fontSize: 10),
                                ),
                                backgroundColor: _getNoteColor(note.type),
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getNoteColor(String? type) {
    switch (type?.toUpperCase()) {
      case 'TOP':
        return Colors.amber[100]!;
      case 'MIDDLE':
        return Colors.pink[100]!;
      case 'BASE':
        return Colors.brown[100]!;
      default:
        return Colors.grey[200]!;
    }
  }
}