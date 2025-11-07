// lib/screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/favorite_provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import '../core/constants/app_typography.dart';
import '../core/widgets/app_button.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  int _selectedImageIndex = 0;
  String? _selectedSize;
  String? _selectedColor;

  final List<String> _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final List<Color> _colors = [
    AppColors.primary,
    AppColors.accent,
    const Color(0xFFEF4444),
    const Color(0xFF3B82F6),
    const Color(0xFF10B981),
  ];

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = context.watch<FavoriteProvider>();
    final isFavorite = favoriteProvider.isFavorite(widget.product.id);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image gallery with carousel
                Stack(
                  children: [
                    SizedBox(
                      height: 400,
                      child: widget.product.images.isNotEmpty
                          ? PageView.builder(
                              itemCount: widget.product.images.length,
                              onPageChanged: (index) {
                                setState(() {
                                  _selectedImageIndex = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return CachedNetworkImage(
                                  imageUrl: widget.product.images[index],
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
                                      size: 64,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: AppColors.scaffoldBackground,
                              child: Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 80,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                    ),
                    // Back button
                    Positioned(
                      top: MediaQuery.of(context).padding.top + AppSpacing.sm,
                      left: AppSpacing.md,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: AppColors.primary,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ),
                    // Favorite button
                    Positioned(
                      top: MediaQuery.of(context).padding.top + AppSpacing.sm,
                      right: AppSpacing.md,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_outline,
                            color: isFavorite ? AppColors.error : AppColors.primary,
                          ),
                          onPressed: () {
                            if (isFavorite) {
                              favoriteProvider.removeFavorite(widget.product.id);
                            } else {
                              favoriteProvider.addFavorite(widget.product.id);
                            }
                          },
                        ),
                      ),
                    ),
                    // Image indicators
                    if (widget.product.images.length > 1)
                      Positioned(
                        bottom: AppSpacing.md,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.product.images.length,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _selectedImageIndex == index ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _selectedImageIndex == index
                                    ? AppColors.accent
                                    : AppColors.background.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                // Product details
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppSpacing.radiusXl),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product name and price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.product.name,
                                style: AppTypography.h3.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Text(
                              '\$${widget.product.price.toStringAsFixed(2)}',
                              style: AppTypography.h2.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.sm),

                        // Rating and reviews
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: AppColors.accent,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${widget.product.rating}',
                                    style: AppTypography.bodySmall.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              '(${widget.product.reviews} reviews)',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // Vendor
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.primary,
                              child: Text(
                                widget.product.vendorName[0].toUpperCase(),
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.background,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Sold by ',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              widget.product.vendorName,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Description
                        Text(
                          'Description',
                          style: AppTypography.h5.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          widget.product.description,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Size selector (if applicable)
                        if (widget.product.category == 'Fashion' ||
                            widget.product.category == 'Clothing') ...[
                          Text(
                            'Size',
                            style: AppTypography.h5.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: _sizes.map((size) {
                              final isSelected = _selectedSize == size;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedSize = size;
                                  });
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.background,
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.accent
                                          : AppColors.border,
                                      width: isSelected ? 2 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      AppSpacing.radiusMd,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      size,
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: isSelected
                                            ? AppColors.background
                                            : AppColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                        ],

                        // Color selector
                        Text(
                          'Color',
                          style: AppTypography.h5.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: _colors.map((color) {
                            final isSelected = _selectedColor == color.toString();
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedColor = color.toString();
                                });
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: color,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.accent
                                        : AppColors.border,
                                    width: isSelected ? 3 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusMd,
                                  ),
                                ),
                                child: isSelected
                                    ? Icon(
                                        Icons.check,
                                        color: color == AppColors.primary ||
                                                color == const Color(0xFF3B82F6)
                                            ? AppColors.background
                                            : AppColors.primary,
                                      )
                                    : null,
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Quantity selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Quantity',
                              style: AppTypography.h5.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.border),
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusMd,
                                ),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      if (_quantity > 1) {
                                        setState(() => _quantity--);
                                      }
                                    },
                                  ),
                                  Container(
                                    width: 50,
                                    alignment: Alignment.center,
                                    child: Text(
                                      _quantity.toString(),
                                      style: AppTypography.h5.copyWith(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() => _quantity++);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 100), // Space for bottom buttons
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom action buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.background,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Consumer<CartProvider>(
                builder: (context, cartProvider, _) {
                  return Row(
                    children: [
                      // Message Vendor button
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border, width: 2),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.chat_outlined,
                            color: AppColors.primary,
                          ),
                          onPressed: () {
                            // Navigate to chat with vendor
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      // Add to Cart button
                      Expanded(
                        child: AppButton(
                          text: 'Add to Cart',
                          icon: Icon(
                            Icons.shopping_bag_outlined,
                            color: AppColors.background,
                          ),
                          onPressed: () {
                            if (widget.product.images.isNotEmpty) {
                              cartProvider.addItem(
                                productId: widget.product.id,
                                name: widget.product.name,
                                price: widget.product.price,
                                image: widget.product.images.first,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Added ${widget.product.name} to cart',
                                  ),
                                  backgroundColor: AppColors.success,
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Cannot add product without an image',
                                  ),
                                  backgroundColor: AppColors.error,
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
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
