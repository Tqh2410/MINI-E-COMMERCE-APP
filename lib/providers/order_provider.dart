import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/order.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  void addOrder({
    required List<CartItem> items,
    required double totalAmount,
    required String address,
    required String paymentMethod,
  }) {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      items: items,
      totalAmount: totalAmount,
      address: address,
      paymentMethod: paymentMethod,
    );
    _orders.insert(0, order);
    notifyListeners();
  }
}
