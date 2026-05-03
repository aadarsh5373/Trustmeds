import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/product_card.dart';
import '../controllers/medicine_controller.dart';

class MedicineListScreen extends StatelessWidget {
  const MedicineListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MedicineController());
    final category = Get.arguments as String?;

    if (category != null && category.isNotEmpty) {
      controller.filterByCategory(category);
    }

    final categories = [
      'All',
      'Pain Relief',
      'Vitamins',
      'Digestive',
      'Skin Care',
      'Antibiotics',
      'Ayurveda',
      'Allergy'
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(category ?? 'All Medicines'),
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => Get.toNamed('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter chips
          SizedBox(
            height: 50,
            child: Obx(() => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: categories.length,
                  itemBuilder: (_, index) {
                    final cat = categories[index];
                    final isSelected = (cat == 'All' &&
                            controller.selectedCategory.value.isEmpty) ||
                        cat == controller.selectedCategory.value;
                    return GestureDetector(
                      onTap: () =>
                          controller.filterByCategory(cat == 'All' ? '' : cat),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? AppColors.primary : AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.blushPink,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            cat,
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textDark,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )),
          ),
          // Product grid
          Expanded(
            child: Obx(() {
              // Accessing length registers the listener even if the list is empty
              if (controller.filteredMedicines.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.medication_rounded,
                          size: 64, color: AppColors.blushPink),
                      const SizedBox(height: 16),
                      Text(
                        'No medicines found',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.62,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: controller.filteredMedicines.length,
                itemBuilder: (_, index) {
                  final med = controller.filteredMedicines[index];
                  return ProductCard(
                    medicine: med,
                    onTap: () =>
                        Get.toNamed('/medicine-detail', arguments: med),
                    onAddToCart: () => controller.addToCart(med),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
