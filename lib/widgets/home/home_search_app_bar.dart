import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';

class HomeSearchAppBar extends StatelessWidget {
  const HomeSearchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      expandedHeight: 110,
      backgroundColor: Colors.transparent,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final t = ((constraints.maxHeight - kToolbarHeight) / 40)
              .clamp(0.0, 1.0);
          final bgColor = Color.lerp(
            Colors.transparent,
            Theme.of(context).colorScheme.primary,
            1 - t,
          );
          return Container(
            color: bgColor,
            child: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 0, right: 0, bottom: 8),
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _buildSearchRow(context),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchRow(BuildContext context) {
    final cartTypes = context.watch<CartProvider>().totalTypesInCart;
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, size: 20, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Tìm kiếm sản phẩm',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.of(context).pushNamed('/cart');
                },
              ),
            ),
            if (cartTypes > 0)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$cartTypes',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        )
      ],
    );
  }
}
