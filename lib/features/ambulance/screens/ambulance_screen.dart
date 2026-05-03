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
        if (!controller.isSocietySubscribed.value) {
          return _buildUnsubscribedView(controller);
        }
        return _buildActiveSOSView(controller);
      }),
    );
  }

  Widget _buildUnsubscribedView(AmbulanceController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.divider),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.emergency_outlined, color: AppColors.warning, size: 48),
                ),
                const SizedBox(height: 20),
                Text(
                  'Service Unavailable',
                  style: GoogleFonts.nunito(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ambulance services are not yet active in ${controller.societyName.value}.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.people_alt_rounded, color: AppColors.secondary, size: 20),
                    const SizedBox(width: 8),
                    Obx(() => Text(
                      '${controller.interestCount.value} neighbors have requested this',
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    )),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Help us reach 20 requests to activate service!',
                  style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textLight),
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Request for my society',
                  onPressed: () => controller.requestForSociety(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildFeatureList(),
        ],
      ),
    );
  }

  Widget _buildFeatureList() {
    final features = [
      {'icon': Icons.flash_on_rounded, 'title': '3-Min Response Time', 'desc': 'Priority dispatch for subscribed societies'},
      {'icon': Icons.medical_services_rounded, 'title': 'Paramedic on Board', 'desc': 'Advanced life support in every vehicle'},
      {'icon': Icons.group_rounded, 'title': 'Neighbor Alerts', 'desc': 'Automatically notify neighborhood volunteers'},
    ];

    return Column(
      children: features.map((f) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(f['icon'] as IconData, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    f['title'] as String,
                    style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    f['desc'] as String,
                    style: GoogleFonts.nunito(color: AppColors.textMuted, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      )).toList(),
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
                Obx(() => Text(
                  'Included with ${controller.societyName.value}',
                  style: GoogleFonts.nunito(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                )),
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
