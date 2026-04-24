import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthController _authController = Get.find<AuthController>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
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
                  const SizedBox(height: 40),
                  // Title
                  Text(
                    AppStrings.welcomeBack,
                    style: GoogleFonts.nunito(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppStrings.loginSubtitle,
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 36),
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
                            _authController
                                .sendOTP(_phoneController.text)
                                .then((_) {
                              Get.toNamed('/otp',
                                  arguments: _phoneController.text);
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
}
