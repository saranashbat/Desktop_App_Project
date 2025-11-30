// order.dart
import 'cart_item.dart';
import 'payment_method.dart';
import 'order_status.dart';

class Order {
  String? id;
  String userId;
  List<CartItem> items;
  double subtotal;
  double deliveryFee;
  double total;
  String deliveryMethod;
  String? deliveryAddress;
  String pickupLocation;
  String paymentStatus;
  PaymentMethod paymentMethod;
  OrderStatus orderStatus;
  DateTime createdAt;

  Order({
    this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.deliveryMethod,
    this.deliveryAddress,
    this.pickupLocation = "123 Corniche St., Elite Notes Store, Doha, Qatar",
    required this.paymentStatus,
    required this.paymentMethod,
    required this.orderStatus,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'] != null ? json['_id']['\$oid'] as String? : null, // ✅ FIXED
      userId: json['userId'],
      items: (json['items'] as List)
          .map((e) => CartItem.fromJson(e))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      deliveryMethod: json['deliveryMethod'],
      deliveryAddress: json['deliveryAddress'],
      pickupLocation: json['pickupLocation'] ?? "123 Corniche St., Elite Notes Store, Doha, Qatar",
      paymentStatus: json['paymentStatus'],
      paymentMethod: PaymentMethod.fromJson(json['paymentMethod']),
      orderStatus: orderStatusFromString(json['orderStatus']),
      createdAt: DateTime.parse(json['createdAt']),
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
      'deliveryMethod': deliveryMethod,
      'deliveryAddress': deliveryAddress,
      'pickupLocation': pickupLocation,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod.toJson(),
      'orderStatus': orderStatusToString(orderStatus),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}