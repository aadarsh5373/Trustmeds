import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class Helpers {
  static void showSuccessSnackbar(String message) {
    Get.showSnackbar(GetSnackBar(
      message: message,
      backgroundColor: AppColors.success,
      duration: const Duration(seconds: 2),
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      snackPosition: SnackPosition.TOP,
      icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
    ));
  }

  static void showErrorSnackbar(String message) {
    Get.showSnackbar(GetSnackBar(
      message: message,
      backgroundColor: AppColors.error,
      duration: const Duration(seconds: 3),
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      snackPosition: SnackPosition.TOP,
      icon: const Icon(Icons.error_rounded, color: Colors.white),
    ));
  }

  static void showInfoSnackbar(String message) {
    Get.showSnackbar(GetSnackBar(
      message: message,
      backgroundColor: AppColors.textDark,
      duration: const Duration(seconds: 2),
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      snackPosition: SnackPosition.TOP,
    ));
  }

  static Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) {
    return Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          title,
          style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
        ),
        content: Text(
          message,
          style: GoogleFonts.nunito(color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              cancelText,
              style: GoogleFonts.nunito(color: AppColors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              confirmText,
              style: GoogleFonts.nunito(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void showLoadingDialog() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoadingDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
