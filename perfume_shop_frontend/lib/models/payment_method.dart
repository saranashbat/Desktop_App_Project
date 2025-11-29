class PaymentMethod {
  String? id;
  String name;       // "Visa", "Mastercard", "Cash on Delivery"
  String type;       // "CARD", "WALLET", "COD"
  String? imagePath; // e.g., "/images/payments/visa.png"
  bool enabled;      // true if available

  PaymentMethod({
    this.id,
    required this.name,
    required this.type,
    this.imagePath,
    required this.enabled,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['_id']?['\$oid'], // if MongoDB ObjectId comes this way
      name: json['name'],
      type: json['type'],
      imagePath: json['imagePath'],
      enabled: json['enabled'] ?? true, // default true if missing
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
