import 'package:get/get.dart';
import '../../../core/utils/helpers.dart';
import '../models/ambulance_plan_model.dart';
import 'dart:async';

class AmbulanceController extends GetxController {
  final RxBool isRwaVerified = false.obs;
  final RxBool hasActivePlan = false.obs;
  final RxBool isSosActive = false.obs;
  
  final RxString activeDriverName = ''.obs;
  final RxString activeDriverNumber = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Initially user is not verified.
  }

  void purchasePlan(AmbulancePlanModel plan) {
    // Mocking a purchase and RWA verification. In reality, RWA would approve via their dashboard.
    hasActivePlan.value = true;
    isRwaVerified.value = true;
    Helpers.showSuccessSnackbar('Successfully subscribed to ${plan.title}. RWA verification complete.');
  }

  void triggerSos() {
    if (!isRwaVerified.value || !hasActivePlan.value) {
      Helpers.showErrorSnackbar('Active plan & RWA approval required to trigger SOS.');
      return;
    }
    
    isSosActive.value = true;
    Helpers.showSuccessSnackbar('SOS Triggered! Alerting neighbors and dispatching ambulance...');
    
    // Simulate finding a driver
    Timer(const Duration(seconds: 2), () {
      activeDriverName.value = 'Ramesh Kumar (Paramedic)';
      activeDriverNumber.value = '+91 98765 43210';
      Helpers.showInfoSnackbar('Driver assigned. ETA: 4 mins.');
    });
  }

  void cancelSos() {
    isSosActive.value = false;
    activeDriverName.value = '';
    activeDriverNumber.value = '';
    Helpers.showInfoSnackbar('SOS Cancelled.');
  }
}
