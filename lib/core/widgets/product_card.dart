import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../../features/medicines/models/medicine_model.dart';

class ProductCard extends StatelessWidget {
  final MedicineModel medicine;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.medicine,
    this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.divider.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image area
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface.withOpacity(0.5),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.medication_rounded,
                          color: AppColors.secondary,
                          size: 40,
                        ),
                      ),
                    ),
                    if (medicine.discount > 0)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${medicine.discount}% OFF',
                            style: AppTextStyles.badge,
                          ),
                        ),
                      ),
                    if (medicine.requiresPrescription)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.description_rounded,
                            color: AppColors.warning,
                            size: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Details
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicine.name,
                        style: AppTextStyles.subhead,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        medicine.brand,
                        style: AppTextStyles.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            '₹${medicine.sellingPrice.toStringAsFixed(0)}',
                            style: AppTextStyles.priceSmall,
                          ),
                          if (medicine.discount > 0) ...[
                            const SizedBox(width: 4),
                            Text(
                              '₹${medicine.mrp.toStringAsFixed(0)}',
                              style: AppTextStyles.priceOld,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: onAddToCart,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.secondary.withOpacity(0.2),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'ADD',
                              style: AppTextStyles.button.copyWith(
                                color: AppColors.secondary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
