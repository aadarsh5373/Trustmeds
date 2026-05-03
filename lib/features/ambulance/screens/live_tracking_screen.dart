import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../controllers/ambulance_controller.dart';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AmbulanceController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Mock Map Background
          _buildMockMap(),

          // Back Button
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                onPressed: () => Get.back(),
              ),
            ),
          ),

          // Top Info Card
          Positioned(
            top: 50,
            left: 80,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.error.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.emergency_rounded, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Ambulance is on the way',
                          style: AppTextStyles.titleLarge.copyWith(color: Colors.white, fontSize: 14),
                        ),
                        Text(
                          'ETA: 4 mins • 1.2 km away',
                          style: AppTextStyles.caption.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Driver Card
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: _buildDriverCard(controller),
          ),
        ],
      ),
    );
  }

  Widget _buildMockMap() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFE5E7EB), // Light grey map color
      child: Stack(
        children: [
          // Grid lines to simulate map
          ...List.generate(10, (i) => Positioned(
            left: i * 50.0,
            top: 0,
            bottom: 0,
            child: Container(width: 1, color: Colors.white.withOpacity(0.3)),
          )),
          ...List.generate(20, (i) => Positioned(
            top: i * 50.0,
            left: 0,
            right: 0,
            child: Container(height: 1, color: Colors.white.withOpacity(0.3)),
          )),

          // User Location
          Positioned(
            top: 400,
            left: 200,
            child: _buildLocationPulse(AppColors.secondary),
          ),

          // Ambulance Location (Moving)
          Positioned(
            top: 550,
            left: 100,
            child: _buildLocationPulse(AppColors.error, isAmbulance: true),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationPulse(Color color, {bool isAmbulance = false}) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 50 * _pulseController.value,
              height: 50 * _pulseController.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(1 - _pulseController.value),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: isAmbulance 
                ? const Icon(Icons.local_hospital, color: Colors.white, size: 10)
                : null,
            ),
          ],
        );
      },
    );
  }

  Widget _buildDriverCard(AmbulanceController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.person_rounded, color: AppColors.secondary, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.activeDriverName.value.isEmpty ? 'Rajesh Kumar' : controller.activeDriverName.value,
                      style: AppTextStyles.titleLarge,
                    ),
                    Text(
                      'Paramedic ID: TM-9921',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.call, color: AppColors.success),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(Icons.star, '4.9', 'Rating'),
              _buildInfoItem(Icons.local_shipping, 'KA 01 MG 1234', 'Vehicle'),
              _buildInfoItem(Icons.medical_services, 'Advanced', 'Life Support'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textMuted, size: 20),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.subhead.copyWith(fontSize: 12)),
        Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10)),
      ],
    );
  }
}
