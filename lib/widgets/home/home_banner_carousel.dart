import 'package:flutter/material.dart';

class HomeBannerCarousel extends StatefulWidget {
  const HomeBannerCarousel({super.key});

  @override
  State<HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends State<HomeBannerCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  int _current = 0;

  final List<Color> _colors = const [
    Colors.orange,
    Colors.pink,
    Colors.blue,
    Colors.green,
  ];

  @override
  void initState() {
    super.initState();
    // Auto play nhẹ nhàng giống slider trên các sàn TMĐT
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoPlay();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    // Dùng Future.loop đơn giản thay vì Timer để tránh leak khi dispose
    Future<void>.delayed(const Duration(seconds: 4)).then((_) {
      if (!mounted || !_pageController.hasClients) return;
      final next = (_current + 1) % _colors.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
      _startAutoPlay();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _colors.length,
            onPageChanged: (index) {
              setState(() => _current = index);
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.hasClients &&
                      _pageController.position.haveDimensions) {
                    final page = _pageController.page ?? _current.toDouble();
                    final diff = (page - index).abs();
                    value = (1 - diff * 0.2).clamp(0.85, 1.0);
                  }
                  final scale = Curves.easeOut.transform(value);
                  return Center(
                    child: Transform.scale(
                      scale: scale,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        _colors[index],
                        _colors[index].withValues(alpha: 0.7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Siêu sale giảm đến 50%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _colors.length,
                (index) {
                  final isActive = index == _current;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    width: isActive ? 12 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: isActive
                          ? Colors.orange
                          : Colors.grey.shade400,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
