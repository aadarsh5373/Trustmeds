import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../models/lab_test_model.dart';
import '../../../core/widgets/custom_button.dart';

class TestDetailScreen extends StatelessWidget {
  const TestDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final test = Get.arguments as LabTestModel;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(test.name),
        backgroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(test.name,
                            style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text('₹${test.discountedPrice.toStringAsFixed(0)}',
                                style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800)),
                            const SizedBox(width: 8),
                            Text('₹${test.price.toStringAsFixed(0)}',
                                style: GoogleFonts.nunito(
                                    color: Colors.white60,
                                    fontSize: 16,
                                    decoration: TextDecoration.lineThrough)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.science_rounded,
                        color: Colors.white, size: 32),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Info row
            Row(
              children: [
                _buildInfoChip(Icons.timer_rounded, 'Report: ${test.reportTime}'),
                const SizedBox(width: 8),
                _buildInfoChip(Icons.format_list_numbered_rounded,
                    '${test.parameters.length} Parameters'),
                if (test.isHomeCollection) ...[
                  const SizedBox(width: 8),
                  _buildInfoChip(Icons.home_rounded, 'Home Collection'),
                ],
              ],
            ),
            const SizedBox(height: 20),
            // Description
            if (test.description.isNotEmpty) ...[
              _sectionTitle('About This Test'),
              const SizedBox(height: 8),
              Text(test.description,
                  style: GoogleFonts.nunito(
                      fontSize: 14, color: AppColors.textMuted, height: 1.5)),
              const SizedBox(height: 20),
            ],
            // Parameters
            _sectionTitle('Parameters Included'),
            const SizedBox(height: 10),
            ...test.parameters.map((param) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(param,
                          style: GoogleFonts.nunito(
                              fontSize: 14, color: AppColors.textDark)),
                    ],
                  ),
                )),
            if (test.preparation.isNotEmpty) ...[
              const SizedBox(height: 20),
              _sectionTitle('Preparation'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        color: AppColors.warning, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(test.preparation,
                          style: GoogleFonts.nunito(
                              fontSize: 13, color: AppColors.textDark)),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: CustomButton(
            text: 'Book Test — ₹${test.discountedPrice.toStringAsFixed(0)}',
            onPressed: () => Get.toNamed('/book-test', arguments: test),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title,
        style: GoogleFonts.nunito(
            fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark));
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.blushPink.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(height: 4),
            Text(label,
                style: GoogleFonts.nunito(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
