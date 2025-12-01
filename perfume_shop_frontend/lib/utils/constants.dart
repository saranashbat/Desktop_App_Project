// lib/utils/constants.dart
import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class AppColors {
  // ✅ Dynamic colors based on theme
  static Color get primary => ThemeConfig.isDarkMode 
      ? const Color(0xFF9C6FFF)  // Dark mode purple
      : const Color(0xFF6B4CE6); // Light mode purple
  
  static Color get primaryDark => ThemeConfig.isDarkMode
      ? const Color(0xFF7C4FDF)
      : const Color(0xFF5639CC);
  
  static Color get accent => ThemeConfig.isDarkMode
      ? const Color(0xFFFF8AB5)
      : const Color(0xFFFF6B9D);
  
  static Color get background => ThemeConfig.isDarkMode
      ? const Color(0xFF121212)  // Dark background
      : const Color(0xFFF8F9FA); // Light background
  
  static Color get cardBackground => ThemeConfig.isDarkMode
      ? const Color(0xFF1E1E1E)  // Dark cards
      : Colors.white;            // Light cards
  
  static Color get textPrimary => ThemeConfig.isDarkMode
      ? Colors.white
      : const Color(0xFF1A1A1A);
  
  static Color get textSecondary => ThemeConfig.isDarkMode
      ? const Color(0xFFB0B0B0)
      : const Color(0xFF757575);
  
  static Color get divider => ThemeConfig.isDarkMode
      ? const Color(0xFF2A2A2A)
      : const Color(0xFFE0E0E0);
  
  // Universal colors (same in both themes)
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFF9800);
  static const error = Color(0xFFF44336);
  static const bestSellerOrange = Color(0xFFFF9800);
}

class AppTextStyles {
  // ✅ Dynamic text styles
  static TextStyle get h1 => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get h2 => TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get h3 => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get body => TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodySecondary => TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static TextStyle get caption => TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle get price => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

class AppBorderRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
}

// Hardcoded best-selling perfume names
const List<String> bestSellingNames = [
  'Lost Cherry',
  'Capri in a Bottle Lemon Sugar 14'
];

// Delivery fee constant
const double deliveryFee = 15.0;