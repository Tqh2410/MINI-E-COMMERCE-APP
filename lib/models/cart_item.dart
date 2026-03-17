import 'product.dart';

class CartItem {
  final Product product;
  final String size;
  final String color;
  int quantity;
  bool selected;

  CartItem({
    required this.product,
    required this.size,
    required this.color,
    this.quantity = 1,
    this.selected = true,
  });

  double get totalPrice => product.price * quantity;
}
