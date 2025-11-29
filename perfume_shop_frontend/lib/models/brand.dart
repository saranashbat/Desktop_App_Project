// brand.dart
class Brand {
  String? id;
  String name;
  String? description; // optional
  String? logoPath;

  Brand({
    this.id,
    required this.name,
    this.description,
    this.logoPath,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['_id']?['\$oid'], // if MongoDB ObjectId comes this way
      name: json['name'],
      description: json['description'],
      logoPath: json['logoPath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'logoPath': logoPath,
    };
  }
}
