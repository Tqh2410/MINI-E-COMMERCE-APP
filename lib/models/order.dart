import 'cart_item.dart';

enum OrderStatus { pending, shipping, delivered, canceled }

class Order {
  final String id;
  final DateTime createdAt;
  final List<CartItem> items;
  final double totalAmount;
  final String address;
  final String paymentMethod;
  OrderStatus status;

  Order({
    required this.id,
    required this.createdAt,
    required this.items,
    required this.totalAmount,
    required this.address,
    required this.paymentMethod,
    this.status = OrderStatus.pending,
  });
}
