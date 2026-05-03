import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../models/user_model.dart';

class SocietySelectionScreen extends StatefulWidget {
  const SocietySelectionScreen({super.key});

  @override
  State<SocietySelectionScreen> createState() => _SocietySelectionScreenState();
}

class _SocietySelectionScreenState extends State<SocietySelectionScreen> {
  final _pincodeController = TextEditingController();
  final RxList<SocietyModel> _societies = <SocietyModel>[].obs;
  final RxBool _isLoading = false.obs;
  SocietyModel? _selectedSociety;

  void _searchSocieties(String pincode) {
    if (pincode.length < 6) return;
    
    _isLoading.value = true;
    // Mock API call
    Future.delayed(const Duration(seconds: 1), () {
      _societies.value = [
        SocietyModel(id: 's1', name: 'Sunshine Apartments', pincode: pincode, isSubscribed: true),
        SocietyModel(id: 's2', name: 'Green Valley', pincode: pincode, isSubscribed: false),
        SocietyModel(id: 's3', name: 'Blue Ridge', pincode: pincode, isSubscribed: true),
      ];
      _isLoading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Society'),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(color: AppColors.background),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Find your society to unlock benefits',
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ambulance services are provided at a society level. Select yours to check availability.',
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 32),
            CustomTextField(
              controller: _pincodeController,
              labelText: 'Pincode',
              hintText: 'Enter 6-digit pincode',
              prefixIcon: Icons.location_on_outlined,
              keyboardType: TextInputType.number,
              maxLength: 6,
              onChanged: _searchSocieties,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(() {
                if (_isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (_pincodeController.text.length == 6 && _societies.isEmpty) {
                  return _buildNoResults();
                }
                return ListView.separated(
                  itemCount: _societies.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final society = _societies[index];
                    final isSelected = _selectedSociety?.id == society.id;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedSociety = society),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.secondary : AppColors.divider,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: AppColors.secondary.withOpacity(0.1),
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    society.name,
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: society.isSubscribed 
                                            ? AppColors.success.withOpacity(0.1)
                                            : AppColors.warning.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          society.isSubscribed ? 'Subscribed' : 'Coming Soon',
                                          style: GoogleFonts.nunito(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: society.isSubscribed ? AppColors.success : AppColors.warning,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle, color: AppColors.secondary),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Confirm Society',
              onPressed: _selectedSociety == null 
                ? null 
                : () => Get.back(result: _selectedSociety),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.search_off_rounded, size: 64, color: AppColors.textLight.withOpacity(0.5)),
        const SizedBox(height: 16),
        Text(
          'No societies found in this pincode',
          style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {
            // Show lead generation dialog
          },
          child: const Text('Request for my society'),
        ),
      ],
    );
  }
}
