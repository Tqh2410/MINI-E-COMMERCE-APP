import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cart_item.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import 'orders_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late List<CartItem> _selectedItems;
  late double _total;
  final TextEditingController _addressController =
      TextEditingController(text: 'Ngõ 123, Quận 1, TP. HCM');
  String _paymentMethod = 'COD';

  @override
  void initState() {
    super.initState();
    final cart = context.read<CartProvider>();
    _selectedItems = cart.selectedItems;
    _total = cart.selectedTotalAmount;
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const OrdersScreen(),
                ),
              );
            },
            icon: const Icon(Icons.receipt_long),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Địa chỉ nhận hàng',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _addressController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Phương thức thanh toán',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  RadioListTile<String>(
                    value: 'COD',
                    groupValue: _paymentMethod,
                    title: const Text('Thanh toán khi nhận hàng (COD)'),
                    onChanged: (v) => setState(() => _paymentMethod = v!),
                  ),
                  RadioListTile<String>(
                    value: 'Momo',
                    groupValue: _paymentMethod,
                    title: const Text('Momo'),
                    onChanged: (v) => setState(() => _paymentMethod = v!),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sản phẩm',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ..._selectedItems.map(
                    (e) => ListTile(
                      title: Text(e.product.name,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text('${e.size} / ${e.color} x ${e.quantity}'),
                      trailing: Text(_formatPrice(e.totalPrice)),
                    ),
                  ),
                  const Divider(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Tổng: ${_formatPrice(_total)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedItems.isEmpty ? null : _placeOrder,
                  child: const Text('Đặt hàng'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _placeOrder() async {
    final cart = context.read<CartProvider>();
    final orders = context.read<OrderProvider>();

    orders.addOrder(
      items: _selectedItems,
      totalAmount: _total,
      address: _addressController.text,
      paymentMethod: _paymentMethod,
    );

    cart.removeItemsByList(_selectedItems);

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thành công'),
        content: const Text('Đặt hàng thành công!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  String _formatPrice(double price) {
    final s = price.toStringAsFixed(0);
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final indexFromEnd = s.length - i;
      buf.write(s[i]);
      if (indexFromEnd > 1 && indexFromEnd % 3 == 1) {
        buf.write('.');
      }
    }
    return '${buf.toString()}đ';
  }
}
