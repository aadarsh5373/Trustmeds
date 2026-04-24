import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class VideoConsultScreen extends StatefulWidget {
  const VideoConsultScreen({super.key});

  @override
  State<VideoConsultScreen> createState() => _VideoConsultScreenState();
}

class _VideoConsultScreenState extends State<VideoConsultScreen> {
  bool isMuted = false;
  bool isVideoOff = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Stack(
          children: [
            // Doctor View (Main screen)
            Center(
              child: isVideoOff
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white24,
                          child: Text(
                            'Dr',
                            style: GoogleFonts.nunito(
                                fontSize: 40, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text('Dr. Priya Sharma',
                            style: GoogleFonts.nunito(
                                fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                        Text('02:45',
                            style: GoogleFonts.nunito(fontSize: 16, color: Colors.white70)),
                      ],
                    )
                  : Container(
                      color: Colors.grey[900],
                      width: double.infinity,
                      height: double.infinity,
                      child: const Center(
                        child: Icon(Icons.person_outline_rounded,
                            size: 150, color: Colors.white10),
                      ),
                    ),
            ),

            // Top Bar
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 32),
                    onPressed: () => Get.back(),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('Ongoing',
                            style: GoogleFonts.nunito(
                                fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cameraswitch_rounded, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // User Self View Camera
            Positioned(
              top: 80,
              right: 16,
              child: Container(
                width: 100,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Center(
                  child: Icon(Icons.person_rounded, color: Colors.white54, size: 40),
                ),
              ),
            ),

            // Bottom Controls
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(
                      icon: isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                      color: isMuted ? Colors.white : Colors.white24,
                      iconColor: isMuted ? Colors.black : Colors.white,
                      onTap: () => setState(() => isMuted = !isMuted),
                    ),
                    _buildControlButton(
                      icon: isVideoOff ? Icons.videocam_off_rounded : Icons.videocam_rounded,
                      color: isVideoOff ? Colors.white : Colors.white24,
                      iconColor: isVideoOff ? Colors.black : Colors.white,
                      onTap: () => setState(() => isVideoOff = !isVideoOff),
                    ),
                    _buildControlButton(
                      icon: Icons.chat_rounded,
                      color: Colors.white24,
                      iconColor: Colors.white,
                      onTap: () {},
                    ),
                    _buildControlButton(
                      icon: Icons.call_end_rounded,
                      color: AppColors.error,
                      iconColor: Colors.white,
                      onTap: () => Get.back(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 28),
      ),
    );
  }
}
