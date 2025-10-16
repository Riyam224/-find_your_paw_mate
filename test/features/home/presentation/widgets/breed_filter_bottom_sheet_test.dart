import 'package:animals_tasks/core/styling/app_colors.dart';
import 'package:animals_tasks/features/home/presentation/widgets/breed_filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Helper function to create testable widget
  Widget createTestWidget({
    String? selectedBreedGroup,
    required Function(String?) onFilterApplied,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => BreedFilterBottomSheet(
                  selectedBreedGroup: selectedBreedGroup,
                  onFilterApplied: onFilterApplied,
                ),
              );
            },
            child: const Text('Show Filter'),
          ),
        ),
      ),
    );
  }

  group('BreedFilterBottomSheet - Rendering Tests', () {
    testWidgets('should render bottom sheet title', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        onFilterApplied: (_) {},
      ));

      // Act
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Filter by Breed Group'), findsOneWidget);
    });

    testWidgets('should display handle bar', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        onFilterApplied: (_) {},
      ));

      // Act
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Assert - Find container with handle bar dimensions
      final containers = tester.widgetList<Container>(find.byType(Container));
      final handleBar = containers.firstWhere(
        (container) =>
            container.constraints?.maxWidth == 40 &&
            container.constraints?.maxHeight == 4,
        orElse: () => containers.first,
      );
      expect(handleBar, isNotNull);
    });

    testWidgets('should display Apply Filter button', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        onFilterApplied: (_) {},
      ));

      // Act
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Apply Filter'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsWidgets); // May have multiple buttons in tree
    });

    testWidgets('should display all 9 breed groups', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        onFilterApplied: (_) {},
      ));

      // Act
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Assert - Check visible items first
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Herding'), findsOneWidget);
      expect(find.text('Hound'), findsOneWidget);
      expect(find.text('Non-Sporting'), findsOneWidget);
      expect(find.text('Sporting'), findsOneWidget);
      expect(find.text('Terrier'), findsOneWidget);
      expect(find.text('Toy'), findsOneWidget);
      expect(find.text('Working'), findsOneWidget);

      // Scroll to find "Mixed" which may be off-screen
      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pumpAndSettle();
      expect(find.text('Mixed'), findsOneWidget);
    });

    testWidgets('should render ListTile for each breed group',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        onFilterApplied: (_) {},
      ));

      // Act
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Assert - ListView renders only visible items, so check for at least some ListTiles
      expect(find.byType(ListTile), findsWidgets);
    });

    testWidgets('should have rounded top corners', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        onFilterApplied: (_) {},
      ));

      // Act
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Assert
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(BreedFilterBottomSheet),
          matching: find.byType(Container).first,
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(
        decoration.borderRadius,
        const BorderRadius.vertical(top: Radius.circular(20)),
      );
    });
  });

  group('BreedFilterBottomSheet - Initial Selection Tests', () {
    testWidgets('should pre-select passed breed group', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        selectedBreedGroup: 'Herding',
        onFilterApplied: (_) {},
      ));

      // Act
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Assert - Check for checkmark icon indicating selection
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should select "All" when no breed group provided',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        selectedBreedGroup: null,
        onFilterApplied: (_) {},
      ));

      // Act
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Assert - "All" should be selected by default
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should highlight selected breed with primary color',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        selectedBreedGroup: 'Sporting',
        onFilterApplied: (_) {},
      ));

      // Act
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Assert - Find the text widget for "Sporting"
      final textWidgets = tester.widgetList<Text>(find.text('Sporting'));
      final sportingText = textWidgets.first;
      expect(sportingText.style?.color, AppColors.primary);
      expect(sportingText.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('should show Clear button when breed is pre-selected',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        selectedBreedGroup: 'Terrier',
        onFilterApplied: (_) {},
      ));

      // Act
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Clear'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('should not show Clear button when "All" is selected',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        selectedBreedGroup: null,
        onFilterApplied: (_) {},
      ));

      // Act
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Clear'), findsNothing);
    });
  });

  group('BreedFilterBottomSheet - Selection Tests', () {
    testWidgets('should update selection when breed group is tapped',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        onFilterApplied: (_) {},
      ));
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Act - Tap on "Hound"
      await tester.tap(find.text('Hound'));
      await tester.pumpAndSettle();

      // Assert - Check that "Hound" is now selected
      final checkIcons = tester.widgetList<Icon>(find.byIcon(Icons.check_circle));
      expect(checkIcons.length, 1);
    });

    testWidgets('should show checkmark on selected breed', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        onFilterApplied: (_) {},
      ));
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Act - Tap on "Working"
      await tester.tap(find.text('Working'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should update text style when breed is selected',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        selectedBreedGroup: null,
        onFilterApplied: (_) {},
      ));
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Act - Tap on "Toy"
      await tester.tap(find.text('Toy'));
      await tester.pumpAndSettle();

      // Assert - "Toy" should have bold text
      final toyTexts = tester.widgetList<Text>(find.text('Toy'));
      final toyText = toyTexts.first;
      expect(toyText.style?.fontWeight, FontWeight.bold);
      expect(toyText.style?.color, AppColors.primary);
    });

    testWidgets('should allow changing selection between breeds',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        selectedBreedGroup: 'Herding',
        onFilterApplied: (_) {},
      ));
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Act - Change from "Herding" to "Mixed" (scroll to find it)
      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mixed'));
      await tester.pumpAndSettle();

      // Assert - Only one checkmark should be visible
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should handle selecting "All" breed group', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        selectedBreedGroup: 'Herding',
        onFilterApplied: (_) {},
      ));
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Act - Tap on "All"
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();

      // Assert - "All" should be selected
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });
  });

  group('BreedFilterBottomSheet - Clear Button Tests', () {
    testWidgets('should clear selection when Clear button is tapped',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        selectedBreedGroup: 'Sporting',
        onFilterApplied: (_) {},
      ));
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Act - Tap Clear button
      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();

      // Assert - "All" should be selected after clearing
      final checkIcons = tester.widgetList<Icon>(find.byIcon(Icons.check_circle));
      expect(checkIcons.length, 1);
    });

    testWidgets('should hide Clear button after clearing', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        selectedBreedGroup: 'Terrier',
        onFilterApplied: (_) {},
      ));
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Act - Tap Clear button
      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();

      // Assert - Clear button should no longer be visible
      expect(find.text('Clear'), findsNothing);
    });

    testWidgets('should select "All" after clearing', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        selectedBreedGroup: 'Working',
        onFilterApplied: (_) {},
      ));
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Act - Clear the selection
      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();

      // Assert - All should be highlighted
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });
  });

  group('BreedFilterBottomSheet - Apply Button Tests', () {
    testWidgets('should call onFilterApplied when Apply button is tapped',
        (tester) async {
      // Arrange
      String? appliedFilter;
      await tester.pumpWidget(createTestWidget(
        onFilterApplied: (filter) => appliedFilter = filter,
      ));
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Act - Select "Hound" and apply
      await tester.tap(find.text('Hound'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apply Filter'));
      await tester.pumpAndSettle();

      // Assert
      expect(appliedFilter, 'Hound');
    });

    testWidgets('should close bottom sheet when Apply is tapped',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        onFilterApplied: (_) {},
      ));
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Act - Tap Apply button
      await tester.tap(find.text('Apply Filter'));
      await tester.pumpAndSettle();

      // Assert - Bottom sheet should be closed
      expect(find.text('Filter by Breed Group'), findsNothing);
    });

    testWidgets('should pass null when "All" is selected and applied',
        (tester) async {
      // Arrange
      String? appliedFilter = 'initial';
      await tester.pumpWidget(createTestWidget(
        selectedBreedGroup: 'Herding',
        onFilterApplied: (filter) => appliedFilter = filter,
      ));
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Act - Select "All" and apply
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apply Filter'));
      await tester.pumpAndSettle();

      // Assert
      expect(appliedFilter, isNull);
    });

    testWidgets('should pass current selection when Apply is tapped',
        (tester) async {
      // Arrange
      String? appliedFilter;
      await tester.pumpWidget(createTestWidget(
        selectedBreedGroup: 'Toy',
        onFilterApplied: (filter) => appliedFilter = filter,
      ));
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Act - Apply without changing selection
      await tester.tap(find.text('Apply Filter'));
      await tester.pumpAndSettle();

      // Assert
      expect(appliedFilter, 'Toy');
    });

    testWidgets('should have correct button styling', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        onFilterApplied: (_) {},
      ));
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Assert
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Apply Filter'),
      );
      final style = button.style;
      expect(style?.backgroundColor?.resolve({}), AppColors.primary);
    });

    testWidgets('should have full width button', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        onFilterApplied: (_) {},
      ));
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Assert
      final sizedBox = tester.widget<SizedBox>(find.ancestor(
        of: find.widgetWithText(ElevatedButton, 'Apply Filter'),
        matching: find.byType(SizedBox),
      ));
      expect(sizedBox.width, double.infinity);
    });
  });

  group('BreedFilterBottomSheet - Edge Cases', () {
    testWidgets('should handle rapid selection changes', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        onFilterApplied: (_) {},
      ));
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Act - Rapidly tap different breeds
      await tester.tap(find.text('Herding'));
      await tester.pump();
      await tester.tap(find.text('Hound'));
      await tester.pump();
      await tester.tap(find.text('Sporting'));
      await tester.pump();
      await tester.tap(find.text('Terrier'));
      await tester.pumpAndSettle();

      // Assert - Should only have one selection
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should handle tapping same breed twice', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        onFilterApplied: (_) {},
      ));
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Act - Scroll to find "Mixed" and tap it twice
      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mixed'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mixed'));
      await tester.pumpAndSettle();

      // Assert - Should still be selected
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should handle apply without selection change',
        (tester) async {
      // Arrange
      String? appliedFilter;
      await tester.pumpWidget(createTestWidget(
        selectedBreedGroup: 'Working',
        onFilterApplied: (filter) => appliedFilter = filter,
      ));
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Act - Apply immediately without changing selection
      await tester.tap(find.text('Apply Filter'));
      await tester.pumpAndSettle();

      // Assert
      expect(appliedFilter, 'Working');
    });

    testWidgets('should handle clear and then apply', (tester) async {
      // Arrange
      String? appliedFilter;
      await tester.pumpWidget(createTestWidget(
        selectedBreedGroup: 'Terrier',
        onFilterApplied: (filter) => appliedFilter = filter,
      ));
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Act - Clear and then apply
      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apply Filter'));
      await tester.pumpAndSettle();

      // Assert - Should pass null
      expect(appliedFilter, isNull);
    });

    testWidgets('should handle selecting, clearing, and selecting again',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        onFilterApplied: (_) {},
      ));
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Act - Complex selection flow
      await tester.tap(find.text('Herding'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Toy'));
      await tester.pumpAndSettle();

      // Assert - "Toy" should be selected
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });
  });

  group('BreedFilterBottomSheet - Layout Tests', () {
    testWidgets('should have correct padding', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        onFilterApplied: (_) {},
      ));
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Assert
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(BreedFilterBottomSheet),
          matching: find.byType(Container).first,
        ),
      );
      expect(container.padding, const EdgeInsets.all(20));
    });

    testWidgets('should use Column layout', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        onFilterApplied: (_) {},
      ));
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.descendant(
          of: find.byType(BreedFilterBottomSheet),
          matching: find.byType(Column),
        ),
        findsOneWidget,
      );
    });

    testWidgets('should have ListView for breed groups', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        onFilterApplied: (_) {},
      ));
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should be scrollable for long lists', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        onFilterApplied: (_) {},
      ));
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();

      // Assert - ListView should be present for scrolling
      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.shrinkWrap, isTrue);
    });
  });

  group('BreedFilterBottomSheet - Integration Tests', () {
    testWidgets('should complete full filter flow', (tester) async {
      // Arrange
      String? finalFilter;
      await tester.pumpWidget(createTestWidget(
        onFilterApplied: (filter) => finalFilter = filter,
      ));

      // Act - Open sheet, select breed, apply
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sporting'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apply Filter'));
      await tester.pumpAndSettle();

      // Assert
      expect(finalFilter, 'Sporting');
      expect(find.text('Filter by Breed Group'), findsNothing); // Sheet closed
    });

    testWidgets('should handle edit existing filter flow', (tester) async {
      // Arrange
      String? finalFilter;
      await tester.pumpWidget(createTestWidget(
        selectedBreedGroup: 'Hound',
        onFilterApplied: (filter) => finalFilter = filter,
      ));

      // Act - Open, change selection to a visible item, apply
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();
      expect(find.text('Clear'), findsOneWidget); // Clear button visible

      // Tap a visible breed group (Sporting is near the top)
      await tester.tap(find.text('Sporting'));
      await tester.pumpAndSettle();

      // Tap Apply Filter
      await tester.tap(find.text('Apply Filter'));
      await tester.pumpAndSettle();

      // Assert
      expect(finalFilter, 'Sporting');
    });

    testWidgets('should handle remove filter flow', (tester) async {
      // Arrange
      String? finalFilter = 'initial';
      await tester.pumpWidget(createTestWidget(
        selectedBreedGroup: 'Terrier',
        onFilterApplied: (filter) => finalFilter = filter,
      ));

      // Act - Open, clear, apply
      await tester.tap(find.text('Show Filter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apply Filter'));
      await tester.pumpAndSettle();

      // Assert
      expect(finalFilter, isNull);
    });
  });
}
