// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item_model.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import '../core/constants/app_typography.dart';
import '../core/widgets/app_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Shopping Cart',
          style: AppTypography.h4.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, _) {
              if (cartProvider.items.isEmpty) return const SizedBox.shrink();
              return TextButton.icon(
                icon: Icon(
                  Icons.delete_sweep,
                  color: AppColors.error,
                  size: 20,
                ),
                label: Text(
                  'Clear',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Clear Cart'),
                      content: const Text(
                        'Are you sure you want to remove all items from your cart?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            cartProvider.clear();
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Clear',
                            style: TextStyle(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          if (cartProvider.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.border,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Your cart is empty',
                    style: AppTypography.h3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Add items to get started',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    text: 'Continue Shopping',
                    onPressed: () => Navigator.of(context).pop(),
                    width: 200,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Cart items count
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                color: AppColors.background,
                child: Row(
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '${cartProvider.itemCount} ${cartProvider.itemCount == 1 ? 'Item' : 'Items'}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Cart items list
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.items.length,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemBuilder: (context, index) {
                    final item = cartProvider.items[index];
                    return _buildCartItem(context, item, cartProvider);
                  },
                ),
              ),

              // Cart summary
              _buildCartSummary(context, cartProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    CartItem item,
    CartProvider cartProvider,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Product image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(AppSpacing.radiusLg),
              ),
              child: CachedNetworkImage(
                imageUrl: item.image,
                width: 100,
                height: 120,
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
              ),
            ),

            // Product details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: AppTypography.h5.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        // Quantity controls
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMd,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                iconSize: 18,
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  if (item.quantity > 1) {
                                    cartProvider.updateQuantity(
                                      item.productId,
                                      item.quantity - 1,
                                    );
                                  }
                                },
                                icon: Icon(
                                  Icons.remove,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Container(
                                width: 32,
                                alignment: Alignment.center,
                                child: Text(
                                  item.quantity.toString(),
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              IconButton(
                                iconSize: 18,
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  cartProvider.updateQuantity(
                                    item.productId,
                                    item.quantity + 1,
                                  );
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Delete button
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                            size: 22,
                          ),
                          onPressed: () {
                            cartProvider.removeItem(item.productId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${item.name} removed from cart'),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ],
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

  Widget _buildCartSummary(BuildContext context, CartProvider cartProvider) {
    const double shippingFee = 0.0;
    final double tax = cartProvider.totalPrice * 0.1; // 10% tax
    final double total = cartProvider.totalPrice + shippingFee + tax;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Promo code section
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.local_offer,
                    color: AppColors.accent,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Have a promo code?',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Show promo code dialog
                    },
                    child: Text(
                      'Apply',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Price breakdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal:',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '\$${cartProvider.totalPrice.toStringAsFixed(2)}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shipping:',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  shippingFee == 0 ? 'Free' : '\$${shippingFee.toStringAsFixed(2)}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: shippingFee == 0 ? AppColors.success : AppColors.textPrimary,
                    fontWeight: shippingFee == 0 ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tax (10%):',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '\$${tax.toStringAsFixed(2)}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),
            Divider(color: AppColors.border, thickness: 1),
            const SizedBox(height: AppSpacing.md),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: AppTypography.h4.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: AppTypography.h3.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Checkout button
            AppButton(
              text: 'Proceed to Checkout',
              width: double.infinity,
              icon: Icon(
                Icons.arrow_forward,
                color: AppColors.background,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/checkout');
              },
            ),
          ],
        ),
      ),
    );
  }
}
