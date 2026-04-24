import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/utils/helpers.dart';
import '../models/doctor_model.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctor = Get.arguments as DoctorModel;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Text(
                        doctor.name.split(' ').last[0],
                        style: GoogleFonts.nunito(
                            fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(doctor.name,
                        style: GoogleFonts.nunito(
                            fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(doctor.specialization,
                        style: GoogleFonts.nunito(
                            fontSize: 14, color: Colors.white70)),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row
                  Row(
                    children: [
                      _buildStat('${doctor.experience}+', 'Years Exp'),
                      _buildStat('${doctor.rating}', 'Rating'),
                      _buildStat('${doctor.reviewCount}', 'Reviews'),
                      _buildStat('₹${doctor.consultationFee.toStringAsFixed(0)}', 'Fee'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Availability
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: doctor.isAvailableNow
                          ? AppColors.success.withOpacity(0.08)
                          : AppColors.warning.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: doctor.isAvailableNow
                            ? AppColors.success.withOpacity(0.3)
                            : AppColors.warning.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          doctor.isAvailableNow
                              ? Icons.check_circle_rounded
                              : Icons.schedule_rounded,
                          color: doctor.isAvailableNow
                              ? AppColors.success
                              : AppColors.warning,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          doctor.isAvailableNow
                              ? 'Available Now for Consultation'
                              : 'Currently Unavailable',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: doctor.isAvailableNow
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Bio
                  _sectionTitle('About'),
                  const SizedBox(height: 8),
                  Text(doctor.bio,
                      style: GoogleFonts.nunito(
                          fontSize: 14, color: AppColors.textMuted, height: 1.5)),
                  const SizedBox(height: 20),
                  // Qualification
                  _sectionTitle('Qualification'),
                  const SizedBox(height: 8),
                  Text(doctor.qualification,
                      style: GoogleFonts.nunito(
                          fontSize: 14, color: AppColors.textDark)),
                  const SizedBox(height: 20),
                  // Languages
                  _sectionTitle('Languages'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: doctor.languages.map((lang) {
                      return Chip(
                        label: Text(lang,
                            style: GoogleFonts.nunito(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                        backgroundColor: AppColors.softPink,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
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
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Book Video Consult',
                  icon: Icons.video_call_rounded,
                  onPressed: doctor.isAvailableNow
                      ? () {
                          Helpers.showSuccessSnackbar(
                              'Consultation booked with ${doctor.name}!');
                          Get.back();
                        }
                      : null,
                ),
              ),
            ],
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

  Widget _buildStat(String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.blushPink.withOpacity(0.4)),
        ),
        child: Column(
          children: [
            Text(value,
                style: GoogleFonts.nunito(
                    fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
            const SizedBox(height: 2),
            Text(label,
                style: GoogleFonts.nunito(
                    fontSize: 10, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
