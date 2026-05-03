import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool isMuted = false;
  bool isCameraOff = false;
  bool showChat = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Remote Video Feed (Doctor) - Mocked with a placeholder
          _buildRemoteFeed(),

          // Local Video Preview (User)
          _buildLocalPreview(),

          // Top Info Bar
          _buildTopBar(),

          // Call Controls (Bottom)
          _buildCallControls(),

          // Chat Overlay (if enabled)
          if (showChat) _buildChatOverlay(),
        ],
      ),
    );
  }

  Widget _buildRemoteFeed() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?q=80&w=1000'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.4),
              Colors.transparent,
              Colors.black.withOpacity(0.6),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocalPreview() {
    return Positioned(
      top: 60,
      right: 20,
      child: Container(
        width: 110,
        height: 160,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: isCameraOff 
            ? const Center(child: Icon(Icons.videocam_off, color: Colors.white54))
            : Image.network(
                'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=1000',
                fit: BoxFit.cover,
              ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 60,
      left: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.fiber_manual_record, color: Colors.red, size: 12),
              const SizedBox(width: 8),
              Text(
                '14:22',
                style: AppTextStyles.titleLarge.copyWith(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Dr. Ananya Sharma',
            style: AppTextStyles.subhead.copyWith(color: Colors.white70),
          ),
          Text(
            'Cardiologist • Fortis Hospital',
            style: AppTextStyles.caption.copyWith(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildCallControls() {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: isMuted ? Icons.mic_off : Icons.mic,
            color: isMuted ? Colors.white : Colors.white12,
            iconColor: isMuted ? Colors.black : Colors.white,
            onTap: () => setState(() => isMuted = !isMuted),
          ),
          _buildControlButton(
            icon: isCameraOff ? Icons.videocam_off : Icons.videocam,
            color: isCameraOff ? Colors.white : Colors.white12,
            iconColor: isCameraOff ? Colors.black : Colors.white,
            onTap: () => setState(() => isCameraOff = !isCameraOff),
          ),
          _buildControlButton(
            icon: Icons.chat_bubble_outline,
            color: Colors.white12,
            onTap: () => setState(() => showChat = !showChat),
          ),
          _buildControlButton(
            icon: Icons.call_end,
            color: Colors.red,
            size: 70,
            iconSize: 32,
            onTap: () => Get.back(),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    Color iconColor = Colors.white,
    double size = 56,
    double iconSize = 24,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: iconSize),
      ),
    );
  }

  Widget _buildChatOverlay() {
    return Positioned(
      bottom: 130,
      left: 20,
      right: 20,
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Consultation Chat', style: AppTextStyles.subhead.copyWith(color: Colors.white)),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                  onPressed: () => setState(() => showChat = false),
                ),
              ],
            ),
            const Divider(color: Colors.white10),
            Expanded(
              child: ListView(
                children: [
                  _buildChatMessage('Dr. Ananya', 'Hello! Can you hear me clearly?'),
                  _buildChatMessage('You', 'Yes doctor, I can.'),
                  _buildChatMessage('Dr. Ananya', 'Great. Let\'s discuss your recent report.'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatMessage(String sender, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(sender, style: AppTextStyles.caption.copyWith(color: AppColors.secondary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(text, style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}
