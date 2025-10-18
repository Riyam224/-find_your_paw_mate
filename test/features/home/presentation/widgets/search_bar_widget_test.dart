import 'package:animals_tasks/features/home/presentation/cubit/search_dogs/search_dogs_cubit.dart';
import 'package:animals_tasks/features/home/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock SearchDogsCubit
class MockSearchDogsCubit extends Mock implements SearchDogsCubit {}

void main() {
  late MockSearchDogsCubit mockSearchDogsCubit;

  setUp(() {
    mockSearchDogsCubit = MockSearchDogsCubit();
    // Stub the stream and close methods required by BlocProvider
    when(() => mockSearchDogsCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockSearchDogsCubit.close()).thenAnswer((_) => Future<void>.value());
    // Stub async methods
    when(() => mockSearchDogsCubit.searchDogs(any())).thenAnswer((_) => Future<void>.value());
    when(() => mockSearchDogsCubit.clearSearch()).thenAnswer((_) => Future<void>.value());
  });

  // Helper function to create testable widget with BlocProvider
  Widget createTestWidget({
    Function(String)? onSearch,
    VoidCallback? onFilterTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<SearchDogsCubit>(
          create: (_) => mockSearchDogsCubit,
          child: SearchBarWidget(
            onSearch: onSearch,
            onFilterTap: onFilterTap,
          ),
        ),
      ),
    );
  }

  group('SearchBarWidget - Rendering Tests', () {
    testWidgets('should render TextField with search icon', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should display hint text "Search breeds..."', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Search breeds...'), findsOneWidget);
    });

    testWidgets('should show filter icon when text field is empty',
        (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byIcon(Icons.filter_list_rounded), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('should have correct styling and decoration', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.filled, isTrue);
      expect(textField.decoration?.hintText, 'Search breeds...');
      expect(textField.decoration?.prefixIcon, isNotNull);
    });
  });

  group('SearchBarWidget - Text Input Tests', () {
    testWidgets('should accept text input', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      await tester.enterText(find.byType(TextField), 'Golden Retriever');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(); // Complete debounce timer

      // Assert
      expect(find.text('Golden Retriever'), findsOneWidget);
    });

    testWidgets('should show clear button when text is entered',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      await tester.enterText(find.byType(TextField), 'Beagle');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(); // Complete debounce timer

      // Assert
      expect(find.byIcon(Icons.clear), findsOneWidget);
      expect(find.byIcon(Icons.filter_list_rounded), findsNothing);
    });

    testWidgets('should hide filter button when text is present',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act - Enter text
      await tester.enterText(find.byType(TextField), 'Poodle');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(); // Complete debounce timer

      // Assert
      expect(find.byIcon(Icons.filter_list_rounded), findsNothing);
    });
  });

  group('SearchBarWidget - Search Functionality Tests', () {
    testWidgets('should trigger onSearch callback after debounce delay',
        (tester) async {
      // Arrange
      String? searchQuery;
      await tester.pumpWidget(createTestWidget(
        onSearch: (query) => searchQuery = query,
      ));

      // Act - Enter text and wait for debounce
      await tester.enterText(find.byType(TextField), 'Labrador');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();

      // Assert - Wait for debounce
      expect(searchQuery, 'Labrador');
    });

    testWidgets('should call SearchDogsCubit.searchDogs after debounce',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      await tester.enterText(find.byType(TextField), 'Husky');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();

      // Assert
      verify(() => mockSearchDogsCubit.searchDogs('Husky')).called(1);
    });

    testWidgets('should not trigger search before debounce delay',
        (tester) async {
      // Arrange
      String? searchQuery;
      await tester.pumpWidget(createTestWidget(
        onSearch: (query) => searchQuery = query,
      ));

      // Act - Enter text and pump for less than debounce time
      await tester.enterText(find.byType(TextField), 'Bulldog');
      await tester.pump(const Duration(milliseconds: 300));

      // Assert - Should not have triggered yet
      expect(searchQuery, isNull);

      // Clean up - wait for pending timer to complete
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump();
    });

    testWidgets('should handle multiple rapid text changes (debouncing)',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act - Rapid typing
      await tester.enterText(find.byType(TextField), 'G');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(find.byType(TextField), 'Go');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(find.byType(TextField), 'Gol');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(find.byType(TextField), 'Gold');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();

      // Assert - Should only call once with final text
      verify(() => mockSearchDogsCubit.searchDogs('Gold')).called(1);
    });

    testWidgets('should handle empty query by calling clearSearch',
        (tester) async {
      // Arrange
      String? searchQuery;
      await tester.pumpWidget(createTestWidget(
        onSearch: (query) => searchQuery = query,
      ));

      // First enter some text
      await tester.enterText(find.byType(TextField), 'Test');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();

      // Act - Clear the text by entering empty string
      await tester.enterText(find.byType(TextField), '');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();

      // Assert
      verify(() => mockSearchDogsCubit.clearSearch()).called(1);
      expect(searchQuery, '');
    });
  });

  group('SearchBarWidget - Clear Button Tests', () {
    testWidgets('should clear text when clear button is tapped',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(find.byType(TextField), 'Corgi');
      await tester.pumpAndSettle();

      // Act - Tap clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Corgi'), findsNothing);
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('should call clearSearch when clear button is tapped',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(find.byType(TextField), 'Terrier');
      await tester.pumpAndSettle();

      // Act - Tap clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockSearchDogsCubit.clearSearch()).called(1);
    });

    testWidgets('should trigger onSearch with empty string when cleared',
        (tester) async {
      // Arrange
      String? searchQuery = 'initial';
      await tester.pumpWidget(createTestWidget(
        onSearch: (query) => searchQuery = query,
      ));
      await tester.enterText(find.byType(TextField), 'Dachshund');
      await tester.pumpAndSettle();

      // Act - Tap clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      // Assert
      expect(searchQuery, '');
    });

    testWidgets('should show filter button again after clearing',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(find.byType(TextField), 'Boxer');
      await tester.pumpAndSettle();

      // Act - Clear text
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.filter_list_rounded), findsOneWidget);
    });
  });

  group('SearchBarWidget - Filter Button Tests', () {
    testWidgets('should trigger onFilterTap when filter button is tapped',
        (tester) async {
      // Arrange
      bool filterTapped = false;
      await tester.pumpWidget(createTestWidget(
        onFilterTap: () => filterTapped = true,
      ));

      // Act
      await tester.tap(find.byIcon(Icons.filter_list_rounded));
      await tester.pump();

      // Assert
      expect(filterTapped, isTrue);
    });

    testWidgets('should not throw error if onFilterTap is null',
        (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(onFilterTap: null));
      await tester.tap(find.byIcon(Icons.filter_list_rounded));
      await tester.pump();

      // Assert - No error thrown
      expect(find.byType(SearchBarWidget), findsOneWidget);
    });
  });

  group('SearchBarWidget - Edge Cases', () {
    testWidgets('should handle special characters in search query',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      await tester.enterText(find.byType(TextField), 'Dog-Mix #123!');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();

      // Assert
      verify(() => mockSearchDogsCubit.searchDogs('Dog-Mix #123!')).called(1);
    });

    testWidgets('should handle very long text input', (tester) async {
      // Arrange
      const longText =
          'This is a very long search query that someone might type when looking for a very specific breed of dog with many characteristics';
      await tester.pumpWidget(createTestWidget());

      // Act
      await tester.enterText(find.byType(TextField), longText);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();

      // Assert
      verify(() => mockSearchDogsCubit.searchDogs(longText)).called(1);
    });

    testWidgets('should handle whitespace-only input', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      await tester.enterText(find.byType(TextField), '   ');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();

      // Assert
      verify(() => mockSearchDogsCubit.searchDogs('   ')).called(1);
    });

    testWidgets('should handle rapid clear and re-type', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act - Type, clear, type again
      await tester.enterText(find.byType(TextField), 'First');
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Second');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();

      // Assert
      verify(() => mockSearchDogsCubit.clearSearch()).called(1);
      verify(() => mockSearchDogsCubit.searchDogs('Second')).called(1);
    });

    testWidgets('should handle null callbacks gracefully', (tester) async {
      // Arrange & Act - Create widget with null callbacks
      await tester.pumpWidget(createTestWidget(
        onSearch: null,
        onFilterTap: null,
      ));

      // Act - Interact with widget
      await tester.enterText(find.byType(TextField), 'Test');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();

      // Assert - No errors thrown
      expect(find.byType(SearchBarWidget), findsOneWidget);
    });

    testWidgets('should dispose controller properly', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(find.byType(TextField), 'Disposal Test');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(); // Complete debounce timer

      // Act - Dispose widget by pumping empty widget
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));

      // Assert - No errors should occur during disposal
      expect(find.byType(SearchBarWidget), findsNothing);
    });
  });

  group('SearchBarWidget - Integration Tests', () {
    testWidgets('should complete full search flow', (tester) async {
      // Arrange
      String? latestQuery;
      await tester.pumpWidget(createTestWidget(
        onSearch: (query) => latestQuery = query,
      ));

      // Act - Full flow: type, wait for debounce, then tap clear
      await tester.enterText(find.byType(TextField), 'Shiba Inu');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(); // Process debounce callback
      expect(latestQuery, 'Shiba Inu');

      // Tap clear button (should be visible now due to controller listener)
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      // Assert
      expect(latestQuery, '');
      verify(() => mockSearchDogsCubit.searchDogs('Shiba Inu')).called(1);
      verify(() => mockSearchDogsCubit.clearSearch()).called(1);
    });

    testWidgets('should switch between search and filter modes correctly',
        (tester) async {
      // Arrange
      bool filterTapped = false;
      await tester.pumpWidget(createTestWidget(
        onFilterTap: () => filterTapped = true,
      ));

      // Act - Start with filter
      await tester.tap(find.byIcon(Icons.filter_list_rounded));
      await tester.pumpAndSettle();
      expect(filterTapped, isTrue);

      // Type to switch to clear button
      await tester.enterText(find.byType(TextField), 'Pug');
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.clear), findsOneWidget);

      // Clear to switch back to filter
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.filter_list_rounded), findsOneWidget);
    });
  });
}
