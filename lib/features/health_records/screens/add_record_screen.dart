import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/utils/helpers.dart';

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({super.key});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final _titleController = TextEditingController();
  final _doctorController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedType = 'prescription';

  @override
  void dispose() {
    _titleController.dispose();
    _doctorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Health Record'),
        backgroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: _titleController,
              labelText: 'Record Title',
              hintText: 'e.g., Blood Test Report',
              prefixIcon: Icons.title_rounded,
            ),
            const SizedBox(height: 20),
            Text('Record Type',
                style: GoogleFonts.nunito(
                    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildTypeChip('prescription', 'Prescription'),
                _buildTypeChip('report', 'Lab Report'),
                _buildTypeChip('vaccination', 'Vaccination'),
                _buildTypeChip('allergy', 'Allergy'),
              ],
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _doctorController,
              labelText: 'Doctor Name (Optional)',
              hintText: 'e.g., Dr. Priya Sharma',
              prefixIcon: Icons.person_rounded,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _notesController,
              labelText: 'Notes (Optional)',
              hintText: 'Any additional notes...',
              prefixIcon: Icons.notes_rounded,
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            // File upload
            Text('Upload File',
                style: GoogleFonts.nunito(
                    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.blushPink, width: 1.5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_upload_rounded,
                        size: 36, color: AppColors.primary),
                    const SizedBox(height: 8),
                    Text('Tap to upload file',
                        style: GoogleFonts.nunito(
                            fontSize: 13, color: AppColors.textMuted)),
                    Text('PDF, JPEG, PNG supported',
                        style: GoogleFonts.nunito(
                            fontSize: 11, color: AppColors.textLight)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Save Record',
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  Helpers.showSuccessSnackbar('Health record saved!');
                  Get.back();
                } else {
                  Helpers.showErrorSnackbar('Please enter a title');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String type, String label) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.blushPink,
          ),
        ),
        child: Text(label,
            style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textDark)),
      ),
    );
  }
}
