import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/utils/formatters.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderNumber = Get.arguments as String? ?? 'MC2024001';

    final steps = [
      {'title': 'Order Placed', 'subtitle': 'Your order has been placed', 'done': true, 'icon': Icons.shopping_bag_rounded},
      {'title': 'Confirmed', 'subtitle': 'Order confirmed by pharmacy', 'done': true, 'icon': Icons.check_circle_rounded},
      {'title': 'Processing', 'subtitle': 'Being packed and prepared', 'done': true, 'icon': Icons.inventory_2_rounded},
      {'title': 'Shipped', 'subtitle': 'On the way to you', 'done': false, 'icon': Icons.local_shipping_rounded},
      {'title': 'Delivered', 'subtitle': 'Package delivered', 'done': false, 'icon': Icons.home_rounded},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Track Order'),
        backgroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order info card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.blushPink.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order #$orderNumber',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Processing',
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Estimated delivery: ${Formatters.deliveryEstimate()}',
                    style: GoogleFonts.nunito(
                        fontSize: 13, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Progress steps
            Text(
              'Order Status',
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(steps.length, (index) {
              final step = steps[index];
              final isDone = step['done'] as bool;
              final isLast = index == steps.length - 1;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: isDone
                              ? AppColors.primaryGradient
                              : null,
                          color: isDone ? null : AppColors.softPink,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          step['icon'] as IconData,
                          color: isDone ? Colors.white : AppColors.textLight,
                          size: 20,
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 40,
                          color: isDone
                              ? AppColors.primary
                              : AppColors.blushPink.withOpacity(0.5),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step['title'] as String,
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isDone
                                  ? AppColors.textDark
                                  : AppColors.textLight,
                            ),
                          ),
                          Text(
                            step['subtitle'] as String,
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                          SizedBox(height: isLast ? 0 : 20),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 32),
            // Support
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.softPink.withOpacity(0.4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.support_agent_rounded,
                      color: AppColors.primary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Need Help?',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          'Contact our support team',
                          style: GoogleFonts.nunito(
                              fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppColors.primary),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Back to Home',
              isOutlined: true,
              onPressed: () => Get.offAllNamed('/home'),
            ),
          ],
        ),
      ),
    );
  }
}
