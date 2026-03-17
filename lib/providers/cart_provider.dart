import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  static const _storageKey = 'cart_items_v1';

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalTypesInCart => _items.length;

  int get totalQuantity =>
      _items.fold(0, (previousValue, element) => previousValue + element.quantity);

  double get selectedTotalAmount => _items
      .where((e) => e.selected)
      .fold(0, (p, e) => p + e.totalPrice);

  bool get isAllSelected => _items.isNotEmpty && _items.every((e) => e.selected);

  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) return;
    try {
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      _items.clear();
      for (final item in decoded) {
        final map = item as Map<String, dynamic>;
        final product = Product(
          id: map['product']['id'] as String,
          name: map['product']['name'] as String,
          imageUrl: map['product']['imageUrl'] as String,
          price: (map['product']['price'] as num).toDouble(),
          originalPrice: map['product']['originalPrice'] == null
              ? null
              : (map['product']['originalPrice'] as num).toDouble(),
          tag: map['product']['tag'] as String,
          soldCount: map['product']['soldCount'] as int,
          imageGallery:
              List<String>.from(map['product']['imageGallery'] as List<dynamic>),
          sizes: List<String>.from(map['product']['sizes'] as List<dynamic>),
          colors: List<String>.from(map['product']['colors'] as List<dynamic>),
          description: map['product']['description'] as String,
        );
        _items.add(CartItem(
          product: product,
          size: map['size'] as String,
          color: map['color'] as String,
          quantity: map['quantity'] as int,
          selected: map['selected'] as bool,
        ));
      }
      notifyListeners();
    } catch (_) {
      // ignore corrupt data
    }
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _items
        .map((e) => {
              'product': {
                'id': e.product.id,
                'name': e.product.name,
                'imageUrl': e.product.imageUrl,
                'price': e.product.price,
                'originalPrice': e.product.originalPrice,
                'tag': e.product.tag,
                'soldCount': e.product.soldCount,
                'imageGallery': e.product.imageGallery,
                'sizes': e.product.sizes,
                'colors': e.product.colors,
                'description': e.product.description,
              },
              'size': e.size,
              'color': e.color,
              'quantity': e.quantity,
              'selected': e.selected,
            })
        .toList();
    await prefs.setString(_storageKey, jsonEncode(list));
  }

  void toggleAll(bool value) {
    for (final item in _items) {
      item.selected = value;
    }
    _saveToStorage();
    notifyListeners();
  }

  void toggleItem(CartItem item, bool value) {
    item.selected = value;
    _saveToStorage();
    notifyListeners();
  }

  void addToCart(Product product, String size, String color, int quantity) {
    final existing = _items.where((e) =>
        e.product.id == product.id && e.size == size && e.color == color);
    if (existing.isNotEmpty) {
      existing.first.quantity += quantity;
    } else {
      _items.add(CartItem(
        product: product,
        size: size,
        color: color,
        quantity: quantity,
        selected: true,
      ));
    }
    _saveToStorage();
    notifyListeners();
  }

  void increaseQuantity(CartItem item) {
    item.quantity++;
    _saveToStorage();
    notifyListeners();
  }

  void decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
      _saveToStorage();
      notifyListeners();
    }
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    _saveToStorage();
    notifyListeners();
  }

  void removeItemsByList(List<CartItem> items) {
    _items.removeWhere((element) => items.contains(element));
    _saveToStorage();
    notifyListeners();
  }

  List<CartItem> get selectedItems =>
      _items.where((element) => element.selected).toList(growable: false);
}
