import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../features/cart/controllers/cart_controller.dart';
import '../../../services/mock_data_service.dart';
import '../../../features/medicines/models/medicine_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final medicines = MockDataService.getMedicines();
    final categories = MockDataService.getCategories();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildSearchBar(),
                  const SizedBox(height: 20),
                  const RepaintBoundary(child: _TrustOverview()),
                  const SizedBox(height: 20),
                  const RepaintBoundary(child: _BannerCarousel()),
                  const SizedBox(height: 24),
                  const _QuickActions(),
                  const SizedBox(height: 24),
                  const _EmergencyCare(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildSliverSectionTitle(AppStrings.shopByCategory, () {}),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            sliver: _buildCategoryGrid(categories),
          ),
          _buildSliverSectionTitle(AppStrings.popularMedicines,
              () => Get.toNamed('/medicines')),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: _buildMedicinesRow(medicines),
            ),
          ),
          _buildSliverSectionTitle(
              AppStrings.bookLabTests, () => Get.toNamed('/lab-tests')),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: _LabTestsRow(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: const [
                  SizedBox(height: 12),
                  _ConsultBanner(),
                  SizedBox(height: 24),
                  _HealthTipsBanner(),
                  SizedBox(height: 100),
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
                border: Border.all(color: AppColors.divider),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: AppColors.secondary,
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
                style: AppTextStyles.display.copyWith(fontSize: 18),
              ),
              Text(
                'Trusted delivery across Mumbai',
                style: AppTextStyles.caption,
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
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_rounded,
                        color: AppColors.secondary,
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
                            color: AppColors.accentRose,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$itemCount',
                            style: AppTextStyles.badge,
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

  Widget _buildSliverSectionTitle(String title, VoidCallback onSeeAll) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyles.heading),
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                AppStrings.seeAll,
                style: AppTextStyles.subhead.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.04),
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
                        color: AppColors.secondary, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppStrings.searchHint,
                        style: AppTextStyles.bodySmall,
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
                    style: AppTextStyles.badge,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final cat = categories[index];
          return GestureDetector(
            onTap: () => Get.toNamed('/medicines', arguments: cat['name']),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider.withOpacity(0.5)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icons[cat['icon']] ?? Icons.category_rounded,
                    color: AppColors.secondary,
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cat['name'] as String,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
        childCount: categories.length,
      ),
    );
  }

  Widget _buildMedicinesRow(List<MedicineModel> medicines) {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 16),
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
                border: Border.all(color: AppColors.divider.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface.withOpacity(0.4),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: const Icon(Icons.medication_rounded,
                          color: AppColors.secondary, size: 36),
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
                            style: AppTextStyles.subhead.copyWith(fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            med.brand,
                            style: AppTextStyles.caption,
                          ),
                          const Spacer(),
                          Text(
                            '₹${med.sellingPrice.toStringAsFixed(0)}',
                            style: AppTextStyles.priceSmall,
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
}

class _TrustOverview extends StatelessWidget {
  const _TrustOverview();

  @override
  Widget build(BuildContext context) {
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
        border: Border.all(color: AppColors.divider.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
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
                child: const Icon(Icons.verified_user_rounded,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Care you can trust', style: AppTextStyles.titleLarge),
                    Text(
                      'Fast medicines and consultations.',
                      style: AppTextStyles.bodySmall,
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
                  margin: EdgeInsets.only(right: item == highlights.last ? 0 : 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(item['value']!, style: AppTextStyles.priceSmall),
                      const SizedBox(height: 4),
                      Text(item['label']!,
                          style: AppTextStyles.caption,
                          textAlign: TextAlign.center),
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
}

class _BannerCarousel extends StatelessWidget {
  const _BannerCarousel();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 124,
      child: PageView.builder(
        itemCount: 3,
        controller: PageController(viewportFraction: 0.95),
        itemBuilder: (_, index) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: index == 0
                  ? AppColors.primaryGradient
                  : index == 1
                      ? AppColors.accentGradient
                      : const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF4338CA)]),
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
                        index == 0 ? 'Flat 25% OFF' : 'Free Health Checkup',
                        style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
                      ),
                      Text(
                        'On all services',
                        style: AppTextStyles.caption.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.local_offer_rounded, color: Colors.white30, size: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final actions = [
      {'icon': Icons.medication_rounded, 'label': 'Medicines', 'route': '/medicines'},
      {'icon': Icons.upload_file_rounded, 'label': 'Prescription', 'route': '/upload-prescription'},
      {'icon': Icons.science_rounded, 'label': 'Lab Tests', 'route': '/lab-tests'},
      {'icon': Icons.video_call_rounded, 'label': 'Consult', 'route': '/doctors'},
      {'icon': Icons.folder_shared_rounded, 'label': 'Records', 'route': '/records'},
      {'icon': Icons.local_hospital_rounded, 'label': 'SOS Alert', 'route': '/ambulance'},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 18,
      children: actions.map((action) {
        return SizedBox(
          width: (MediaQuery.of(context).size.width - 56) / 3,
          child: GestureDetector(
            onTap: () => Get.toNamed(action['route'] as String),
            child: Column(
              children: [
                Container(
                  width: 66,
                  height: 66,
                  decoration: BoxDecoration(
                    gradient: action['label'] == 'SOS Alert'
                        ? const LinearGradient(colors: [AppColors.accentRose, Color(0xFFE11D48)])
                        : AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(action['icon'] as IconData, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  action['label'] as String,
                  style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _LabTestsRow extends StatelessWidget {
  const _LabTestsRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondary.withOpacity(0.1)),
      ),
      child: Center(child: Text('Lab Tests Showcase', style: AppTextStyles.bodySmall)),
    );
  }
}

class _ConsultBanner extends StatelessWidget {
  const _ConsultBanner();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed('/video-call'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Instant Video Consult',
                      style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
                  Text('Consult top doctors in 60s',
                      style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                ],
              ),
            ),
            const Icon(Icons.video_call_rounded, color: Colors.white, size: 40),
          ],
        ),
      ),
    );
  }
}

class _HealthTipsBanner extends StatelessWidget {
  const _HealthTipsBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          const Icon(Icons.tips_and_updates_rounded, color: Colors.orange, size: 24),
          const SizedBox(width: 12),
          Text('Health Tip: Stay hydrated today!', style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
class _EmergencyCare extends StatelessWidget {
  const _EmergencyCare();

  @override
  Widget build(BuildContext context) {
    final emergencyItems = [
      {
        'title': 'Ambulance',
        'icon': Icons.local_hospital_rounded,
        'color': const Color(0xFFFFEBE8),
        'iconColor': AppColors.accentRose,
        'route': '/ambulance'
      },
      {
        'title': 'First Aid',
        'icon': Icons.medical_information_rounded,
        'color': const Color(0xFFFFF4EB),
        'iconColor': Colors.orangeAccent,
        'route': '/lab-tests'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Emergency Care',
              style: AppTextStyles.heading.copyWith(fontSize: 20),
            ),
            const SizedBox(width: 4),
            const Text('✨', style: TextStyle(fontSize: 18)),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: emergencyItems.length,
          itemBuilder: (context, index) {
            final item = emergencyItems[index];
            return GestureDetector(
              onTap: () => Get.toNamed(item['route'] as String),
              child: Container(
                decoration: BoxDecoration(
                  color: item['color'] as Color,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (item['color'] as Color).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 12,
                      bottom: 0,
                      top: 0,
                      child: Center(
                        child: Icon(
                          item['icon'] as IconData,
                          size: 36,
                          color: item['iconColor'] as Color,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 60,
                      top: 0,
                      bottom: 0,
                      right: 8,
                      child: Center(
                        child: Text(
                          item['title'] as String,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark.withOpacity(0.8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
