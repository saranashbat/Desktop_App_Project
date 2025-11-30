// perfume.dart
import 'perfume_note.dart';

class Perfume {
  String? id;
  String name;
  String brand;
  double price;
  String? imagePath;
  String? description;
  List<PerfumeNote> notes;

  Perfume({
    this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imagePath,
    required this.description,
    required this.notes,
  });

   factory Perfume.fromJson(Map<String, dynamic> json) {
    return Perfume(
      id: json['_id']?['\$oid'],
      name: json['name'] ?? 'Unknown',
      brand: json['brand'] ?? 'Unknown',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imagePath: json['imagePath'],          // can be null
      description: json['description'],      // can be null
      notes: (json['notes'] as List? ?? [])
          .map((e) => PerfumeNote.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'brand': brand,
      'price': price,
      'imagePath': imagePath,
      'description': description,
      'notes': notes.map((e) => e.toJson()).toList(),
    };
  }
}