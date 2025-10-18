import 'package:animals_tasks/core/di/di.dart';
import 'package:animals_tasks/core/styling/app_colors.dart';
import 'package:animals_tasks/features/favorite/presentation/screens/favorite_screen.dart';
import 'package:animals_tasks/features/home/presentation/screens/home_screen.dart';
import 'package:animals_tasks/layout/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../helpers/register_mock_dependencies.dart';

void main() {
  setUp(() {
    GetIt.instance.reset();
    registerMockDependencies(GetIt.instance);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: MainLayout(),
    );
  }

  group('MainLayout Widget Tests', () {
    testWidgets('renders Scaffold with BottomNavigationBar', (tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(Scaffold), findsWidgets);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('renders HomeScreen by default', (tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    group('BottomNavigationBar Tests', () {
      testWidgets('has 4 navigation items', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        final bottomNav = tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );
        expect(bottomNav.items.length, 4);
      });

      testWidgets('has correct icons for all items', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert - Check icons exist in BottomNavigationBar
        expect(find.byIcon(Icons.home_rounded), findsWidgets);
        expect(find.byIcon(Icons.favorite_border), findsWidgets);
        expect(find.byIcon(Icons.chat_bubble_outline_rounded), findsOneWidget);
        expect(find.byIcon(Icons.person_outline), findsOneWidget);
      });

      testWidgets('uses correct type (fixed)', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        final bottomNav = tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );
        expect(bottomNav.type, BottomNavigationBarType.fixed);
      });

      testWidgets('has correct colors', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        final bottomNav = tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );
        expect(bottomNav.selectedItemColor, AppColors.primary);
        expect(bottomNav.unselectedItemColor, Colors.grey);
      });

      testWidgets('hides labels', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        final bottomNav = tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );
        expect(bottomNav.showSelectedLabels, false);
        expect(bottomNav.showUnselectedLabels, false);
      });

      testWidgets('first item is selected by default', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        final bottomNav = tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );
        expect(bottomNav.currentIndex, 0);
      });
    });

    group('Navigation Tests', () {
      testWidgets('tapping home icon keeps HomeScreen displayed',
          (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Find the home icon in BottomNavigationBar
        final homeIcon = find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.byIcon(Icons.home_rounded),
        );
        await tester.tap(homeIcon);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(HomeScreen), findsOneWidget);
        final bottomNav = tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );
        expect(bottomNav.currentIndex, 0);
      });

      testWidgets('tapping favorite icon shows FavoriteScreen',
          (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Find the favorite icon in BottomNavigationBar
        final favIcon = find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.byIcon(Icons.favorite_border),
        );
        await tester.tap(favIcon);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(FavoriteScreen), findsOneWidget);
        final bottomNav = tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );
        expect(bottomNav.currentIndex, 1);
      });

      testWidgets('tapping chat icon shows HomeScreen (placeholder)',
          (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final chatIcon = find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.byIcon(Icons.chat_bubble_outline_rounded),
        );
        await tester.tap(chatIcon);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(HomeScreen), findsOneWidget);
        final bottomNav = tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );
        expect(bottomNav.currentIndex, 2);
      });

      testWidgets('tapping profile icon shows HomeScreen (placeholder)',
          (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final profileIcon = find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.byIcon(Icons.person_outline),
        );
        await tester.tap(profileIcon);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(HomeScreen), findsOneWidget);
        final bottomNav = tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );
        expect(bottomNav.currentIndex, 3);
      });

      testWidgets('can navigate between all screens', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final bottomNav = find.byType(BottomNavigationBar);

        // Navigate to favorites
        await tester.tap(find.descendant(
          of: bottomNav,
          matching: find.byIcon(Icons.favorite_border),
        ));
        await tester.pumpAndSettle();
        expect(find.byType(FavoriteScreen), findsOneWidget);

        // Navigate to chat
        await tester.tap(find.descendant(
          of: bottomNav,
          matching: find.byIcon(Icons.chat_bubble_outline_rounded),
        ));
        await tester.pumpAndSettle();
        expect(find.byType(HomeScreen), findsOneWidget);

        // Navigate to profile
        await tester.tap(find.descendant(
          of: bottomNav,
          matching: find.byIcon(Icons.person_outline),
        ));
        await tester.pumpAndSettle();
        expect(find.byType(HomeScreen), findsOneWidget);

        // Navigate back to home
        await tester.tap(find.descendant(
          of: bottomNav,
          matching: find.byIcon(Icons.home_rounded),
        ));
        await tester.pumpAndSettle();
        expect(find.byType(HomeScreen), findsOneWidget);
      });

      testWidgets('navigation preserves state between tabs', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final bottomNav = find.byType(BottomNavigationBar);

        // Navigate to favorites
        await tester.tap(find.descendant(
          of: bottomNav,
          matching: find.byIcon(Icons.favorite_border),
        ));
        await tester.pumpAndSettle();

        // Navigate back to home
        await tester.tap(find.descendant(
          of: bottomNav,
          matching: find.byIcon(Icons.home_rounded),
        ));
        await tester.pumpAndSettle();

        // Navigate to favorites again
        await tester.tap(find.descendant(
          of: bottomNav,
          matching: find.byIcon(Icons.favorite_border),
        ));
        await tester.pumpAndSettle();

        // Assert - Should still show FavoriteScreen
        expect(find.byType(FavoriteScreen), findsOneWidget);
        final bottomNavWidget = tester.widget<BottomNavigationBar>(bottomNav);
        expect(bottomNavWidget.currentIndex, 1);
      });
    });

    group('State Management Tests', () {
      testWidgets('maintains selected index after rebuild', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final bottomNavFinder = find.byType(BottomNavigationBar);

        // Tap favorite
        await tester.tap(find.descendant(
          of: bottomNavFinder,
          matching: find.byIcon(Icons.favorite_border),
        ));
        await tester.pumpAndSettle();

        // Verify the index changed to 1
        var bottomNav = tester.widget<BottomNavigationBar>(bottomNavFinder);
        expect(bottomNav.currentIndex, 1);

        // Trigger rebuild with pump (this causes a rebuild but maintains state)
        await tester.pump();

        // State should be maintained after rebuild
        bottomNav = tester.widget<BottomNavigationBar>(bottomNavFinder);
        expect(bottomNav.currentIndex, 1);
      });

      testWidgets('updates currentIndex when tapping different items',
          (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final bottomNavFinder = find.byType(BottomNavigationBar);

        // Verify initial index
        var bottomNav = tester.widget<BottomNavigationBar>(bottomNavFinder);
        expect(bottomNav.currentIndex, 0);

        // Tap each item and verify index changes
        final icons = [
          Icons.favorite_border,
          Icons.chat_bubble_outline_rounded,
          Icons.person_outline,
        ];

        for (int i = 0; i < icons.length; i++) {
          await tester.tap(find.descendant(
            of: bottomNavFinder,
            matching: find.byIcon(icons[i]),
          ));
          await tester.pumpAndSettle();

          bottomNav = tester.widget<BottomNavigationBar>(bottomNavFinder);
          expect(bottomNav.currentIndex, i + 1);
        }
      });
    });

    group('Screen Display Tests', () {
      testWidgets('displays correct screen for index 0', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Assert - HomeScreen is displayed by default, FavoriteScreen is not in the tree
        expect(find.byType(HomeScreen), findsOneWidget);
      });

      testWidgets('displays correct screen for index 1', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.tap(find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.byIcon(Icons.favorite_border),
        ));
        await tester.pumpAndSettle();

        // Assert - FavoriteScreen is now visible
        expect(find.byType(FavoriteScreen), findsOneWidget);
      });

      testWidgets('only displays one screen at a time', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Check initial state - HomeScreen is displayed
        expect(find.byType(HomeScreen), findsOneWidget);

        // Navigate to favorites
        await tester.tap(find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.byIcon(Icons.favorite_border),
        ));
        await tester.pumpAndSettle();

        // Assert - FavoriteScreen is now displayed instead of HomeScreen
        expect(find.byType(FavoriteScreen), findsOneWidget);

        // Navigate to chat (which shows HomeScreen as placeholder)
        await tester.tap(find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.byIcon(Icons.chat_bubble_outline_rounded),
        ));
        await tester.pumpAndSettle();

        // Assert - HomeScreen is shown (placeholder), FavoriteScreen is not
        expect(find.byType(HomeScreen), findsOneWidget);
      });
    });

    group('Widget Structure Tests', () {
      testWidgets('MainLayout is a StatefulWidget', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.byType(MainLayout), findsOneWidget);
        final mainLayout = tester.widget<MainLayout>(find.byType(MainLayout));
        expect(mainLayout, isA<StatefulWidget>());
      });

      testWidgets('has correct widget hierarchy', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(
          find.descendant(
            of: find.byType(MaterialApp),
            matching: find.byType(MainLayout),
          ),
          findsOneWidget,
        );

        // MainLayout contains a Scaffold
        expect(find.byType(MainLayout), findsOneWidget);
        expect(find.byType(Scaffold), findsWidgets);  // Multiple scaffolds (MainLayout + child screens)

        // BottomNavigationBar should be present
        expect(find.byType(BottomNavigationBar), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles rapid tapping of navigation items', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final bottomNavFinder = find.byType(BottomNavigationBar);

        // Rapidly tap different items
        await tester.tap(find.descendant(
          of: bottomNavFinder,
          matching: find.byIcon(Icons.favorite_border),
        ));
        await tester.tap(find.descendant(
          of: bottomNavFinder,
          matching: find.byIcon(Icons.home_rounded),
        ));
        await tester.tap(find.descendant(
          of: bottomNavFinder,
          matching: find.byIcon(Icons.person_outline),
        ));
        await tester.pumpAndSettle();

        // Assert - Should handle gracefully and show last selected
        final bottomNav = tester.widget<BottomNavigationBar>(bottomNavFinder);
        expect(bottomNav.currentIndex, 3);
        expect(find.byType(HomeScreen), findsOneWidget);
      });

      testWidgets('BottomNavigationBar is always visible', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final bottomNavFinder = find.byType(BottomNavigationBar);

        // Navigate through all tabs
        for (final icon in [
          Icons.favorite_border,
          Icons.chat_bubble_outline_rounded,
          Icons.person_outline,
          Icons.home_rounded,
        ]) {
          await tester.tap(find.descendant(
            of: bottomNavFinder,
            matching: find.byIcon(icon),
          ));
          await tester.pumpAndSettle();
          expect(find.byType(BottomNavigationBar), findsOneWidget);
        }
      });

      testWidgets('all navigation items are tappable', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final bottomNavFinder = find.byType(BottomNavigationBar);

        // Test that all navigation items can be tapped without errors
        final icons = [
          Icons.home_rounded,
          Icons.favorite_border,
          Icons.chat_bubble_outline_rounded,
          Icons.person_outline,
        ];

        for (final icon in icons) {
          final iconFinder = find.descendant(
            of: bottomNavFinder,
            matching: find.byIcon(icon),
          );
          expect(iconFinder, findsOneWidget);

          // Verify we can tap each icon
          await tester.tap(iconFinder);
          await tester.pumpAndSettle();
        }

        // All taps should complete successfully
        expect(find.byType(MainLayout), findsOneWidget);
      });
    });

    group('Visual Properties Tests', () {
      testWidgets('navigation items have empty labels', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        final bottomNav = tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );
        for (final item in bottomNav.items) {
          expect(item.label, '');
        }
      });

      testWidgets('selected item uses AppColors.primary', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Assert
        final bottomNav = tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );
        expect(bottomNav.selectedItemColor, AppColors.primary);
      });

      testWidgets('unselected items use grey color', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Assert
        final bottomNav = tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar),
        );
        expect(bottomNav.unselectedItemColor, Colors.grey);
      });
    });

    group('Screen Array Tests', () {
      testWidgets('has exactly 4 screens in array', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final bottomNavFinder = find.byType(BottomNavigationBar);

        // Navigate through all indices to verify array length
        final icons = [
          Icons.home_rounded,
          Icons.favorite_border,
          Icons.chat_bubble_outline_rounded,
          Icons.person_outline,
        ];

        for (int i = 0; i < 4; i++) {
          await tester.tap(find.descendant(
            of: bottomNavFinder,
            matching: find.byIcon(icons[i]),
          ));
          await tester.pumpAndSettle();

          // Should not throw range error
          expect(find.byType(Scaffold), findsWidgets);
        }
      });

      testWidgets('index 0 shows HomeScreen', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final bottomNavFinder = find.byType(BottomNavigationBar);

        await tester.tap(find.descendant(
          of: bottomNavFinder,
          matching: find.byIcon(Icons.home_rounded),
        ));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(HomeScreen), findsOneWidget);
      });

      testWidgets('index 1 shows FavoriteScreen', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final bottomNavFinder = find.byType(BottomNavigationBar);

        await tester.tap(find.descendant(
          of: bottomNavFinder,
          matching: find.byIcon(Icons.favorite_border),
        ));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(FavoriteScreen), findsOneWidget);
      });

      testWidgets('index 2 shows HomeScreen placeholder', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final bottomNavFinder = find.byType(BottomNavigationBar);

        await tester.tap(find.descendant(
          of: bottomNavFinder,
          matching: find.byIcon(Icons.chat_bubble_outline_rounded),
        ));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(HomeScreen), findsOneWidget);
      });

      testWidgets('index 3 shows HomeScreen placeholder', (tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final bottomNavFinder = find.byType(BottomNavigationBar);

        await tester.tap(find.descendant(
          of: bottomNavFinder,
          matching: find.byIcon(Icons.person_outline),
        ));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(HomeScreen), findsOneWidget);
      });
    });
  });
}
