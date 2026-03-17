import 'package:flutter/material.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'icon': Icons.checkroom, 'label': 'Thời trang'},
      {'icon': Icons.phone_iphone, 'label': 'Điện thoại'},
      {'icon': Icons.spa, 'label': 'Mỹ phẩm'},
      {'icon': Icons.kitchen, 'label': 'Gia dụng'},
      {'icon': Icons.toys, 'label': 'Đồ chơi'},
      {'icon': Icons.computer, 'label': 'Laptop'},
      {'icon': Icons.pets, 'label': 'Thú cưng'},
      {'icon': Icons.sports_esports, 'label': 'Gaming'},
    ];

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: (categories.length / 2).ceil(),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, columnIndex) {
          final startIndex = columnIndex * 2;
          final items = categories.skip(startIndex).take(2).toList();
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: items
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          child: Icon(
                            e['icon'] as IconData,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 70,
                          child: Text(
                            e['label'] as String,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
