import 'package:get/get.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/onboarding_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/otp_screen.dart';
import '../features/auth/screens/society_selection_screen.dart';
import '../features/home/screens/main_shell.dart';
import '../features/medicines/screens/medicine_list_screen.dart';
import '../features/medicines/screens/medicine_detail_screen.dart';
import '../features/medicines/screens/search_screen.dart';
import '../features/medicines/screens/upload_prescription_screen.dart';
import '../features/cart/screens/cart_screen.dart';
import '../features/orders/screens/checkout_screen.dart';
import '../features/orders/screens/order_confirmation_screen.dart';
import '../features/orders/screens/order_tracking_screen.dart';
import '../features/lab_tests/screens/lab_tests_screen.dart';
import '../features/lab_tests/screens/test_detail_screen.dart';
import '../features/lab_tests/screens/book_test_screen.dart';
import '../features/doctor_consult/screens/doctors_list_screen.dart';
import '../features/doctor_consult/screens/doctor_profile_screen.dart';
import '../features/doctor_consult/screens/video_consult_screen.dart';
import '../features/doctor_consult/screens/video_call_screen.dart';
import '../features/health_records/screens/records_screen.dart';
import '../features/health_records/screens/add_record_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/profile/screens/address_screen.dart';
import '../features/profile/screens/settings_screen.dart';
import '../features/ambulance/screens/ambulance_screen.dart';
import '../features/ambulance/screens/live_tracking_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String medicines = '/medicines';
  static const String medicineDetail = '/medicine-detail';
  static const String search = '/search';
  static const String uploadPrescription = '/upload-prescription';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderConfirmation = '/order-confirmation';
  static const String orderTracking = '/order-tracking';
  static const String labTests = '/lab-tests';
  static const String testDetail = '/test-detail';
  static const String bookTest = '/book-test';
  static const String doctors = '/doctors';
  static const String doctorProfile = '/doctor-profile';
  static const String videoConsult = '/video-consult';
  static const String records = '/records';
  static const String addRecord = '/add-record';
  static const String videoCall = '/video-call';
  static const String profile = '/profile';
  static const String addresses = '/addresses';
  static const String settings = '/settings';
  static const String ambulance = '/ambulance';
  static const String liveTracking = '/live-tracking';
  static const String selectSociety = '/select-society';

  static final pages = [
    GetPage(name: splash, page: () => const SplashScreen(), transition: Transition.fadeIn),
    GetPage(name: onboarding, page: () => const OnboardingScreen(), transition: Transition.fadeIn),
    GetPage(name: login, page: () => const LoginScreen(), transition: Transition.fadeIn),
    GetPage(name: register, page: () => const RegisterScreen()),
    GetPage(name: otp, page: () => const OtpScreen()),
    GetPage(name: home, page: () => const MainShell(), transition: Transition.fadeIn),
    GetPage(name: medicines, page: () => const MedicineListScreen()),
    GetPage(name: medicineDetail, page: () => const MedicineDetailScreen()),
    GetPage(name: search, page: () => const SearchScreen()),
    GetPage(name: uploadPrescription, page: () => const UploadPrescriptionScreen()),
    GetPage(name: cart, page: () => const CartScreen()),
    GetPage(name: checkout, page: () => const CheckoutScreen()),
    GetPage(name: orderConfirmation, page: () => const OrderConfirmationScreen()),
    GetPage(name: orderTracking, page: () => const OrderTrackingScreen()),
    GetPage(name: labTests, page: () => const LabTestsScreen()),
    GetPage(name: testDetail, page: () => const TestDetailScreen()),
    GetPage(name: bookTest, page: () => const BookTestScreen()),
    GetPage(name: doctors, page: () => const DoctorsListScreen()),
    GetPage(name: doctorProfile, page: () => const DoctorProfileScreen()),
    GetPage(name: videoConsult, page: () => const VideoConsultScreen()),
    GetPage(name: records, page: () => const RecordsScreen()),
    GetPage(name: addRecord, page: () => const AddRecordScreen()),
    GetPage(name: videoCall, page: () => const VideoCallScreen()),
    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(name: addresses, page: () => const AddressScreen()),
    GetPage(name: settings, page: () => const SettingsScreen()),
    GetPage(name: ambulance, page: () => const AmbulanceScreen()),
    GetPage(name: liveTracking, page: () => const LiveTrackingScreen()),
    GetPage(name: selectSociety, page: () => const SocietySelectionScreen()),
  ];
}
