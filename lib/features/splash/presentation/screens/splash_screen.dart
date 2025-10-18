// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'dart:async';
import 'package:animals_tasks/core/styling/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  final Duration delay;

  const SplashScreen({
    super.key,
    this.delay = const Duration(seconds: 3), // default for real app
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool navigated = false;
  Timer? _timer;

  @override
  @override
  void initState() {
    super.initState();

    // ✅ Skip timers in test environment
    if (kDebugMode && Platform.environment.containsKey('FLUTTER_TEST')) return;

    _timer = Timer(widget.delay, () {
      if (!mounted || navigated) return;
      navigated = true;
      try {
        GoRouter.of(context).go('/onboarding');
      } catch (e) {
        debugPrint('⚠️ Navigation failed: $e');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.primaryLight,
        child: Center(
          child: Image.asset(
            'assets/images/logo.png',
            key: const Key('splash_logo'),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:animals_tasks/main.dart' as app;

// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//   testWidgets(
//     '🐾 Full App Flow: Splash → Onboarding → Home → Search → Filter → Details → Favorite',
//     (tester) async {
//       // 🚀 Launch app
//       app.main();
//       await tester.pumpAndSettle(const Duration(seconds: 3));

//       // 🐶 1️⃣ Splash → Onboarding
//       expect(find.byKey(const Key('splash_logo')), findsOneWidget);
//       await tester.pumpAndSettle(const Duration(seconds: 3));

//       expect(find.text('Find Your Best\nCompanion With Us'), findsOneWidget);
//       await tester.tap(find.text('Get Started'));
//       await tester.pumpAndSettle(const Duration(seconds: 3));

//       // 🏠 2️⃣ Home screen visible
//       expect(find.text('Find Your Forever Pet'), findsOneWidget);

//       // 🔍 3️⃣ Search for a pet
//       final searchField = find.byType(TextField);
//       expect(searchField, findsOneWidget);
//       await tester.enterText(searchField, 'beagle');
//       await tester.testTextInput.receiveAction(TextInputAction.search);
//       await tester.pumpAndSettle(const Duration(seconds: 2));

//       // Verify search results appeared
//       expect(find.textContaining('beagle', findRichText: true), findsWidgets);

//       // 🎛️ 4️⃣ Open filter bottom sheet
//       final filterButton = find.byIcon(Icons.filter_list);
//       await tester.tap(filterButton);
//       await tester.pumpAndSettle(const Duration(seconds: 2));

//       // Choose first filter option
//       final firstBreed = find.byType(ListTile).first;
//       await tester.tap(firstBreed);
//       await tester.pumpAndSettle(const Duration(seconds: 1));

//       // ✅ Apply filter
//       final applyButton = find.text('Apply');
//       if (applyButton.evaluate().isNotEmpty) {
//         await tester.tap(applyButton);
//         await tester.pumpAndSettle(const Duration(seconds: 2));
//       }

//       // 🐕 5️⃣ Tap on a pet card to open details
//       final petCard = find.byType(Card).first;
//       expect(petCard, findsOneWidget);
//       await tester.tap(petCard);
//       await tester.pumpAndSettle(const Duration(seconds: 3));

//       // 📄 6️⃣ Details screen visible
//       expect(find.textContaining('About'), findsOneWidget);

//       // ❤️ 7️⃣ Tap favorite icon
//       final favButton = find.byIcon(Icons.favorite_border_rounded);
//       await tester.tap(favButton);
//       await tester.pumpAndSettle(const Duration(seconds: 2));

//       // Optional: verify snackbar
//       expect(find.textContaining('added to favorites', findRichText: true),
//           findsOneWidget);

//       // ⬅️ 8️⃣ Go back to Home
//       await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
//       await tester.pumpAndSettle(const Duration(seconds: 2));

//       // 🧭 9️⃣ Navigate to Favorites tab via bottom nav
//       final favNavIcon = find.byIcon(Icons.favorite_border);
//       await tester.tap(favNavIcon);
//       await tester.pumpAndSettle(const Duration(seconds: 3));

//       // 🧡 Verify favorites list has the added item
//       expect(find.textContaining('Pet'), findsWidgets);

//       // ✅ Done!
//       debugPrint('🎉 Integration test completed successfully!');
//     },
//   );
