class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final String tag;
  final int soldCount;
  final List<String> imageGallery;
  final List<String> sizes;
  final List<String> colors;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    required this.tag,
    required this.soldCount,
    required this.imageGallery,
    required this.sizes,
    required this.colors,
    required this.description,
  });
}
