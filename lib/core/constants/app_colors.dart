import 'package:flutter/material.dart';

class AppColors {
  // Modern Trust & Vitality Palette
  static const Color primary = Color(0xFF1E293B);      // Deep Navy
  static const Color primaryLight = Color(0xFF334155); // Slate
  static const Color primaryDark = Color(0xFF0F172A);  // Slate 900
  static const Color primarySurface = Color(0xFFF1F5F9); // Slate 100

  static const Color secondary = Color(0xFF3B82F6);    // Electric Blue
  static const Color secondaryLight = Color(0xFF60A5FA); // Soft Blue
  
  static const Color accentTeal = Color(0xFF10B981);   // Emerald Vitality
  static const Color accentRose = Color(0xFFFB7185);   // SOS / Emergency Rose
  
  // Text
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF475569);
  static const Color textLight = Color(0xFF94A3B8);

  // Semantic
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Neutral
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8FAFC); // Clean Ice Slate
  static const Color surface = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE2E8F0);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF1E293B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF8FAFC), Color(0xFFFFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF1F5F9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [Color(0xFFF1F5F9), Color(0xFFFFFFFF), Color(0xFFF1F5F9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Backward compatibility aliases for old "Botanical" names
  static const Color softPink = primarySurface;
  static const Color blushPink = divider;
  static const Color accentCoral = secondary;
  static const Color accent = secondary;
}
