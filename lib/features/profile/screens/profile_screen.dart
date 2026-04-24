import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/helpers.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Text(
                          controller.userName.isNotEmpty
                              ? controller.userName[0].toUpperCase()
                              : 'U',
                          style: GoogleFonts.nunito(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(controller.userName,
                          style: GoogleFonts.nunito(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                      const SizedBox(height: 2),
                      Text(controller.userPhone,
                          style: GoogleFonts.nunito(
                              fontSize: 14, color: Colors.white70)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSection('My Account', [
                    _buildMenuItem(
                        Icons.shopping_bag_rounded, 'My Orders', () {}),
                    _buildMenuItem(Icons.location_on_rounded, 'My Addresses',
                        () => Get.toNamed('/addresses')),
                    _buildMenuItem(Icons.folder_shared_rounded,
                        'Health Records', () => Get.toNamed('/records')),
                    _buildMenuItem(Icons.favorite_rounded, 'Wishlist', () {}),
                  ]),
                  const SizedBox(height: 12),
                  _buildSection('General', [
                    _buildMenuItem(
                        Icons.notifications_rounded, 'Notifications', () {}),
                    _buildMenuItem(Icons.settings_rounded, 'Settings',
                        () => Get.toNamed('/settings')),
                    _buildMenuItem(
                        Icons.support_agent_rounded, 'Contact Support', () {}),
                    _buildMenuItem(Icons.info_rounded, 'About Us', () {}),
                    _buildMenuItem(
                        Icons.privacy_tip_rounded, 'Privacy Policy', () {}),
                  ]),
                  const SizedBox(height: 12),
                  // Logout
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
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: AppColors.error.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout_rounded,
                              color: AppColors.error, size: 20),
                          const SizedBox(width: 8),
                          Text('Logout',
                              style: GoogleFonts.nunito(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.error)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('${AppConstants.appName} v1.0.0',
                      style: GoogleFonts.nunito(
                          fontSize: 12, color: AppColors.textLight)),
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blushPink.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Text(title,
                style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted)),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.softPink.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title,
          style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark)),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: AppColors.textLight, size: 22),
      onTap: onTap,
      dense: true,
    );
  }
}
