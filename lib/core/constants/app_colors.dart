import 'package:flutter/material.dart';

/// App color constants based on Figma design
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF000000); // Black
  static const Color accent = Color(0xFFFCD535); // Yellow

  // Background Colors
  static const Color background = Color(0xFFFFFFFF); // White
  static const Color scaffoldBackground = Color(0xFFFAFAFA); // Very light gray
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color textHint = Color(0xFFBDBDBD);

  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Product Colors (for filter)
  static const List<Color> productColors = [
    Color(0xFF000000), // Black
    Color(0xFFFCD535), // Yellow
    Color(0xFFEF4444), // Red
    Color(0xFF3B82F6), // Blue
    Color(0xFF10B981), // Green
    Color(0xFFFFFFFF), // White
    Color(0xFF6B7280), // Gray
    Color(0xFF8B5CF6), // Purple
  ];

  // Notification dot
  static const Color notificationDot = Color(0xFF00BCD4); // Cyan

  // Rating star
  static const Color ratingStar = Color(0xFFFCD535); // Yellow
  static const Color ratingStarInactive = Color(0xFFE0E0E0);

  // Promo/Sale
  static const Color sale = Color(0xFFEF4444);

  AppColors._(); // Private constructor to prevent instantiation
}
