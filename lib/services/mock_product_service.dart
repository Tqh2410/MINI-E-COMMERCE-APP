import '../models/product.dart';

class MockProductService {
  static const int pageSize = 10;

  static final List<Product> _allProducts = List.generate(100, (index) {
    final i = index + 1;
    return Product(
      id: 'p$i',
      name: 'Sản phẩm hot số $i cực đẹp thời trang phong cách',
      imageUrl:
          'https://picsum.photos/seed/ecom_$i/400/400',
      price: 150000 + (i * 1000),
      originalPrice: 200000 + (i * 1000),
      tag: i % 3 == 0 ? 'Mall' : (i % 3 == 1 ? 'Yêu thích' : 'Giảm 50%'),
      soldCount: 100 * i,
      imageGallery: List.generate(
          4,
          (j) =>
              'https://picsum.photos/seed/ecom_${i}_$j/600/600'),
      sizes: const ['S', 'M', 'L', 'XL'],
      colors: const ['Đỏ', 'Xanh', 'Vàng', 'Đen'],
      description:
          'Mô tả chi tiết cho sản phẩm số $i. Chất liệu cao cấp, form dáng đẹp, phù hợp nhiều hoàn cảnh. Hàng chuẩn shop, đổi trả trong 7 ngày.',
    );
  });

  Future<List<Product>> fetchProducts({required int page}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final start = (page - 1) * pageSize;
    if (start >= _allProducts.length) return [];
    final end = (start + pageSize).clamp(0, _allProducts.length);
    return _allProducts.sublist(start, end);
  }
}
