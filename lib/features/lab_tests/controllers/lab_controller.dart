import 'package:get/get.dart';
import '../../../services/mock_data_service.dart';
import '../models/lab_test_model.dart';

class LabController extends GetxController {
  final RxList<LabTestModel> allTests = <LabTestModel>[].obs;
  final RxList<LabTestModel> popularTests = <LabTestModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTests();
  }

  void loadTests() {
    isLoading.value = true;
    allTests.value = MockDataService.getLabTests();
    popularTests.value = allTests.where((t) => t.isPopular).toList();
    isLoading.value = false;
  }
}
