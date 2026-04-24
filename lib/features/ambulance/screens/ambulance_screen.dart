import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../models/ambulance_plan_model.dart';
import '../controllers/ambulance_controller.dart';

class AmbulanceScreen extends StatelessWidget {
  const AmbulanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AmbulanceController());
    final plans = AmbulancePlanService.getPlans();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('24/7 Ambulance & SOS'),
        backgroundColor: AppColors.white,
      ),
      body: Obx(() {
        if (!controller.isRwaVerified.value || !controller.hasActivePlan.value) {
          return _buildSubscriptionView(plans, controller);
        }
        return _buildActiveSOSView(controller);
      }),
    );
  }

  Widget _buildSubscriptionView(List<AmbulancePlanModel> plans, AmbulanceController controller) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.softPink,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Icon(Icons.security, color: AppColors.primary, size: 40),
              const SizedBox(height: 10),
              Text(
                'RWA Verification Required',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'To prevent misuse and ensure rapid access to your society, please select a plan. Your RWA will verify your unit.',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ...plans.map((plan) => Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    plan.title,
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    plan.price,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                plan.description,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 12),
              ...plan.features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        f,
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Subscribe',
                onPressed: () => controller.purchasePlan(plan),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildActiveSOSView(AmbulanceController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_user, color: AppColors.success, size: 20),
                const SizedBox(width: 8),
                Text(
                  'RWA Verified - Active Plan',
                  style: GoogleFonts.nunito(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          GestureDetector(
            onTap: () {
              if (!controller.isSosActive.value) {
                controller.triggerSos();
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: controller.isSosActive.value ? 220 : 200,
              height: controller.isSosActive.value ? 220 : 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: controller.isSosActive.value ? AppColors.error : AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: (controller.isSosActive.value ? AppColors.error : AppColors.primary).withOpacity(0.4),
                    blurRadius: controller.isSosActive.value ? 30 : 20,
                    spreadRadius: controller.isSosActive.value ? 10 : 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  controller.isSosActive.value ? 'SOS\nACTIVE' : 'Tap for\nSOS',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          if (controller.isSosActive.value) ...[
            Text(
              'Alerting neighbors & dispatching ambulance...',
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 20),
            if (controller.activeDriverName.value.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.softPink,
                          child: const Icon(Icons.local_hospital, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.activeDriverName.value,
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                controller.activeDriverNumber.value,
                                style: GoogleFonts.nunito(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.call, color: AppColors.success),
                          onPressed: () {
                            // Link to phone dialer
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () => controller.cancelSos(),
              child: Text(
                'Cancel SOS',
                style: GoogleFonts.nunito(
                  color: AppColors.textMuted,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ] else ...[
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 40),
               child: Text(
                 'In case of emergency, tap the SOS button to instantly alert neighborhood volunteers and dispatch a paramedic.',
                 textAlign: TextAlign.center,
                 style: GoogleFonts.nunito(
                   fontSize: 14,
                   color: AppColors.textMuted,
                 ),
               ),
             ),
          ]
        ],
      ),
    );
  }
}
