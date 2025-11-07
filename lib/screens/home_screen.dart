// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../providers/favorite_provider.dart';
import '../models/product_model.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import '../core/constants/app_typography.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String? _selectedCategory;
  int _currentBannerIndex = 0;
  int _selectedBottomNavIndex = 0;

  final List<Map<String, String>> _banners = [
    {
      'title': 'Summer Sale',
      'subtitle': 'Up to 50% Off',
      'image': 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&q=80',
    },
    {
      'title': 'New Arrivals',
      'subtitle': 'Fresh Collection',
      'image': 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800&q=80',
    },
    {
      'title': 'Free Shipping',
      'subtitle': 'On orders over \$50',
      'image': 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=800&q=80',
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Electronics', 'icon': Icons.devices},
    {'name': 'Fashion', 'icon': Icons.checkroom},
    {'name': 'Home', 'icon': Icons.home},
    {'name': 'Beauty', 'icon': Icons.face},
    {'name': 'Sports', 'icon': Icons.sports_basketball},
    {'name': 'Books', 'icon': Icons.book},
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final productProvider = context.watch<ProductProvider>();
    final userName = authProvider.userData?['fullName']?.split(' ')[0] ?? 'User';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with greeting and icons
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, $userName 👋',
                          style: AppTypography.h3.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'What are you looking for today?',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.notifications_outlined),
                            onPressed: () {
                              // Navigate to notifications
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.account_circle_outlined),
                            onPressed: () =>
                                Navigator.of(context).pushNamed('/profile'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search products, brands...',
                      hintStyle: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.textSecondary,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                          : Icon(
                              Icons.tune,
                              color: AppColors.textSecondary,
                            ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Promotional Banner Slider
              SizedBox(
                height: 180,
                child: PageView.builder(
                  itemCount: _banners.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentBannerIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final banner = _banners[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                        color: AppColors.primary,
                      ),
                      child: Stack(
                        children: [
                          // Background image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                            child: CachedNetworkImage(
                              imageUrl: banner['image']!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: AppColors.scaffoldBackground,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: AppColors.scaffoldBackground,
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                          // Gradient overlay
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  AppColors.primary.withValues(alpha: 0.8),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          // Text content
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  banner['title']!,
                                  style: AppTypography.h2.copyWith(
                                    color: AppColors.background,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  banner['subtitle']!,
                                  style: AppTypography.h4.copyWith(
                                    color: AppColors.accent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Banner indicators
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _banners.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentBannerIndex == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentBannerIndex == index
                          ? AppColors.accent
                          : AppColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Categories Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories',
                      style: AppTypography.h4.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See All',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Categories Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category['name'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = isSelected
                              ? null
                              : category['name'] as String;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accent
                                : AppColors.border,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              category['icon'] as IconData,
                              size: 32,
                              color: isSelected
                                  ? AppColors.accent
                                  : AppColors.textPrimary,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              category['name'] as String,
                              style: AppTypography.bodySmall.copyWith(
                                color: isSelected
                                    ? AppColors.background
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Products Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCategory ?? 'Featured Products',
                      style: AppTypography.h4.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See All',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Products Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: _buildProductGrid(
                  productProvider,
                  _searchController.text,
                  _selectedCategory,
                ),
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.background,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: AppColors.textSecondary,
          currentIndex: _selectedBottomNavIndex,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: AppTypography.captionBold,
          unselectedLabelStyle: AppTypography.caption,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              activeIcon: Icon(Icons.shopping_bag),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          onTap: (index) {
            setState(() {
              _selectedBottomNavIndex = index;
            });
            switch (index) {
              case 0:
                break;
              case 1:
                // Navigate to favorites
                break;
              case 2:
                Navigator.of(context).pushNamed('/cart');
                break;
              case 3:
                Navigator.of(context).pushNamed('/profile');
                break;
            }
          },
        ),
      ),
    );
  }

  Widget _buildProductGrid(
    ProductProvider productProvider,
    String query,
    String? category,
  ) {
    List<Product> products;

    if (query.isNotEmpty) {
      products = productProvider.searchProducts(query);
    } else if (category != null) {
      products = productProvider.getByCategory(category);
    } else {
      products = productProvider.allProducts;
    }

    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'No products found',
                style: AppTypography.h4.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(context, product);
      },
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    final favoriteProvider = context.watch<FavoriteProvider>();
    final isFavorite = favoriteProvider.isFavorite(product.id);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with favorite button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSpacing.radiusLg),
                  ),
                  child: product.images.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: product.images.first,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.scaffoldBackground,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.scaffoldBackground,
                            child: Icon(
                              Icons.image_not_supported,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : Container(
                          height: 140,
                          color: AppColors.scaffoldBackground,
                          child: Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: AppColors.textSecondary,
                          ),
                        ),
                ),
                // Favorite button
                Positioned(
                  top: AppSpacing.sm,
                  right: AppSpacing.sm,
                  child: GestureDetector(
                    onTap: () {
                      if (isFavorite) {
                        favoriteProvider.removeFavorite(product.id);
                      } else {
                        favoriteProvider.addFavorite(product.id);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_outline,
                        color: isFavorite ? AppColors.error : AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Product details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${product.rating}',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: AppTypography.price.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
