import 'package:get/get.dart';
import '../../auth/models/user_model.dart';
import '../../../services/local_data_service.dart';

class AuthController extends GetxController {
  final LocalDataService _localDataService = Get.find<LocalDataService>();
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxString verificationId = ''.obs;
  final RxString selectedAddressId = ''.obs;
  final RxMap<String, dynamic> latestPrescription = <String, dynamic>{}.obs;

  UserModel? get currentUser => user.value;
  List<AddressModel> get addresses => currentUser?.addresses ?? const [];
  AddressModel? get selectedAddress {
    if (addresses.isEmpty) return null;
    final selected = addresses.where((a) => a.id == selectedAddressId.value);
    if (selected.isNotEmpty) return selected.first;
    return addresses.first;
  }

  @override
  void onInit() {
    super.onInit();
    _restoreLocalState();
  }

  void _restoreLocalState() {
    final savedUser = _localDataService.getUserData();
    final savedPrescription = _localDataService.getLatestPrescription();

    if (savedUser != null) {
      user.value = UserModel.fromJson(savedUser);
      isLoggedIn.value = true;
      selectedAddressId.value = _resolveSelectedAddressId();
    } else {
      isLoggedIn.value = false;
    }

    if (savedPrescription != null) {
      latestPrescription.assignAll(savedPrescription);
    }
  }

  String _resolveSelectedAddressId() {
    final savedId = _localDataService.getSelectedAddressId();
    if (savedId != null && addresses.any((address) => address.id == savedId)) {
      return savedId;
    }
    return addresses.isNotEmpty ? addresses.first.id : '';
  }

  Future<void> _persistUser() async {
    if (user.value != null) {
      await _localDataService.saveUserData(user.value!.toJson());
      if (selectedAddress != null) {
        await _localDataService.saveSelectedAddressId(selectedAddress!.id);
      }
    }
  }

  UserModel _buildMockUser() {
    final existingAddresses = user.value?.addresses ?? const <AddressModel>[];

    return UserModel(
      uid: 'mock_user_001',
      name: 'Siddharth Singh',
      phone: '+91 98765 43210',
      email: 'siddharth@example.com',
      gender: 'Male',
      createdAt: DateTime.now(),
      addresses: existingAddresses.isNotEmpty
          ? existingAddresses
          : [
              AddressModel(
                id: 'addr_home',
                label: 'Home',
                fullAddress: '42, Sunshine Apartments, MG Road',
                pincode: '400001',
                city: 'Mumbai',
                state: 'Maharashtra',
              ),
            ],
    );
  }

  Future<void> sendOTP(String phoneNumber) async {
    isLoading.value = true;
    // Mock: simulate OTP sending delay
    await Future.delayed(const Duration(seconds: 2));
    verificationId.value = 'mock_verification_id';
    isLoading.value = false;
  }

  Future<bool> verifyOTP(String otp) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));

    if (otp == '123456') {
      user.value = _buildMockUser();
      isLoggedIn.value = true;
      selectedAddressId.value = _resolveSelectedAddressId();
      await _persistUser();
      isLoading.value = false;
      return true;
    }

    isLoading.value = false;
    return false;
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    user.value = _buildMockUser();
    isLoggedIn.value = true;
    selectedAddressId.value = _resolveSelectedAddressId();
    await _persistUser();
    isLoading.value = false;
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    String? email,
  }) async {
    final existing = user.value ?? _buildMockUser();
    user.value = existing.copyWith(
      name: name,
      phone: phone,
      email: email ?? existing.email,
    );
    await _persistUser();
  }

  Future<void> saveAddress(AddressModel address) async {
    final existing = List<AddressModel>.from(addresses);
    final index = existing.indexWhere((item) => item.id == address.id);

    if (index >= 0) {
      existing[index] = address;
    } else {
      existing.add(address);
    }

    final baseUser = user.value ?? _buildMockUser();
    user.value = baseUser.copyWith(addresses: existing);
    selectedAddressId.value =
        selectedAddressId.value.isEmpty ? address.id : selectedAddressId.value;
    await _persistUser();
  }

  Future<void> deleteAddress(String addressId) async {
    final updated = addresses.where((a) => a.id != addressId).toList();
    final baseUser = user.value ?? _buildMockUser();
    user.value = baseUser.copyWith(addresses: updated);
    if (selectedAddressId.value == addressId) {
      selectedAddressId.value = updated.isNotEmpty ? updated.first.id : '';
    }
    await _persistUser();
  }

  Future<void> selectAddress(String addressId) async {
    selectedAddressId.value = addressId;
    await _localDataService.saveSelectedAddressId(addressId);
  }

  Future<void> savePrescriptionDetails(Map<String, dynamic> data) async {
    latestPrescription.assignAll(data);
    await _localDataService.saveLatestPrescription(data);
  }

  void signOut() {
    user.value = null;
    isLoggedIn.value = false;
    selectedAddressId.value = '';
    latestPrescription.clear();
    _localDataService.clearSession();
    Get.offAllNamed('/login');
  }
}
