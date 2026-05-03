import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Use Inter for professional UI, Nunito for friendly display
  
  // Display — App name, hero text
  static TextStyle display = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.textDark,
    letterSpacing: -0.5,
  );

  // Heading — Section titles
  static TextStyle heading = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    letterSpacing: -0.2,
  );

  // Title Large
  static TextStyle titleLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  // Subhead — Card titles
  static TextStyle subhead = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  // Body — Descriptions
  static TextStyle body = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
    height: 1.4,
  );

  // Body Small
  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  // Caption — Timestamps, hints
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textLight,
  );

  // Button text
  static TextStyle button = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  // Price
  static TextStyle price = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: AppColors.secondary,
  );

  // Price Small
  static TextStyle priceSmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    color: AppColors.secondary,
  );

  // Price strikethrough
  static TextStyle priceOld = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
    decoration: TextDecoration.lineThrough,
  );

  // Badge / Tag
  static TextStyle badge = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );
}
