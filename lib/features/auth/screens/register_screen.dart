import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';
import '../models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedGender = '';
  SocietyModel? _selectedSociety;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Complete Your Profile',
                    style: GoogleFonts.nunito(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tell us a little about yourself',
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Avatar
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.softPink,
                          child: const Icon(Icons.person_rounded,
                              size: 50, color: AppColors.primary),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt_rounded,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    controller: _nameController,
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon: Icons.person_outline_rounded,
                    validator: Validators.validateName,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email (Optional)',
                    hintText: 'Enter your email',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Gender',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: ['Male', 'Female', 'Other'].map((gender) {
                      final selected = _selectedGender == gender;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedGender = gender),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: selected ? AppColors.primary : AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selected ? AppColors.primary : AppColors.blushPink,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                gender,
                                style: GoogleFonts.nunito(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: selected ? Colors.white : AppColors.textDark,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Your Society',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final result = await Get.toNamed('/select-society');
                      if (result != null && result is SocietyModel) {
                        setState(() => _selectedSociety = result);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.blushPink, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.apartment_rounded, 
                            color: _selectedSociety != null ? AppColors.secondary : AppColors.textLight),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _selectedSociety?.name ?? 'Select your society',
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                color: _selectedSociety != null ? AppColors.textDark : AppColors.textLight,
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    text: 'Save & Continue',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Get.offAllNamed('/home');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
