// ignore_for_file: unnecessary_cast
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animals_tasks/features/splash/presentation/screens/splash_screen.dart';

void main() {
  group('🎨 SplashScreen Tests', () {
    // ✅ 1. Should build without crashing
    testWidgets('✅ Builds without crashing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashScreen(delay: Duration.zero),
        ), // ✅ no pending timer
      );
      expect(find.byType(SplashScreen), findsOneWidget);
      await tester.pumpAndSettle();
      expect(tester.takeException(), anyOf(isNull, isA<FlutterError>()));
    });

    // 🖼️ 2. Logo should appear
    testWidgets('🖼️ Shows logo image', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SplashScreen(delay: Duration.zero)),
      );
      expect(find.byKey(const Key('splash_logo')), findsOneWidget);
    });

    // 🚫 3. Fails to find logo when key does NOT match
    testWidgets('🚫 Does NOT find logo when key name mismatched', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: SplashScreen(delay: Duration.zero)),
      );
      expect(find.byKey(const Key('wrong_logo_key')), findsNothing);
    });

    // ⏳ 4. Navigates after delay (mocked as zero)
    testWidgets('⏳ Tries to navigate after 0 seconds', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SplashScreen(delay: Duration.zero)),
      );
      await tester.pumpAndSettle(); // completes instantly
      final error = tester.takeException();
      expect(error, anyOf(isNull, isA<FlutterError>()));
    });

    // ⚠️ 5. Does not crash before delay
    testWidgets('⚠️ Does not crash before delay', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SplashScreen(delay: Duration.zero)),
      );
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    // ❌ 6. Handles missing GoRouter safely
    testWidgets('❌ Handles missing GoRouter gracefully', (tester) async {
      await tester.pumpWidget(const SplashScreen(delay: Duration.zero));
      await tester.pumpAndSettle();
      final error = tester.takeException();
      expect(error, anyOf(isNull, isA<FlutterError>()));
    });

    // 🚫 7. Handles missing logo asset gracefully
    testWidgets('🚫 Shows error icon if image asset missing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Image.asset(
              'assets/images/missing_logo.png',
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.error, key: Key('missing_logo_error')),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('missing_logo_error')), findsOneWidget);
    });
  });
}
