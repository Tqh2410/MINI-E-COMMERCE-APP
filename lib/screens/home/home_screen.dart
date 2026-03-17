import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../services/mock_product_service.dart';
import '../../widgets/home/home_banner_carousel.dart';
import '../../widgets/home/home_categories.dart';
import '../../widgets/home/home_search_app_bar.dart';
import '../../widgets/home/product_card.dart';
import '../product_detail/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MockProductService _service = MockProductService();
  final ScrollController _scrollController = ScrollController();

  final List<Product> _products = [];
  int _page = 1;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadFirstPage();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadFirstPage() async {
    setState(() {
      _isLoading = true;
      _page = 1;
      _hasMore = true;
    });
    final data = await _service.fetchProducts(page: _page);
    setState(() {
      _products
        ..clear()
        ..addAll(data);
      _isLoading = false;
      _hasMore = data.isNotEmpty;
    });
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() {
      _isLoadingMore = true;
    });
    final nextPage = _page + 1;
    final data = await _service.fetchProducts(page: nextPage);
    setState(() {
      _page = nextPage;
      _products.addAll(data);
      _isLoadingMore = false;
      if (data.isEmpty) {
        _hasMore = false;
      }
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients || !_hasMore) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (current > maxScroll - 300) {
      _loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: _loadFirstPage,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            const HomeSearchAppBar(),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 8),
                  HomeBannerCarousel(),
                  SizedBox(height: 8),
                  HomeCategories(),
                  SizedBox(height: 8),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Text(
                  'Gợi ý hôm nay',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            if (_isLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    childAspectRatio: 0.65,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= _products.length) {
                        return const SizedBox.shrink();
                      }
                      final product = _products[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(
                                product: product,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    childCount: _products.length,
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: _isLoadingMore
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox(height: 12),
            ),
          ],
        ),
      ),
    );
  }
}
