import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/doctor_controller.dart';

class DoctorsListScreen extends StatelessWidget {
  const DoctorsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DoctorController());
    final specializations = [
      'All',
      'General Physician',
      'Dermatologist',
      'Pediatrician',
      'Cardiologist',
      'Gynecologist',
      'Orthopedic',
      'Neurologist',
      'Endocrinologist'
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Consult Doctors'),
        backgroundColor: AppColors.white,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed('/upload-prescription'),
            icon: const Icon(Icons.upload_file_rounded),
            tooltip: 'Upload Prescription',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          SizedBox(
            height: 50,
            child: GetBuilder<DoctorController>(builder: (_) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: specializations.length,
                itemBuilder: (_, index) {
                  final spec = specializations[index];
                  final isSelected = (spec == 'All' &&
                          controller.selectedSpecialization.isEmpty) ||
                      spec == controller.selectedSpecialization;
                  return GestureDetector(
                    onTap: () => controller
                        .filterBySpecialization(spec == 'All' ? '' : spec),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.blushPink,
                        ),
                      ),
                      child: Center(
                        child: Text(spec,
                            style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textDark)),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          // Doctors list
          Expanded(
            child: GetBuilder<DoctorController>(builder: (_) {
              final docs = controller.filteredDoctors;
              if (docs.isEmpty) {
                return Center(
                  child: Text('No doctors found',
                      style: GoogleFonts.nunito(color: AppColors.textMuted)),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: docs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  final doc = docs[index];
                  return GestureDetector(
                    onTap: () => Get.toNamed('/doctor-profile', arguments: doc),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: AppColors.blushPink.withOpacity(0.4)),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: AppColors.softPink,
                            child: Text(
                              doc.name.split(' ').last[0],
                              style: GoogleFonts.nunito(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(doc.name,
                                          style: GoogleFonts.nunito(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textDark)),
                                    ),
                                    if (doc.isAvailableNow)
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: AppColors.success,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(doc.specialization,
                                    style: GoogleFonts.nunito(
                                        fontSize: 13,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 2),
                                Text(
                                    '${doc.experience} yrs exp • ${doc.qualification}',
                                    style: GoogleFonts.nunito(
                                        fontSize: 11,
                                        color: AppColors.textMuted)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.star_rounded,
                                        size: 14, color: Colors.amber[700]),
                                    const SizedBox(width: 3),
                                    Text('${doc.rating}',
                                        style: GoogleFonts.nunito(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textDark)),
                                    Text(' (${doc.reviewCount})',
                                        style: GoogleFonts.nunito(
                                            fontSize: 11,
                                            color: AppColors.textMuted)),
                                    const Spacer(),
                                    Text(
                                        '₹${doc.consultationFee.toStringAsFixed(0)}',
                                        style: GoogleFonts.nunito(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.primary)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
