import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';

enum LoginPath { normal, ambulance }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthController _authController = Get.find<AuthController>();
  LoginPath _selectedPath = LoginPath.normal;
  SocietyModel? _selectedSociety;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectSociety() async {
    final result = await Get.toNamed('/select-society');
    if (result is SocietyModel) {
      setState(() {
        _selectedSociety = result;
      });
      if (!result.isSubscribed) {
        Get.snackbar(
          'Society Not Onboarded',
          '${result.name} is not yet onboarded for premium ambulance services. You can still login normally.',
          backgroundColor: AppColors.warning.withOpacity(0.1),
          colorText: AppColors.warning,
          duration: const Duration(seconds: 5),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
                  const SizedBox(height: 40),
                  // Logo
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.medical_services_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Path Selection
                  Row(
                    children: [
                      Expanded(
                        child: _buildPathCard(
                          title: 'Normal Services',
                          subtitle: 'Medicine & Lab',
                          icon: Icons.local_pharmacy_outlined,
                          isSelected: _selectedPath == LoginPath.normal,
                          onTap: () => setState(() => _selectedPath = LoginPath.normal),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildPathCard(
                          title: 'RWA Ambulance',
                          subtitle: 'Emergency Access',
                          icon: Icons.local_hospital_rounded,
                          isSelected: _selectedPath == LoginPath.ambulance,
                          onTap: () => setState(() => _selectedPath = LoginPath.ambulance),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  if (_selectedPath == LoginPath.ambulance) ...[
                    GestureDetector(
                      onTap: _selectSociety,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _selectedSociety != null ? AppColors.secondary : AppColors.divider,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.business_rounded,
                              color: _selectedSociety != null ? AppColors.secondary : AppColors.textMuted,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedSociety?.name ?? 'Select Your Society',
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold,
                                      color: _selectedSociety != null ? AppColors.textDark : AppColors.textMuted,
                                    ),
                                  ),
                                  if (_selectedSociety != null)
                                    Text(
                                      _selectedSociety!.isSubscribed ? 'Society Onboarded' : 'Not Onboarded (Normal Path)',
                                      style: GoogleFonts.nunito(
                                        fontSize: 12,
                                        color: _selectedSociety!.isSubscribed ? AppColors.success : AppColors.warning,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  // Title
                  Text(
                    AppStrings.welcomeBack,
                    style: GoogleFonts.nunito(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppStrings.loginSubtitle,
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Phone input
                  CustomTextField(
                    controller: _phoneController,
                    hintText: AppStrings.enterPhone,
                    prefixIcon: Icons.phone_rounded,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    validator: Validators.validatePhone,
                  ),
                  const SizedBox(height: 24),
                  // Continue button
                  Obx(() => CustomButton(
                        text: 'Continue',
                        isLoading: _authController.isLoading.value,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (_selectedPath == LoginPath.ambulance && _selectedSociety == null) {
                              Get.snackbar('Society Required', 'Please select your society to continue with RWA path.');
                              return;
                            }
                            _authController
                                .sendOTP(_phoneController.text)
                                .then((_) {
                              Get.toNamed('/otp', arguments: {
                                'phone': _phoneController.text,
                                'societyId': (_selectedPath == LoginPath.ambulance && _selectedSociety != null && _selectedSociety!.isSubscribed) 
                                    ? _selectedSociety!.id 
                                    : null,
                              });
                            });
                          }
                        },
                      )),
                  const SizedBox(height: 32),
                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.blushPink.withOpacity(0.5))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          AppStrings.orContinueWith,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: AppColors.blushPink.withOpacity(0.5))),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Google Sign In
                  CustomButton(
                    text: AppStrings.signInWithGoogle,
                    isOutlined: true,
                    icon: Icons.g_mobiledata_rounded,
                    onPressed: () async {
                      await _authController.signInWithGoogle();
                      if (_authController.isLoggedIn.value) {
                        Get.offAllNamed('/home');
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                  // Terms
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                        children: [
                          const TextSpan(
                            text: 'By continuing, you agree to our ',
                          ),
                          TextSpan(
                            text: 'Terms of Service',
                            style: GoogleFonts.nunito(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: GoogleFonts.nunito(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
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
        ),
      ),
    );
  }

  Widget _buildPathCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isSelected ? AppColors.secondary : AppColors.textMuted).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.secondary : AppColors.textMuted,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.textDark : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 11,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
