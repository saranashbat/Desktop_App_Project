class CartItem {
  String perfumeName; // replace perfumeId
  double unitPrice;
  int quantity;

  CartItem({
    required this.perfumeName,
    required this.unitPrice,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        perfumeName: json['perfumeName'],
        unitPrice: (json['unitPrice'] as num).toDouble(),
        quantity: json['quantity'],
      );

  Map<String, dynamic> toJson() => {
        'perfumeName': perfumeName,
        'unitPrice': unitPrice,
        'quantity': quantity,
      };
}
