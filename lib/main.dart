import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'routes/app_router.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/cart/controllers/cart_controller.dart';
import 'features/orders/controllers/order_controller.dart';
import 'services/local_data_service.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    debugPrint('Running in DEVELOPMENT MOCK AUTH mode.');
  }

  final localDataService = await LocalDataService().init();
  Get.put(localDataService, permanent: true);

  // Register global controllers
  Get.put(AuthController(), permanent: true);
  Get.put(CartController(), permanent: true);
  Get.put(OrderController(), permanent: true);

  runApp(const TrustMedsApp());
}

class TrustMedsApp extends StatelessWidget {
  const TrustMedsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRouter.splash,
      getPages: AppRouter.pages,
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
