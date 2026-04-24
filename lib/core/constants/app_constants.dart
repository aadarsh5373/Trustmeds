class AppConstants {
  // App Info
  static const String appName = 'TrustMeds';
  static const String appTagline = 'Trusted care, delivered with confidence';

  // Delivery
  static const double freeDeliveryThreshold = 499.0;
  static const double deliveryFee = 49.0;

  // Cart
  static const int maxCartQuantity = 10;

  // OTP
  static const int otpLength = 6;
  static const int otpTimeout = 60;

  // Pagination
  static const int pageSize = 20;

  // Animation Duration
  static const int splashDuration = 2500;
  static const int animDurationFast = 200;
  static const int animDurationNormal = 300;
  static const int animDurationSlow = 500;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 20.0;
  static const double radiusXLarge = 28.0;
  static const double radiusCircular = 100.0;

  // Padding
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String medicinesCollection = 'medicines';
  static const String categoriesCollection = 'categories';
  static const String ordersCollection = 'orders';
  static const String cartCollection = 'cart';
  static const String labTestsCollection = 'lab_tests';
  static const String doctorsCollection = 'doctors';
  static const String bannersCollection = 'banners';
  static const String consultationsCollection = 'consultations';
  static const String healthRecordsCollection = 'health_records';
  static const String labBookingsCollection = 'lab_bookings';
  static const String notificationsCollection = 'notifications';
}
