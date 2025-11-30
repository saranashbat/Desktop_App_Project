// lib/models/payment_method.dart
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
    // ✅ FIX: Handle both 'id' and '_id' formats
    String? parsedId;
    
    if (json['id'] != null) {
      // Backend sends "id" directly as string
      parsedId = json['id'] as String;
    } else if (json['_id'] != null) {
      // MongoDB format with $oid
      if (json['_id'] is Map) {
        parsedId = json['_id']['\$oid'] as String?;
      } else {
        parsedId = json['_id'] as String;
      }
    }

    return PaymentMethod(
      id: parsedId,
      name: json['name'] ?? 'Unknown',
      type: json['type'] ?? 'UNKNOWN',
      imagePath: json['imagePath'],
      enabled: json['enabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'imagePath': imagePath,
      'enabled': enabled,
    };
  }
}