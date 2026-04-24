import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/models/user_model.dart';

class ProfileController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  String get userName => _authController.currentUser?.name ?? 'User';
  String get userPhone => _authController.currentUser?.phone ?? '';
  String get userEmail => _authController.currentUser?.email ?? '';
  List<AddressModel> get addresses => _authController.addresses;

  void logout() {
    _authController.signOut();
  }
}
