import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cart_item.dart';
import '../../providers/cart_provider.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Text('Giỏ hàng trống'),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return _CartItemTile(item: item);
                  },
                ),
              ),
              _CartBottomBar(cart: cart),
            ],
          );
        },
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    return Dismissible(
      key: ValueKey('${item.product.id}_${item.size}_${item.color}'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Xoá sản phẩm'),
                content:
                    const Text('Bạn có chắc muốn xoá sản phẩm này khỏi giỏ?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text('Huỷ'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text('Xoá'),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) => cart.removeItem(item),
      child: ListTile(
        leading: SizedBox(
          width: 60,
          height: 60,
          child: Image.network(
            item.product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          item.product.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phân loại: ${item.size} / ${item.color}'),
            const SizedBox(height: 4),
            Text(
              _formatPrice(item.product.price),
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: item.selected,
              onChanged: (v) =>
                  context.read<CartProvider>().toggleItem(item, v ?? false),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () async {
                    if (item.quantity == 1) {
                      final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Xoá sản phẩm'),
                              content: const Text(
                                  'Số lượng về 0. Bạn có muốn xoá sản phẩm này?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(ctx).pop(false),
                                  child: const Text('Huỷ'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(ctx).pop(true),
                                  child: const Text('Xoá'),
                                ),
                              ],
                            ),
                          ) ??
                          false;
                      if (confirm) {
                        cart.removeItem(item);
                      }
                    } else {
                      cart.decreaseQuantity(item);
                    }
                  },
                  icon: const Icon(Icons.remove_circle_outline, size: 18),
                ),
                Text('${item.quantity}'),
                IconButton(
                  onPressed: () => cart.increaseQuantity(item),
                  icon: const Icon(Icons.add_circle_outline, size: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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

class _CartBottomBar extends StatelessWidget {
  const _CartBottomBar({required this.cart});

  final CartProvider cart;

  @override
  Widget build(BuildContext context) {
    final total = cart.selectedTotalAmount;
    final isAllSelected = cart.isAllSelected;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Checkbox(
              value: isAllSelected,
              onChanged: (v) =>
                  cart.toggleAll(v ?? false),
            ),
            const Text('Chọn tất cả'),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Tổng thanh toán'),
                Text(
                  _formatPrice(total),
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: total <= 0
                  ? null
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CheckoutScreen(),
                        ),
                      );
                    },
              child: const Text('Thanh toán'),
            ),
          ],
        ),
      ),
    );
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
