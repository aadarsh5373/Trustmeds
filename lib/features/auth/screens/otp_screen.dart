import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/utils/helpers.dart';
import '../controllers/auth_controller.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();
  int _resendTimer = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _canResend = false;
    _resendTimer = 30;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _resendTimer--);
      if (_resendTimer <= 0) {
        setState(() => _canResend = true);
        return false;
      }
      return true;
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments as Map<String, dynamic>? ?? {};
    final phone = args['phone'] as String? ?? '98765 43210';
    final societyId = args['societyId'] as String?;

    final defaultPinTheme = PinTheme(
      width: 52,
      height: 56,
      textStyle: GoogleFonts.nunito(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.blushPink, width: 1.5),
      ),
    );

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.blushPink.withOpacity(0.5)),
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.textDark,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Title
                Text(
                  AppStrings.enterOtp,
                  style: GoogleFonts.nunito(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${AppStrings.otpSent}\n+91 $phone',
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    color: AppColors.textMuted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                // OTP Input
                Center(
                  child: Pinput(
                    length: 6,
                    controller: _otpController,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.primary, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: AppColors.softPink,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.primary, width: 1.5),
                      ),
                    ),
                    onCompleted: (pin) => _verifyOTP(pin),
                  ),
                ),
                const SizedBox(height: 16),
                // Mock hint
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.softPink,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Demo: Enter 123456',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Resend
                Center(
                  child: _canResend
                      ? TextButton(
                          onPressed: () {
                            _startTimer();
                          },
                          child: Text(
                            AppStrings.resendOtp,
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        )
                      : Text(
                          'Resend OTP in ${_resendTimer}s',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: AppColors.textMuted,
                          ),
                        ),
                ),
                const SizedBox(height: 40),
                // Verify button
                Obx(() => CustomButton(
                      text: AppStrings.verifyOtp,
                      isLoading: _authController.isLoading.value,
                      onPressed: () => _verifyOTP(_otpController.text, societyId: societyId),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _verifyOTP(String otp, {String? societyId}) async {
    if (otp.length != 6) {
      Helpers.showErrorSnackbar('Please enter a valid 6-digit OTP');
      return;
    }
    final success = await _authController.verifyOTP(otp, societyId: societyId);
    if (success) {
      Get.offAllNamed('/home');
    } else {
      Helpers.showErrorSnackbar('Invalid OTP. Try 123456');
    }
  }
}
