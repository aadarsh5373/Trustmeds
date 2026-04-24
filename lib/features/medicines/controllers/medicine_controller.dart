import 'package:get/get.dart';
import '../../../services/mock_data_service.dart';
import '../models/medicine_model.dart';
import '../../cart/controllers/cart_controller.dart';

class MedicineController extends GetxController {
  final RxList<MedicineModel> medicines = <MedicineModel>[].obs;
  final RxList<MedicineModel> filteredMedicines = <MedicineModel>[].obs;
  final RxList<MedicineModel> searchResults = <MedicineModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedCategory = ''.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadMedicines();
  }

  void loadMedicines() {
    isLoading.value = true;
    medicines.value = MockDataService.getMedicines();
    filteredMedicines.value = medicines;
    isLoading.value = false;
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    if (category.isEmpty) {
      filteredMedicines.value = medicines;
    } else {
      filteredMedicines.value =
          medicines.where((m) => m.category == category).toList();
    }
  }

  void search(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }
    searchResults.value = medicines
        .where((m) =>
            m.name.toLowerCase().contains(query.toLowerCase()) ||
            m.genericName.toLowerCase().contains(query.toLowerCase()) ||
            m.brand.toLowerCase().contains(query.toLowerCase()) ||
            m.category.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void addToCart(MedicineModel medicine) {
    final cartController = Get.find<CartController>();
    cartController.addToCart(medicine);
  }
}
