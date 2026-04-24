import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../models/lab_test_model.dart';
import '../../cart/controllers/cart_controller.dart';

class BookTestScreen extends StatefulWidget {
  const BookTestScreen({super.key});

  @override
  State<BookTestScreen> createState() => _BookTestScreenState();
}

class _BookTestScreenState extends State<BookTestScreen> {
  DateTime? selectedDate;
  String? selectedSlot;
  bool homeCollection = true;

  final slots = [
    '7:00 AM - 8:00 AM',
    '8:00 AM - 9:00 AM',
    '9:00 AM - 10:00 AM',
    '10:00 AM - 11:00 AM',
    '11:00 AM - 12:00 PM',
    '2:00 PM - 3:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    final test = Get.arguments as LabTestModel;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Book Test'),
        backgroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Test info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.blushPink.withOpacity(0.4)),
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
                        Text(test.name,
                            style: GoogleFonts.nunito(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark)),
                        Text('₹${test.discountedPrice.toStringAsFixed(0)}',
                            style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Collection type
            _sectionTitle('Collection Type'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: _buildCollectionOption(
                        'Home Collection', Icons.home_rounded, true)),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildCollectionOption(
                        'Visit Center', Icons.local_hospital_rounded, false)),
              ],
            ),
            const SizedBox(height: 20),
            // Date picker
            _sectionTitle('Select Date'),
            const SizedBox(height: 10),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (_, index) {
                  final date = DateTime.now().add(Duration(days: index + 1));
                  final isSelected = selectedDate != null &&
                      selectedDate!.day == date.day &&
                      selectedDate!.month == date.month;
                  final dayNames = [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun'
                  ];

                  return GestureDetector(
                    onTap: () => setState(() => selectedDate = date),
                    child: Container(
                      width: 62,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.blushPink,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(dayNames[date.weekday - 1],
                              style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  color: isSelected
                                      ? Colors.white70
                                      : AppColors.textMuted)),
                          Text('${date.day}',
                              style: GoogleFonts.nunito(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textDark)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Time slots
            _sectionTitle('Select Time Slot'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: slots.map((slot) {
                final isSelected = selectedSlot == slot;
                return GestureDetector(
                  onTap: () => setState(() => selectedSlot = slot),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.blushPink,
                      ),
                    ),
                    child: Text(slot,
                        style: GoogleFonts.nunito(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textDark)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Address
            if (homeCollection) ...[
              _sectionTitle('Collection Address'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border:
                      Border.all(color: AppColors.blushPink.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        color: AppColors.primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text('42, Sunshine Apartments, MG Road, Mumbai',
                          style: GoogleFonts.nunito(
                              fontSize: 13, color: AppColors.textDark)),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('Change',
                          style: GoogleFonts.nunito(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12)),
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
            text: 'Add to Cart — ₹${test.discountedPrice.toStringAsFixed(0)}',
            onPressed: (selectedDate != null && selectedSlot != null)
                ? () {
                    final cartController = Get.find<CartController>();
                    cartController.addLabTestToCart(test);
                    Get.back();
                    Get.back(); // Back to list
                  }
                : null,
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title,
        style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark));
  }

  Widget _buildCollectionOption(String label, IconData icon, bool isHome) {
    final isSelected = homeCollection == isHome;
    return GestureDetector(
      onTap: () => setState(() => homeCollection = isHome),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.blushPink,
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                color: isSelected ? Colors.white : AppColors.primary, size: 24),
            const SizedBox(height: 6),
            Text(label,
                style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textDark)),
          ],
        ),
      ),
    );
  }
}
