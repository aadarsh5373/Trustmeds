import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Display — App name, hero text
  static TextStyle display = GoogleFonts.nunito(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.textDark,
  );

  // Heading — Section titles
  static TextStyle heading = GoogleFonts.nunito(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  // Title Large
  static TextStyle titleLarge = GoogleFonts.nunito(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  // Subhead — Card titles
  static TextStyle subhead = GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  // Body — Descriptions
  static TextStyle body = GoogleFonts.nunito(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
  );

  // Body Small
  static TextStyle bodySmall = GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  // Caption — Timestamps, hints
  static TextStyle caption = GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: AppColors.textLight,
  );

  // Button text
  static TextStyle button = GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  // Price
  static TextStyle price = GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );

  // Price strikethrough
  static TextStyle priceOld = GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
    decoration: TextDecoration.lineThrough,
  );

  // Badge / Tag
  static TextStyle badge = GoogleFonts.nunito(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDark,
  );
}
