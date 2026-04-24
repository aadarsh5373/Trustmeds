import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _orderUpdates = true;
  bool _promotions = false;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('Notifications', [
            _buildSwitch('Push Notifications', 'Order updates, offers & more', _notifications, (v) => setState(() => _notifications = v)),
            _buildSwitch('Order Updates', 'Get notified about your orders', _orderUpdates, (v) => setState(() => _orderUpdates = v)),
            _buildSwitch('Promotions', 'Deals, offers & discounts', _promotions, (v) => setState(() => _promotions = v)),
          ]),
          const SizedBox(height: 12),
          _buildSection('Appearance', [
            _buildSwitch('Dark Mode', 'Coming soon', _darkMode, (v) => setState(() => _darkMode = v)),
          ]),
          const SizedBox(height: 12),
          _buildSection('About', [
            _buildInfoTile('Version', '1.0.0'),
            _buildInfoTile('Terms of Service', ''),
            _buildInfoTile('Privacy Policy', ''),
            _buildInfoTile('Open Source Licenses', ''),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
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
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
            child: Text(title,
                style: GoogleFonts.nunito(
                    fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textMuted)),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitch(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      title: Text(title,
          style: GoogleFonts.nunito(
              fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
      subtitle: Text(subtitle,
          style: GoogleFonts.nunito(fontSize: 12, color: AppColors.textMuted)),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
      dense: true,
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return ListTile(
      title: Text(title,
          style: GoogleFonts.nunito(
              fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
      trailing: value.isNotEmpty
          ? Text(value,
              style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textMuted))
          : const Icon(Icons.chevron_right_rounded, color: AppColors.textLight, size: 20),
      dense: true,
    );
  }
}
