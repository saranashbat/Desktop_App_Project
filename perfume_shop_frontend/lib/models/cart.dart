// cart.dart
import 'cart_item.dart'; // you will also need this

class Cart {
  String? id;
  String userId;
  List<CartItem> items;
  double subtotal;
  double deliveryFee;
  double total;

  Cart({
    this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
  return Cart(
    id: json['_id'] != null ? json['_id']['\$oid'] : null,
    userId: json['userId'],
    items: (json['items'] as List)
        .map((e) => CartItem.fromJson(e))
        .toList(),
    subtotal: (json['subtotal'] as num).toDouble(),
    deliveryFee: (json['deliveryFee'] as num).toDouble(),
    total: (json['total'] as num).toDouble(),
  );
}

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
    };
  }
}
