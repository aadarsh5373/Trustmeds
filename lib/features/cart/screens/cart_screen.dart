import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/medicine_tile.dart';
import '../../../core/utils/formatters.dart';
import '../controllers/cart_controller.dart';
import '../models/cart_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (Get.key.currentState?.canPop() ?? false) {
              Get.back();
            } else {
              Get.offAllNamed('/home');
            }
          },
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Get.toNamed('/upload-prescription'),
            icon: const Icon(Icons.upload_file_rounded, size: 18),
            label: const Text('Upload Rx'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (cartController.items.isEmpty) {
          return _buildEmptyCart();
        }
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: cartController.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, index) {
                  final item = cartController.items[index];

                  if (item.type == CartItemType.medicine) {
                    return MedicineTile(
                      medicine: item.medicine!,
                      quantity: item.quantity,
                      onIncrement: () =>
                          cartController.incrementQuantity(item.id),
                      onDecrement: () =>
                          cartController.decrementQuantity(item.id),
                      onRemove: () => cartController.removeItem(item.id),
                      onTap: () => Get.toNamed('/medicine-detail',
                          arguments: item.medicine),
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppColors.blushPink.withOpacity(0.4)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.softPink.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.science_rounded,
                                color: AppColors.primary, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.labTest!.name,
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  Formatters.currency(
                                      item.labTest!.discountedPrice),
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Quantity controls
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                    Icons.remove_circle_outline_rounded,
                                    color: AppColors.textLight),
                                onPressed: () =>
                                    cartController.decrementQuantity(item.id),
                              ),
                              Text('${item.quantity}',
                                  style: GoogleFonts.nunito(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                              IconButton(
                                icon: const Icon(
                                    Icons.add_circle_outline_rounded,
                                    color: AppColors.primary),
                                onPressed: () =>
                                    cartController.incrementQuantity(item.id),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            // Price summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Delivery notice
                    if (cartController.subtotal < 499)
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppColors.softPink.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_shipping_rounded,
                                size: 16, color: AppColors.primaryDark),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Add ₹${(499 - cartController.subtotal).toStringAsFixed(0)} more for free delivery',
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    _buildPriceRow(AppStrings.subtotal,
                        Formatters.currency(cartController.subtotal)),
                    const SizedBox(height: 6),
                    _buildPriceRow(
                      AppStrings.deliveryFee,
                      cartController.deliveryFee == 0
                          ? AppStrings.freeDelivery
                          : Formatters.currency(cartController.deliveryFee),
                      valueColor: cartController.deliveryFee == 0
                          ? AppColors.success
                          : null,
                    ),
                    if (cartController.totalSavings > 0) ...[
                      const SizedBox(height: 6),
                      _buildPriceRow(
                        'Total Savings',
                        '-${Formatters.currency(cartController.totalSavings)}',
                        valueColor: AppColors.success,
                      ),
                    ],
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(color: AppColors.divider),
                    ),
                    _buildPriceRow(
                      AppStrings.total,
                      Formatters.currency(cartController.total),
                      isBold: true,
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: AppStrings.proceedToCheckout,
                      onPressed: () => Get.toNamed('/checkout'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.softPink.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_cart_outlined,
                size: 64, color: AppColors.primary),
          ),
          const SizedBox(height: 20),
          Text(
            AppStrings.emptyCart,
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppStrings.emptyCartSub,
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Browse Medicines',
            width: 200,
            onPressed: () => Get.toNamed('/medicines'),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => Get.toNamed('/upload-prescription'),
            icon:
                const Icon(Icons.upload_file_rounded, color: AppColors.primary),
            label: Text(
              'Upload Prescription',
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

  Widget _buildPriceRow(String label, String value,
      {Color? valueColor, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: AppColors.textDark,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.nunito(
            fontSize: isBold ? 18 : 14,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color:
                valueColor ?? (isBold ? AppColors.primary : AppColors.textDark),
          ),
        ),
      ],
    );
  }
}
