import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../features/cart/controllers/cart_controller.dart';
import '../../../services/mock_data_service.dart';
import '../../../features/medicines/models/medicine_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final medicines = MockDataService.getMedicines();
    final categories = MockDataService.getCategories();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildSearchBar(),
                  const SizedBox(height: 20),
                  _buildTrustOverview(),
                  const SizedBox(height: 20),
                  _buildBannerCarousel(),
                  const SizedBox(height: 24),
                  _buildQuickActions(),
                  const SizedBox(height: 24),
                  _buildSectionTitle(AppStrings.shopByCategory, () {}),
                  const SizedBox(height: 12),
                  _buildCategoryGrid(categories),
                  const SizedBox(height: 24),
                  _buildSectionTitle(AppStrings.popularMedicines,
                      () => Get.toNamed('/medicines')),
                  const SizedBox(height: 12),
                  _buildMedicinesRow(medicines),
                  const SizedBox(height: 24),
                  _buildSectionTitle(
                      AppStrings.bookLabTests, () => Get.toNamed('/lab-tests')),
                  const SizedBox(height: 12),
                  _buildLabTestsRow(),
                  const SizedBox(height: 24),
                  _buildConsultBanner(),
                  const SizedBox(height: 24),
                  _buildHealthTipsBanner(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: AppColors.surface,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 72,
      title: Row(
        children: [
          GestureDetector(
            onTap: () => Get.toNamed('/profile'),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.blushPink),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.medical_services_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppConstants.appName,
                style: GoogleFonts.inter(
                  color: AppColors.textDark,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Trusted delivery across Mumbai',
                style: GoogleFonts.inter(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GetBuilder<CartController>(
            id: 'cart_badge',
            builder: (controller) {
              final itemCount = controller.items
                  .fold<int>(0, (sum, item) => sum + item.quantity);

              return GestureDetector(
                onTap: () => Get.toNamed('/cart'),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.blushPink),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_rounded,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                    if (itemCount > 0)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$itemCount',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.blushPink, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Get.toNamed('/search'),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded,
                        color: AppColors.primary, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppStrings.searchHint,
                        style: GoogleFonts.inter(
                          color: AppColors.textLight,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => Get.toNamed('/upload-prescription'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.upload_file_rounded,
                      color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    AppStrings.uploadRx,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustOverview() {
    final highlights = [
      {'value': '30 min', 'label': 'Avg. delivery'},
      {'value': '24/7', 'label': 'Doctor access'},
      {'value': '100%', 'label': 'Genuine meds'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.blushPink.withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Care you can trust',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Fast medicines, diagnostics, and consultations from one trusted app.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textMuted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: highlights.map((item) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: item == highlights.last ? 0 : 8,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        item['value']!,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['label']!,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCarousel() {
    final bannerData = [
      {
        'title': 'Flat 25% OFF',
        'subtitle': 'On all medicines\nUse code: MEDI25',
        'asset': 'assets/images/offer_banner.svg'
      },
      {
        'title': 'Free Health Checkup',
        'subtitle': 'Book full body checkup\nat just ₹999',
        'asset': 'assets/images/lab_banner.svg'
      },
      {
        'title': 'Consult Now',
        'subtitle': 'Talk to doctors\nin 60 seconds',
        'asset': 'assets/images/consult_banner.svg'
      },
    ];

    return SizedBox(
      height: 124,
      child: PageView.builder(
        itemCount: bannerData.length,
        controller: PageController(viewportFraction: 0.95),
        itemBuilder: (_, index) {
          final banner = bannerData[index];
          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: index == 0
                    ? [const Color(0xFF3B82F6), const Color(0xFF1E293B)] // Navy/Blue
                    : index == 1
                        ? [const Color(0xFF10B981), const Color(0xFF047857)] // Emerald
                        : [const Color(0xFF6366F1), const Color(0xFF4338CA)], // Indigo
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        banner['title'] as String,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        banner['subtitle'] as String,
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 82,
                  height: 82,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: SvgPicture.asset(
                    banner['asset'] as String,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'icon': Icons.medication_rounded,
        'label': 'Medicines',
        'route': '/medicines'
      },
      {
        'icon': Icons.upload_file_rounded,
        'label': 'Prescription',
        'route': '/upload-prescription'
      },
      {
        'icon': Icons.science_rounded,
        'label': 'Lab Tests',
        'route': '/lab-tests'
      },
      {
        'icon': Icons.video_call_rounded,
        'label': 'Consult',
        'route': '/doctors'
      },
      {
        'icon': Icons.folder_shared_rounded,
        'label': 'Records',
        'route': '/records'
      },
      {
        'icon': Icons.local_hospital_rounded,
        'label': 'SOS Alert',
        'route': '/ambulance'
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = MediaQuery.of(context).size.width - 32;
        final crossAxisCount = availableWidth >= 1100
            ? 6
            : availableWidth >= 900
                ? 5
                : 3;
        final itemWidth =
            (availableWidth - ((crossAxisCount - 1) * 12)) / crossAxisCount;

        return Wrap(
          spacing: 12,
          runSpacing: 18,
          children: actions.map((action) {
            return SizedBox(
              width: itemWidth,
              child: GestureDetector(
                onTap: () => Get.toNamed(action['route'] as String),
                child: Column(
                  children: [
                    Container(
                      width: availableWidth >= 1100 ? 66 : 72,
                      height: availableWidth >= 1100 ? 66 : 72,
                      decoration: BoxDecoration(
                        gradient: action['label'] == 'SOS Alert' 
                            ? const LinearGradient(colors: [AppColors.accentRose, Color(0xFFE11D48)])
                            : AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: (action['label'] == 'SOS Alert' ? AppColors.accentRose : AppColors.secondary).withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(action['icon'] as IconData,
                          color: Colors.white, size: 30),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      action['label'] as String,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, VoidCallback onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
            letterSpacing: -0.2,
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Text(
            AppStrings.seeAll,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.secondary,
          ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid(List<Map<String, dynamic>> categories) {
    final icons = {
      'medication': Icons.medication_rounded,
      'local_pharmacy': Icons.local_pharmacy_rounded,
      'medical_services': Icons.medical_services_rounded,
      'spa': Icons.spa_rounded,
      'science': Icons.science_rounded,
      'eco': Icons.eco_rounded,
      'air': Icons.air_rounded,
      'monitor_heart': Icons.monitor_heart_rounded,
      'child_care': Icons.child_care_rounded,
    };

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.05,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: categories.length,
      itemBuilder: (_, index) {
        final cat = categories[index];
        return GestureDetector(
          onTap: () => Get.toNamed('/medicines', arguments: cat['name']),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.blushPink.withOpacity(0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.softPink.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icons[cat['icon']] ?? Icons.category_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cat['name'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMedicinesRow(List<MedicineModel> medicines) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: medicines.length > 6 ? 6 : medicines.length,
        itemBuilder: (_, index) {
          final med = medicines[index];
          return GestureDetector(
            onTap: () => Get.toNamed('/medicine-detail', arguments: med),
            child: Container(
              width: 150,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.blushPink.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.softPink.withOpacity(0.4),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.medication_rounded,
                                color: AppColors.primary, size: 36),
                          ),
                        ),
                        if (med.discount > 0)
                          Positioned(
                            top: 6,
                            left: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${med.discount}% OFF',
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            med.name,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            med.brand,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                '₹${med.sellingPrice.toStringAsFixed(0)}',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.secondary,
                                ),
                              ),
                              if (med.discount > 0) ...[
                                const SizedBox(width: 4),
                                Text(
                                  '₹${med.mrp.toStringAsFixed(0)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: AppColors.textLight,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabTestsRow() {
    final tests =
        MockDataService.getLabTests().where((t) => t.isPopular).toList();
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tests.length,
        itemBuilder: (_, index) {
          final test = tests[index];
          return GestureDetector(
            onTap: () => Get.toNamed('/lab-tests'),
            child: Container(
              width: 210,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    test.name,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    '${test.parameters.length} Parameters',
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '₹${test.discountedPrice.toStringAsFixed(0)}',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '₹${test.price.toStringAsFixed(0)}',
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 11,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildConsultBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.consultDoctor,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.consultSubtitle,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => Get.toNamed('/doctors'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      AppStrings.bookNow,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.health_and_safety_rounded,
              size: 40,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthTipsBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.blushPink.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tips_and_updates_rounded,
                  color: AppColors.secondary, size: 22),
              const SizedBox(width: 8),
              Text(
                'Health Tip of the Day',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Stay hydrated. Drinking enough water through the day helps maintain energy levels and supports kidney function.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
