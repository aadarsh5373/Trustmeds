import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../auth/controllers/auth_controller.dart';

class UploadPrescriptionScreen extends StatefulWidget {
  const UploadPrescriptionScreen({super.key});

  @override
  State<UploadPrescriptionScreen> createState() =>
      _UploadPrescriptionScreenState();
}

class _UploadPrescriptionScreenState extends State<UploadPrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedSource = 'Camera';

  @override
  void initState() {
    super.initState();
    final authController = Get.find<AuthController>();
    final sanitizedPhone = (authController.currentUser?.phone ?? '')
        .replaceAll(RegExp(r'[^0-9]'), '');
    _patientNameController.text = authController.currentUser?.name ?? '';
    _phoneController.text = sanitizedPhone.substring(
      sanitizedPhone.length > 10 ? sanitizedPhone.length - 10 : 0,
    );
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final latestPrescription = authController.latestPrescription;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Upload Prescription'),
        backgroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.blushPink,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.softPink,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.cloud_upload_rounded,
                          size: 48, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Upload Prescription',
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Save prescription details so the pharmacist can verify the order.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildOption(Icons.camera_alt_rounded, 'Camera'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildOption(Icons.photo_library_rounded, 'Gallery'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _patientNameController,
                labelText: 'Patient Name',
                hintText: 'Enter patient name',
                prefixIcon: Icons.person_rounded,
                validator: Validators.validateName,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: _phoneController,
                labelText: 'Contact Number',
                hintText: 'Enter 10-digit phone number',
                prefixIcon: Icons.phone_rounded,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: Validators.validatePhone,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: _notesController,
                labelText: 'Medicines / Notes',
                hintText:
                    'Mention medicines, dosage notes, or delivery instructions',
                prefixIcon: Icons.notes_rounded,
                maxLines: 4,
                validator: (value) =>
                    Validators.validateRequired(value, 'prescription notes'),
              ),
              if (latestPrescription.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last saved prescription',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${latestPrescription['patientName'] ?? ''} • ${latestPrescription['sourceLabel'] ?? ''}',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.softPink.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        color: AppColors.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Valid prescription is required for medicines marked with Rx. Our pharmacist will verify your prescription after submission.',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Submit Prescription',
                onPressed: () async {
                  if (!(_formKey.currentState?.validate() ?? false)) return;

                  await authController.savePrescriptionDetails({
                    'patientName': _patientNameController.text.trim(),
                    'phone': _phoneController.text.trim(),
                    'notes': _notesController.text.trim(),
                    'sourceLabel': _selectedSource,
                    'submittedAt': DateTime.now().toIso8601String(),
                  });

                  Helpers.showSuccessSnackbar(
                      'Prescription details saved successfully');
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(IconData icon, String label) {
    final isSelected = _selectedSource == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedSource = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySurface : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.blushPink,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
