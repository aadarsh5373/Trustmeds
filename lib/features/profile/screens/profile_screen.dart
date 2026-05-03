import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/constants/app_text_styles.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => Get.back(),
            ),
            backgroundColor: AppColors.secondary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white30, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: Text(
                            controller.userName.isNotEmpty
                                ? controller.userName[0].toUpperCase()
                                : 'U',
                            style: AppTextStyles.display.copyWith(fontSize: 32, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(controller.userName,
                          style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
                      Text(controller.userPhone,
                          style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildSection('Health Services', [
                    _buildMenuItem(Icons.shopping_bag_rounded, 'My Orders', () => Get.toNamed('/order-history')),
                    _buildMenuItem(Icons.location_on_rounded, 'Manage Addresses', () => Get.toNamed('/addresses')),
                    _buildMenuItem(Icons.folder_shared_rounded, 'Medical Records', () => Get.toNamed('/records')),
                  ]),
                  const SizedBox(height: 16),
                  _buildSection('Settings & Support', [
                    _buildMenuItem(Icons.notifications_rounded, 'Notifications', () {}),
                    _buildMenuItem(Icons.settings_rounded, 'App Settings', () => Get.toNamed('/settings')),
                    _buildMenuItem(Icons.privacy_tip_rounded, 'Privacy Policy', () {}),
                    _buildMenuItem(Icons.support_agent_rounded, 'Help Center', () {}),
                    _buildMenuItem(Icons.info_rounded, 'About TrustMeds', () {}),
                    _buildMenuItem(Icons.delete_forever_rounded, 'Delete Account', () async {
                      final confirm = await Helpers.showConfirmDialog(
                        title: 'Delete Account',
                        message: 'This will permanently delete your medical data and account. This action cannot be undone.',
                        confirmText: 'Delete Forever',
                      );
                      if (confirm == true) {
                        controller.logout(); // In production, call a real delete API
                      }
                    }),
                  ]),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () async {
                      final confirm = await Helpers.showConfirmDialog(
                        title: 'Logout',
                        message: 'Are you sure you want to logout?',
                        confirmText: 'Logout',
                      );
                      if (confirm == true) {
                        controller.logout();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.error.withOpacity(0.1)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Sign Out',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '${AppConstants.appName} v1.0.0',
                    style: AppTextStyles.caption.copyWith(fontSize: 10),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textLight,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.divider.withOpacity(0.5)),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.secondary, size: 20),
      ),
      title: Text(
        title,
        style: AppTextStyles.subhead.copyWith(fontSize: 14),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.divider, size: 24),
    );
  }
}
