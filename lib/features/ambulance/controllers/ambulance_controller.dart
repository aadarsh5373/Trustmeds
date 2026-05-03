import 'package:get/get.dart';
import '../../../core/utils/helpers.dart';
import '../models/ambulance_plan_model.dart';
import 'dart:async';

class AmbulanceController extends GetxController {
  final RxBool isRwaVerified = false.obs;
  final RxBool hasActivePlan = false.obs; // This is now redundant but kept for compatibility
  final RxBool isSocietySubscribed = false.obs;
  final RxString societyName = ''.obs;
  final RxInt interestCount = 12.obs; // Mock interest count
  final RxBool isSosActive = false.obs;
  
  final RxString activeDriverName = ''.obs;
  final RxString activeDriverNumber = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    _checkSocietyStatus();
  }

  void _checkSocietyStatus() {
    // In real app, fetch from auth controller or API
    // Mocking for now
    societyName.value = 'Sun City Apartments';
    isSocietySubscribed.value = true;
    isRwaVerified.value = true;
  }

  void purchasePlan(AmbulancePlanModel plan) {
    // Mocking a purchase and RWA verification. In reality, RWA would approve via their dashboard.
    hasActivePlan.value = true;
    isRwaVerified.value = true;
    Helpers.showSuccessSnackbar('Successfully subscribed to ${plan.title}. RWA verification complete.');
  }

  void triggerSos() {
    if (!isSocietySubscribed.value) {
      Helpers.showErrorSnackbar('Ambulance services are not yet active in your society.');
      return;
    }
    
    isSosActive.value = true;
    Helpers.showSuccessSnackbar('SOS Triggered! Alerting neighbors and dispatching ambulance...');
    
    // Simulate finding a driver
    Timer(const Duration(seconds: 2), () {
      activeDriverName.value = 'Ramesh Kumar (Paramedic)';
      activeDriverNumber.value = '+91 98765 43210';
      Helpers.showInfoSnackbar('Driver assigned. ETA: 4 mins.');
      
      // Automatically navigate to live tracking
      Get.toNamed('/live-tracking');
    });
  }

  void cancelSos() {
    isSosActive.value = false;
    activeDriverName.value = '';
    activeDriverNumber.value = '';
    Helpers.showInfoSnackbar('SOS Cancelled.');
  }

  Future<void> requestForSociety() async {
    // Mock API call to submit lead
    await Future.delayed(const Duration(seconds: 1));
    interestCount.value++;
    Helpers.showSuccessSnackbar('Interest recorded! We will reach out to your society RWA soon.');
  }
}
