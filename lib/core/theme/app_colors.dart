import 'package:flutter/material.dart';

/// Design tokens for colors used throughout the app
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2563EB); // Blue-600
  static const Color primaryLight = Color(0xFF3B82F6); // Blue-500
  static const Color primaryDark = Color(0xFF1D4ED8); // Blue-700
  static const Color primaryContainer = Color(0xFFDBEAFE); // Blue-100
  
  // Secondary Colors
  static const Color secondary = Color(0xFF64748B); // Slate-500
  static const Color secondaryLight = Color(0xFF94A3B8); // Slate-400
  static const Color secondaryDark = Color(0xFF475569); // Slate-600
  static const Color secondaryContainer = Color(0xFFF1F5F9); // Slate-100
  
  // Success Colors
  static const Color success = Color(0xFF059669); // Emerald-600
  static const Color successLight = Color(0xFF10B981); // Emerald-500
  static const Color successDark = Color(0xFF047857); // Emerald-700
  static const Color successContainer = Color(0xFFD1FAE5); // Emerald-100
  
  // Warning Colors
  static const Color warning = Color(0xFFD97706); // Amber-600
  static const Color warningLight = Color(0xFFF59E0B); // Amber-500
  static const Color warningDark = Color(0xFFB45309); // Amber-700
  static const Color warningContainer = Color(0xFFFEF3C7); // Amber-100
  
  // Error Colors
  static const Color error = Color(0xFFDC2626); // Red-600
  static const Color errorLight = Color(0xFFEF4444); // Red-500
  static const Color errorDark = Color(0xFFB91C1C); // Red-700
  static const Color errorContainer = Color(0xFFFEE2E2); // Red-100
  
  // Neutral Colors (Light Theme)
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFFAFAFA);
  static const Color lightSurfaceVariant = Color(0xFFF5F5F5);
  static const Color lightOutline = Color(0xFFE5E5E5);
  static const Color lightOnBackground = Color(0xFF0F172A);
  static const Color lightOnSurface = Color(0xFF334155);
  static const Color lightOnSurfaceVariant = Color(0xFF64748B);
  
  // Neutral Colors (Dark Theme)
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);
  static const Color darkOutline = Color(0xFF475569);
  static const Color darkOnBackground = Color(0xFFF8FAFC);
  static const Color darkOnSurface = Color(0xFFE2E8F0);
  static const Color darkOnSurfaceVariant = Color(0xFF94A3B8);
  
  // Chart Colors
  static const Color chartGreen = Color(0xFF10B981); // Bullish candles
  static const Color chartRed = Color(0xFFEF4444); // Bearish candles
  static const Color chartVolume = Color(0xFF6B7280);
  static const Color chartGrid = Color(0xFFE5E7EB);
  static const Color chartGridDark = Color(0xFF374151);
  
  // Trade Status Colors
  static const Color profitGreen = Color(0xFF059669);
  static const Color lossRed = Color(0xFFDC2626);
  static const Color breakeven = Color(0xFF6B7280);
  
  // Additional colors
  static const Color info = Color(0xFF2196F3);
  static const Color neutral = Color(0xFF9E9E9E);

  // Utility Colors
  static const Color transparent = Colors.transparent;
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [success, successLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient errorGradient = LinearGradient(
    colors: [error, errorLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Shadow Colors
  static const Color lightShadow = Color(0x1A000000);
  static const Color darkShadow = Color(0x40000000);
}

