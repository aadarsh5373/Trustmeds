import 'package:get/get.dart';
import '../../../services/mock_data_service.dart';
import '../models/doctor_model.dart';

class DoctorController extends GetxController {
  List<DoctorModel> doctors = <DoctorModel>[];
  List<DoctorModel> filteredDoctors = <DoctorModel>[];
  bool isLoading = false;
  String selectedSpecialization = '';

  @override
  void onInit() {
    super.onInit();
    loadDoctors();
  }

  void loadDoctors() {
    isLoading = true;
    doctors = MockDataService.getDoctors();
    filteredDoctors = List<DoctorModel>.from(doctors);
    isLoading = false;
    update();
  }

  void filterBySpecialization(String spec) {
    selectedSpecialization = spec;
    if (spec.isEmpty) {
      filteredDoctors = List<DoctorModel>.from(doctors);
    } else {
      filteredDoctors = doctors.where((d) => d.specialization == spec).toList();
    }
    update();
  }
}
