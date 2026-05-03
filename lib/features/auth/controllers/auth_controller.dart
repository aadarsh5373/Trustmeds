import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/api_service.dart';
import '../../auth/models/user_model.dart';
import '../../../services/local_data_service.dart';

class AuthController extends GetxController {
  final LocalDataService _localDataService = Get.find<LocalDataService>();
  final ApiService _apiService = Get.put(ApiService());
  
  FirebaseAuth? get _auth {
    try {
      return FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }
  
  bool get _isFirebaseEnabled {
    try {
      return _auth != null && _auth!.app.name.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
  
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
    
    if (!_isFirebaseEnabled) {
      // Mock bypass
      await Future.delayed(const Duration(seconds: 1));
      verificationId.value = 'mock_ver_id';
      isLoading.value = false;
      Get.snackbar('Dev Mode', 'Using mock OTP (123456)');
      return;
    }

    try {
      await _auth!.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          isLoading.value = false;
          Get.snackbar('Verification Failed', e.message ?? 'Unknown error');
        },
        codeSent: (String verId, int? resendToken) {
          verificationId.value = verId;
          isLoading.value = false;
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId.value = verId;
        },
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  Future<bool> verifyOTP(String otp, {String? societyId}) async {
    isLoading.value = true;
    
    if (!_isFirebaseEnabled || verificationId.value == 'mock_ver_id') {
      if (otp == '123456') {
        await _signInWithMockToken(societyId: societyId);
        return true;
      }
      isLoading.value = false;
      Get.snackbar('Error', 'Invalid Dev OTP');
      return false;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );
      await _signInWithCredential(credential, societyId: societyId);
      return true;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Invalid OTP');
      return false;
    }
  }

  Future<void> _signInWithMockToken({String? societyId}) async {
    try {
      // Send mock token to our backend
      final response = await _apiService.client.post('/auth/login', data: {
        'idToken': 'mock_token',
        'societyId': societyId,
      });

      if (response.data['success']) {
        final userData = response.data['user'];
        final accessToken = response.data['accessToken'];
        
        await _apiService.saveToken(accessToken);
        
        user.value = UserModel(
          uid: userData['id'],
          name: userData['name'] ?? 'Dev User',
          phone: userData['phone_number'] ?? '+919999999999',
          email: userData['email'] ?? 'dev@trustmeds.com',
          gender: 'Not Specified',
          createdAt: DateTime.parse(userData['created_at']),
          addresses: [],
        );
        
        isLoggedIn.value = true;
        selectedAddressId.value = _resolveSelectedAddressId();
        await _persistUser();
      }
    } catch (e) {
      Get.snackbar('Dev Login Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential, {String? societyId}) async {
    try {
      final UserCredential userCredential = await _auth!.signInWithCredential(credential);
      final String? idToken = await userCredential.user?.getIdToken();
      
      if (idToken != null) {
        // Send token to our backend
        final response = await _apiService.client.post('/auth/login', data: {
          'idToken': idToken,
          'societyId': societyId,
        });

        if (response.data['success']) {
          // Parse user data from backend
          // We map it to our UserModel
          final userData = response.data['user'];
          final accessToken = response.data['accessToken'];
          
          await _apiService.saveToken(accessToken);
          
          user.value = UserModel(
            uid: userData['id'],
            name: userData['name'] ?? '',
            phone: userData['phone_number'] ?? '',
            email: userData['email'] ?? '',
            gender: 'Not Specified', // Update backend to handle gender if needed
            createdAt: DateTime.parse(userData['created_at']),
            addresses: [], // Fetch addresses later or parse from response
          );
          
          isLoggedIn.value = true;
          selectedAddressId.value = _resolveSelectedAddressId();
          await _persistUser();
        }
      }
    } catch (e) {
      Get.snackbar('Login Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
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
    _auth?.signOut();
    _apiService.clearToken();
    user.value = null;
    isLoggedIn.value = false;
    selectedAddressId.value = '';
    latestPrescription.clear();
    _localDataService.clearSession();
    Get.offAllNamed('/login');
  }
}
