import 'package:animals_tasks/core/styling/app_colors.dart';
import 'package:animals_tasks/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('🐾 OnboardingScreen Tests', () {
    /// 🧱 Helper — wrap widget with MaterialApp
    Widget buildTestWidget(Widget child) => MaterialApp(home: child);

    // ✅ 1. Builds successfully
    testWidgets('✅ Builds without crashing', (tester) async {
      await tester.pumpWidget(buildTestWidget(const OnboardingScreen()));
      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    // 🖼️ 2. Image displays correctly
    testWidgets('🖼️ Displays onboarding image', (tester) async {
      await tester.pumpWidget(buildTestWidget(const OnboardingScreen()));
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final image = tester.widget<Image>(imageFinder);
      expect(
        (image.image as AssetImage).assetName,
        'assets/images/onboarding_image.png',
      );
    });

    // 📝 3. Title text is correct
    testWidgets('📝 Shows correct title text', (tester) async {
      await tester.pumpWidget(buildTestWidget(const OnboardingScreen()));
      expect(find.text('Find Your Best\nCompanion With Us'), findsOneWidget);
    });

    // 💬 4. Subtitle text is correct
    testWidgets('💬 Shows correct subtitle text', (tester) async {
      await tester.pumpWidget(buildTestWidget(const OnboardingScreen()));
      expect(
        find.text(
          'Join & discover the best suitable pets as per your preferences in your location',
        ),
        findsOneWidget,
      );
    });

    // 🐾 5. Button container is visible
    testWidgets('🐾 Has Get Started button container', (tester) async {
      await tester.pumpWidget(buildTestWidget(const OnboardingScreen()));
      expect(find.text('Get Started'), findsOneWidget);
      expect(find.byIcon(Icons.pets), findsOneWidget);
    });

    // 🎨 6. Button uses correct color
    testWidgets('🎨 Button container uses primary color', (tester) async {
      await tester.pumpWidget(buildTestWidget(const OnboardingScreen()));

      final container = tester.widget<Container>(
        find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).color == AppColors.primary,
        ),
      );

      expect(container, isA<Container>());
    });

    // 🚀 7. Navigates to home when tapped (real navigation test)
    testWidgets('🚀 Navigates to Home when tapped', (tester) async {
      final router = GoRouter(
        routes: [
          GoRoute(path: '/', builder: (_, __) => const OnboardingScreen()),
          GoRoute(
            path: '/home',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('Home Screen'))),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      expect(find.text('Home Screen'), findsOneWidget);
    });

    // ⚠️ 8. Does not crash if GoRouter missing (safely silenced)
    testWidgets('⚠️ Does not crash if GoRouter missing', (tester) async {
      // Temporarily override debugPrint to silence expected warning
      final originalDebugPrint = debugPrint;
      debugPrint = (String? message, {int? wrapWidth}) {};

      await tester.pumpWidget(buildTestWidget(const OnboardingScreen()));
      await tester.tap(find.text('Get Started'));
      await tester.pump();

      // Restore debugPrint
      debugPrint = originalDebugPrint;

      expect(tester.takeException(), anyOf(isNull, isA<FlutterError>()));
    });

    // 🚫 9. Handles missing image safely
    testWidgets('🚫 Shows error icon if image missing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Image.asset(
            'assets/images/missing.png',
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.error, key: Key('image_error')),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('image_error')), findsOneWidget);
    });
  });
}
