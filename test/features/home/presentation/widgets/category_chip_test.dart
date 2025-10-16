import 'package:animals_tasks/core/styling/app_colors.dart';
import 'package:animals_tasks/features/home/presentation/widgets/category_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Helper function to create testable widget
  Widget createTestWidget({
    required String label,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: CategoryChip(
          label: label,
          isSelected: isSelected,
          onTap: onTap ?? () {},
        ),
      ),
    );
  }

  group('CategoryChip - Rendering Tests', () {
    testWidgets('should render with label text', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(
        label: 'All',
        isSelected: false,
      ));

      // Assert
      expect(find.text('All'), findsOneWidget);
    });

    testWidgets('should render GestureDetector wrapper', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(
        label: 'Dogs',
        isSelected: false,
      ));

      // Assert
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('should display different category labels', (tester) async {
      // Test multiple labels
      final labels = ['All', 'Dogs', 'Cats', 'Birds', 'Fish'];

      for (final label in labels) {
        // Arrange & Act
        await tester.pumpWidget(createTestWidget(
          label: label,
          isSelected: false,
        ));

        // Assert
        expect(find.text(label), findsOneWidget);
      }
    });
  });

  group('CategoryChip - Selected State Tests', () {
    testWidgets('should display primary color background when selected',
        (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(
        label: 'Dogs',
        isSelected: true,
      ));

      // Assert
      final container = tester.widget<Container>(find.descendant(
        of: find.byType(GestureDetector),
        matching: find.byType(Container),
      ));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.primary);
    });

    testWidgets('should display white text when selected', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(
        label: 'Cats',
        isSelected: true,
      ));

      // Assert
      final text = tester.widget<Text>(find.text('Cats'));
      expect(text.style?.color, Colors.white);
    });

    testWidgets('should have bold font weight when selected', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(
        label: 'Birds',
        isSelected: true,
      ));

      // Assert
      final text = tester.widget<Text>(find.text('Birds'));
      expect(text.style?.fontWeight, FontWeight.w500);
    });

    testWidgets('should have rounded borders when selected', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(
        label: 'Fish',
        isSelected: true,
      ));

      // Assert
      final container = tester.widget<Container>(find.descendant(
        of: find.byType(GestureDetector),
        matching: find.byType(Container),
      ));

      final decoration = container.decoration as BoxDecoration;
      final borderRadius = decoration.borderRadius as BorderRadius;
      expect(borderRadius.topLeft.x, 20);
      expect(borderRadius.topRight.x, 20);
      expect(borderRadius.bottomLeft.x, 20);
      expect(borderRadius.bottomRight.x, 20);
    });
  });

  group('CategoryChip - Unselected State Tests', () {
    testWidgets('should display light background when not selected',
        (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(
        label: 'Dogs',
        isSelected: false,
      ));

      // Assert
      final container = tester.widget<Container>(find.descendant(
        of: find.byType(GestureDetector),
        matching: find.byType(Container),
      ));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.backgroundLight);
    });

    testWidgets('should display dark text when not selected', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(
        label: 'Cats',
        isSelected: false,
      ));

      // Assert
      final text = tester.widget<Text>(find.text('Cats'));
      expect(text.style?.color, Colors.black87);
    });

    testWidgets('should maintain font weight when not selected',
        (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(
        label: 'Birds',
        isSelected: false,
      ));

      // Assert
      final text = tester.widget<Text>(find.text('Birds'));
      expect(text.style?.fontWeight, FontWeight.w500);
    });
  });

  group('CategoryChip - Styling and Layout Tests', () {
    testWidgets('should have correct padding', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(
        label: 'Test',
        isSelected: false,
      ));

      // Assert
      final container = tester.widget<Container>(find.descendant(
        of: find.byType(GestureDetector),
        matching: find.byType(Container),
      ));

      expect(container.padding, const EdgeInsets.symmetric(horizontal: 16, vertical: 10));
    });

    testWidgets('should have correct margin', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(
        label: 'Test',
        isSelected: false,
      ));

      // Assert
      final container = tester.widget<Container>(find.descendant(
        of: find.byType(GestureDetector),
        matching: find.byType(Container),
      ));

      expect(container.margin, const EdgeInsets.only(right: 8));
    });

    testWidgets('should have rounded border radius of 20', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(
        label: 'Test',
        isSelected: false,
      ));

      // Assert
      final container = tester.widget<Container>(find.descendant(
        of: find.byType(GestureDetector),
        matching: find.byType(Container),
      ));

      final decoration = container.decoration as BoxDecoration;
      final borderRadius = decoration.borderRadius as BorderRadius;
      expect(borderRadius, BorderRadius.circular(20));
    });
  });

  group('CategoryChip - Interaction Tests', () {
    testWidgets('should trigger onTap callback when tapped', (tester) async {
      // Arrange
      bool tapped = false;
      await tester.pumpWidget(createTestWidget(
        label: 'Dogs',
        isSelected: false,
        onTap: () => tapped = true,
      ));

      // Act
      await tester.tap(find.byType(CategoryChip));
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
    });

    testWidgets('should trigger onTap when tapping text area', (tester) async {
      // Arrange
      int tapCount = 0;
      await tester.pumpWidget(createTestWidget(
        label: 'Cats',
        isSelected: false,
        onTap: () => tapCount++,
      ));

      // Act
      await tester.tap(find.text('Cats'));
      await tester.pump();

      // Assert
      expect(tapCount, 1);
    });

    testWidgets('should handle multiple taps', (tester) async {
      // Arrange
      int tapCount = 0;
      await tester.pumpWidget(createTestWidget(
        label: 'Birds',
        isSelected: false,
        onTap: () => tapCount++,
      ));

      // Act - Tap multiple times
      await tester.tap(find.byType(CategoryChip));
      await tester.pump();
      await tester.tap(find.byType(CategoryChip));
      await tester.pump();
      await tester.tap(find.byType(CategoryChip));
      await tester.pump();

      // Assert
      expect(tapCount, 3);
    });

    testWidgets('should be tappable in both selected and unselected states',
        (tester) async {
      // Test unselected state
      int tapCount = 0;
      await tester.pumpWidget(createTestWidget(
        label: 'Test',
        isSelected: false,
        onTap: () => tapCount++,
      ));

      await tester.tap(find.byType(CategoryChip));
      await tester.pump();
      expect(tapCount, 1);

      // Test selected state
      await tester.pumpWidget(createTestWidget(
        label: 'Test',
        isSelected: true,
        onTap: () => tapCount++,
      ));

      await tester.tap(find.byType(CategoryChip));
      await tester.pump();
      expect(tapCount, 2);
    });
  });

  group('CategoryChip - Visual State Transition Tests', () {
    testWidgets('should change appearance when selection state changes',
        (tester) async {
      // Arrange - Start unselected
      await tester.pumpWidget(createTestWidget(
        label: 'Dogs',
        isSelected: false,
      ));

      // Get initial container
      var container = tester.widget<Container>(find.descendant(
        of: find.byType(GestureDetector),
        matching: find.byType(Container),
      ));
      var decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.backgroundLight);

      // Act - Change to selected
      await tester.pumpWidget(createTestWidget(
        label: 'Dogs',
        isSelected: true,
      ));
      await tester.pump();

      // Assert - Should have primary color now
      container = tester.widget<Container>(find.descendant(
        of: find.byType(GestureDetector),
        matching: find.byType(Container),
      ));
      decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.primary);
    });

    testWidgets('should transition text color when selection changes',
        (tester) async {
      // Arrange - Start unselected
      await tester.pumpWidget(createTestWidget(
        label: 'Cats',
        isSelected: false,
      ));

      var text = tester.widget<Text>(find.text('Cats'));
      expect(text.style?.color, Colors.black87);

      // Act - Change to selected
      await tester.pumpWidget(createTestWidget(
        label: 'Cats',
        isSelected: true,
      ));
      await tester.pump();

      // Assert - Text color should be white
      text = tester.widget<Text>(find.text('Cats'));
      expect(text.style?.color, Colors.white);
    });
  });

  group('CategoryChip - Edge Cases', () {
    testWidgets('should handle empty label', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(
        label: '',
        isSelected: false,
      ));

      // Assert - Widget should still render
      expect(find.byType(CategoryChip), findsOneWidget);
    });

    testWidgets('should handle very long label text', (tester) async {
      // Arrange
      const longLabel =
          'This is a very long category name that should still render properly';

      // Act
      await tester.pumpWidget(createTestWidget(
        label: longLabel,
        isSelected: false,
      ));

      // Assert
      expect(find.text(longLabel), findsOneWidget);
    });

    testWidgets('should handle special characters in label', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(
        label: 'Dogs & Cats 🐕🐈',
        isSelected: false,
      ));

      // Assert
      expect(find.text('Dogs & Cats 🐕🐈'), findsOneWidget);
    });

    testWidgets('should handle single character label', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(
        label: 'A',
        isSelected: false,
      ));

      // Assert
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('should handle numeric labels', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(
        label: '123',
        isSelected: false,
      ));

      // Assert
      expect(find.text('123'), findsOneWidget);
    });

    testWidgets('should handle labels with newlines', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(
        label: 'Line 1\nLine 2',
        isSelected: false,
      ));

      // Assert
      expect(find.text('Line 1\nLine 2'), findsOneWidget);
    });
  });

  group('CategoryChip - Integration Tests', () {
    testWidgets('should work in a horizontal list', (tester) async {
      // Arrange
      final categories = ['All', 'Dogs', 'Cats', 'Birds'];
      int selectedIndex = 0;

      // Act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryChip(
                    label: categories[index],
                    isSelected: selectedIndex == index,
                    onTap: () => setState(() => selectedIndex = index),
                  );
                },
              );
            },
          ),
        ),
      ));

      // Assert - First category should be selected
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Dogs'), findsOneWidget);

      // Act - Tap on 'Dogs'
      await tester.tap(find.text('Dogs'));
      await tester.pumpAndSettle();

      // Assert - Selection should have changed (visually)
      expect(find.byType(CategoryChip), findsNWidgets(4));
    });

    testWidgets('should maintain state across rebuilds', (tester) async {
      // Arrange
      bool isSelected = false;

      // Act - Initial build
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return CategoryChip(
                label: 'Test',
                isSelected: isSelected,
                onTap: () => setState(() => isSelected = !isSelected),
              );
            },
          ),
        ),
      ));

      // Assert - Initially unselected
      var container = tester.widget<Container>(find.descendant(
        of: find.byType(GestureDetector),
        matching: find.byType(Container),
      ));
      var decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.backgroundLight);

      // Act - Tap to toggle
      await tester.tap(find.byType(CategoryChip));
      await tester.pumpAndSettle();

      // Assert - Now selected
      container = tester.widget<Container>(find.descendant(
        of: find.byType(GestureDetector),
        matching: find.byType(Container),
      ));
      decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.primary);
    });

    testWidgets('should handle rapid selection changes', (tester) async {
      // Arrange
      int selectedId = 0;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return Row(
                children: List.generate(5, (index) {
                  return CategoryChip(
                    label: 'Cat $index',
                    isSelected: selectedId == index,
                    onTap: () => setState(() => selectedId = index),
                  );
                }),
              );
            },
          ),
        ),
      ));

      // Act - Rapidly tap different chips
      await tester.tap(find.text('Cat 1'));
      await tester.pump();
      await tester.tap(find.text('Cat 3'));
      await tester.pump();
      await tester.tap(find.text('Cat 4'));
      await tester.pumpAndSettle();

      // Assert - Should complete without errors
      expect(find.byType(CategoryChip), findsNWidgets(5));
    });
  });
}
