import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:animals_tasks/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('🧩 Full flow: Splash → Onboarding → Home (no crash)', (tester) async {
    // 🚀 Start app
    app.main();
    await tester.pump(const Duration(seconds: 1)); // initial frame
    await tester.pumpAndSettle(const Duration(seconds: 2)); // let splash appear

    // 🐾 Verify Splash
    final splashLogo = find.byKey(const Key('splash_logo'));
    expect(splashLogo, findsOneWidget,
        reason: 'Splash logo should appear before navigation');

    // Wait for splash transition to finish
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // 🐶 Verify onboarding loaded
    expect(find.text('Find Your Best\nCompanion With Us'), findsOneWidget,
        reason: 'Onboarding title should appear after splash');

    // 💫 Tap the Get Started button safely
    final getStarted = find.text('Get Started');
    expect(getStarted, findsOneWidget,
        reason: 'Get Started button must exist before tapping');
    await tester.tap(getStarted);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // 🏠 Verify Home Screen
    expect(find.text('Find Your Forever Pet'), findsOneWidget,
        reason: 'Home screen should appear after onboarding navigation');
  });
}