import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/order.dart';
import '../../providers/order_provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đơn mua'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Chờ xác nhận'),
              Tab(text: 'Đang giao'),
              Tab(text: 'Đã giao'),
              Tab(text: 'Đã huỷ'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _OrdersTab(status: OrderStatus.pending),
            _OrdersTab(status: OrderStatus.shipping),
            _OrdersTab(status: OrderStatus.delivered),
            _OrdersTab(status: OrderStatus.canceled),
          ],
        ),
      ),
    );
  }
}

class _OrdersTab extends StatelessWidget {
  const _OrdersTab({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, provider, _) {
        final orders = provider.orders
            .where((o) => o.status == status)
            .toList(growable: false);
        if (orders.isEmpty) {
          return const Center(
            child: Text('Chưa có đơn hàng'),
          );
        }
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text('Đơn #${order.id}'),
                subtitle: Text(
                  '${order.items.length} sản phẩm\nTổng: ${_formatPrice(order.totalAmount)}',
                ),
                isThreeLine: true,
                trailing: Text(
                  _statusText(order.status),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _statusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Chờ xác nhận';
      case OrderStatus.shipping:
        return 'Đang giao';
      case OrderStatus.delivered:
        return 'Đã giao';
      case OrderStatus.canceled:
        return 'Đã huỷ';
    }
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
