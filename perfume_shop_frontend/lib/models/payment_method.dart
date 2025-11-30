// payment_method.dart
class PaymentMethod {
  String? id;
  String name;
  String type;
  String? imagePath;
  bool enabled;

  PaymentMethod({
    this.id,
    required this.name,
    required this.type,
    this.imagePath,
    required this.enabled,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['_id'] != null ? json['_id']['\$oid'] as String? : null, // ✅ FIXED
      name: json['name'],
      type: json['type'],
      imagePath: json['imagePath'],
      enabled: json['enabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'type': type,
      'imagePath': imagePath,
      'enabled': enabled,
    };
  }
}