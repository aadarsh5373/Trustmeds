import 'package:flutter_test/flutter_test.dart';
import 'package:medicare_plus/main.dart';
import 'package:medicare_plus/core/constants/app_constants.dart';

void main() {
  testWidgets('shows TrustMeds branding on startup',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TrustMedsApp());

    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text(AppConstants.appTagline), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
