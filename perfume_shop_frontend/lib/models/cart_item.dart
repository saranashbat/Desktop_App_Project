// cart_item.dart

class CartItem {
  String perfumeId;
  String perfumeName;
  double unitPrice;
  int quantity;

  CartItem({
    required this.perfumeId,
    required this.perfumeName,
    required this.unitPrice,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      perfumeId: json['perfumeId'],
      perfumeName: json['perfumeName'],
      unitPrice: (json['unitPrice'] as num).toDouble(),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'perfumeId': perfumeId,
      'perfumeName': perfumeName,
      'unitPrice': unitPrice,
      'quantity': quantity,
    };
  }
}
