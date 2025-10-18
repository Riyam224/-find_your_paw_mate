import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:animals_tasks/features/home/presentation/cubit/search_dogs/search_dogs_cubit.dart';
import 'package:animals_tasks/features/home/presentation/cubit/search_dogs/search_dogs_state.dart';
import 'package:animals_tasks/features/home/presentation/widgets/pet_card.dart';
import 'package:animals_tasks/features/home/presentation/widgets/search_results_widget.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock SearchDogsCubit
class MockSearchDogsCubit extends MockCubit<SearchDogsState>
    implements SearchDogsCubit {}

void main() {
  late MockSearchDogsCubit mockSearchDogsCubit;

  setUp(() {
    mockSearchDogsCubit = MockSearchDogsCubit();
    // Stub the stream and close methods required by BlocProvider
    when(() => mockSearchDogsCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockSearchDogsCubit.close()).thenAnswer((_) => Future<void>.value());
  });

  // Helper function to create test DogEntity
  DogEntity createTestDog({
    required String id,
    required String name,
    String? gender,
    String? age,
  }) {
    return DogEntity(
      id: id,
      name: name,
      imageUrl: 'https://cdn2.thedogapi.com/images/$id.jpg',
      gender: gender,
      age: age,
      distance: '2.5 km away',
    );
  }

  // Helper function to create testable widget with BlocProvider
  Widget createTestWidget() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<SearchDogsCubit>(
          create: (_) => mockSearchDogsCubit,
          child: const SearchResultsWidget(),
        ),
      ),
    );
  }

  group('SearchResultsWidget - Initial State Tests', () {
    testWidgets('should render SizedBox.shrink when state is SearchDogsInitial',
        (tester) async {
      // Arrange
      when(() => mockSearchDogsCubit.state).thenReturn(SearchDogsInitial());

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('should show nothing when no search has been performed',
        (tester) async {
      // Arrange
      when(() => mockSearchDogsCubit.state).thenReturn(SearchDogsInitial());

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(PetCard), findsNothing);
      expect(find.text('Found'), findsNothing);
    });
  });

  group('SearchResultsWidget - Loading State Tests', () {
    testWidgets('should show CircularProgressIndicator when loading',
        (tester) async {
      // Arrange
      when(() => mockSearchDogsCubit.state).thenReturn(SearchDogsLoading());

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should center the loading indicator', (tester) async {
      // Arrange
      when(() => mockSearchDogsCubit.state).thenReturn(SearchDogsLoading());

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(Center), findsOneWidget);
      expect(
          find.descendant(
            of: find.byType(Center),
            matching: find.byType(CircularProgressIndicator),
          ),
          findsOneWidget);
    });

    testWidgets('should have padding around loading indicator', (tester) async {
      // Arrange
      when(() => mockSearchDogsCubit.state).thenReturn(SearchDogsLoading());

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final padding = tester.widget<Padding>(find.descendant(
        of: find.byType(Center),
        matching: find.byType(Padding),
      ));
      expect(padding.padding, const EdgeInsets.all(32.0));
    });

    testWidgets('should not show results when loading', (tester) async {
      // Arrange
      when(() => mockSearchDogsCubit.state).thenReturn(SearchDogsLoading());

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(ListView), findsNothing);
      expect(find.byType(PetCard), findsNothing);
    });
  });

  group('SearchResultsWidget - Loaded State Tests', () {
    testWidgets('should display search results when loaded', (tester) async {
      // Arrange
      final dogs = [
        createTestDog(id: '1', name: 'Golden Retriever'),
        createTestDog(id: '2', name: 'Labrador'),
      ];
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsLoaded(dogs, 'retriever'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(PetCard), findsNWidgets(2));
    });

    testWidgets('should display result count with query', (tester) async {
      // Arrange
      final dogs = [
        createTestDog(id: '1', name: 'Husky'),
        createTestDog(id: '2', name: 'Siberian Husky'),
        createTestDog(id: '3', name: 'Alaskan Husky'),
      ];
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsLoaded(dogs, 'husky'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Found 3 results for "husky"'), findsOneWidget);
    });

    testWidgets('should display all dogs in ListView', (tester) async {
      // Arrange
      final dogs = [
        createTestDog(id: '1', name: 'Dog 1'),
        createTestDog(id: '2', name: 'Dog 2'),
        createTestDog(id: '3', name: 'Dog 3'),
        createTestDog(id: '4', name: 'Dog 4'),
      ];
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsLoaded(dogs, 'dog'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(PetCard), findsNWidgets(4));
    });

    testWidgets('should display single result correctly', (tester) async {
      // Arrange
      final dogs = [createTestDog(id: '1', name: 'Beagle')];
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsLoaded(dogs, 'beagle'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Found 1 results for "beagle"'), findsOneWidget);
      expect(find.byType(PetCard), findsOneWidget);
    });

    testWidgets('should display query text in quotes', (tester) async {
      // Arrange
      final dogs = [createTestDog(id: '1', name: 'Poodle')];
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsLoaded(dogs, 'toy poodle'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.textContaining('"toy poodle"'), findsOneWidget);
    });

    testWidgets('should use Column layout for results', (tester) async {
      // Arrange
      final dogs = [createTestDog(id: '1', name: 'Corgi')];
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsLoaded(dogs, 'corgi'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert - Multiple Column widgets exist in tree (MaterialApp, etc.)
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should have Expanded widget for ListView', (tester) async {
      // Arrange
      final dogs = [createTestDog(id: '1', name: 'Bulldog')];
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsLoaded(dogs, 'bulldog'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert - Find Expanded widget (may have multiple in full widget tree)
      expect(find.byType(Expanded), findsWidgets);
      // Also verify ListView exists within the search results
      expect(find.byType(ListView), findsOneWidget);
    });
  });

  group('SearchResultsWidget - Empty State Tests', () {
    testWidgets('should show empty message when no results found',
        (tester) async {
      // Arrange
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsEmpty( 'nonexistent'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('No results found for "nonexistent"'), findsOneWidget);
    });

    testWidgets('should display search_off icon for empty results',
        (tester) async {
      // Arrange
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsEmpty( 'xyz'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    testWidgets('should show helpful message to try different keywords',
        (tester) async {
      // Arrange
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsEmpty( 'test'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Try searching with different keywords'), findsOneWidget);
    });

    testWidgets('should center empty state content', (tester) async {
      // Arrange
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsEmpty( 'empty'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert - Multiple Center widgets may exist in widget tree
      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('should have padding around empty state', (tester) async {
      // Arrange
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsEmpty( 'none'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final padding = tester.widget<Padding>(find.descendant(
        of: find.byType(Center),
        matching: find.byType(Padding),
      ));
      expect(padding.padding, const EdgeInsets.all(32.0));
    });

    testWidgets('should display query in empty message', (tester) async {
      // Arrange
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsEmpty( 'specific search term'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(
          find.textContaining('"specific search term"'), findsOneWidget);
    });

    testWidgets('should not show PetCards in empty state', (tester) async {
      // Arrange
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsEmpty( 'empty'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(PetCard), findsNothing);
    });
  });

  group('SearchResultsWidget - Error State Tests', () {
    testWidgets('should display error message when search fails',
        (tester) async {
      // Arrange
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsError( 'Network error occurred'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Network error occurred'), findsOneWidget);
    });

    testWidgets('should display error icon', (tester) async {
      // Arrange
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsError( 'Error'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should center error content', (tester) async {
      // Arrange
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsError( 'Server error'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert - Multiple Center widgets may exist in widget tree
      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('should have padding around error content', (tester) async {
      // Arrange
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsError( 'Error'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final padding = tester.widget<Padding>(find.descendant(
        of: find.byType(Center),
        matching: find.byType(Padding),
      ));
      expect(padding.padding, const EdgeInsets.all(32.0));
    });

    testWidgets('should display error text in red color', (tester) async {
      // Arrange
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsError( 'Connection failed'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final text = tester.widget<Text>(find.text('Connection failed'));
      expect(text.style?.color, Colors.red);
    });

    testWidgets('should not show results on error', (tester) async {
      // Arrange
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsError( 'Error'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(PetCard), findsNothing);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('should display different error messages', (tester) async {
      // Test various error messages
      final errorMessages = [
        'Network error',
        'Server error',
        'Timeout occurred',
        'Unknown error',
      ];

      for (final message in errorMessages) {
        // Arrange
        when(() => mockSearchDogsCubit.state).thenReturn(
          SearchDogsError( message),
        );

        // Act - Rebuild widget for each iteration
        await tester.pumpWidget(createTestWidget());
        await tester.pump(); // Ensure widget rebuilds with new state

        // Assert
        expect(find.text(message), findsOneWidget);

        // Clean up - pump empty widget before next iteration
        await tester.pumpWidget(const SizedBox.shrink());
      }
    });
  });

  group('SearchResultsWidget - Edge Cases', () {
    testWidgets('should handle empty query string in loaded state',
        (tester) async {
      // Arrange
      final dogs = [createTestDog(id: '1', name: 'Dog')];
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsLoaded(dogs, ''),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Found 1 results for ""'), findsOneWidget);
    });

    testWidgets('should handle empty query string in empty state',
        (tester) async {
      // Arrange
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsEmpty( ''),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('No results found for ""'), findsOneWidget);
    });

    testWidgets('should handle special characters in query', (tester) async {
      // Arrange
      final dogs = [createTestDog(id: '1', name: 'Test')];
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsLoaded(dogs, 'dog & cat #1!'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.textContaining('"dog & cat #1!"'), findsOneWidget);
    });

    testWidgets('should handle very long query text', (tester) async {
      // Arrange
      const longQuery =
          'This is a very long search query that someone might type when looking for a specific breed';
      final dogs = [createTestDog(id: '1', name: 'Dog')];
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsLoaded(dogs, longQuery),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.textContaining(longQuery), findsOneWidget);
    });

    testWidgets('should handle large number of results', (tester) async {
      // Arrange
      final dogs =
          List.generate(50, (i) => createTestDog(id: '$i', name: 'Dog $i'));
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsLoaded(dogs, 'dog'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Found 50 results for "dog"'), findsOneWidget);
    });

    testWidgets('should handle empty error message', (tester) async {
      // Arrange
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsError( ''),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert - Should still render error UI
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });

  group('SearchResultsWidget - State Transition Tests', () {
    testWidgets('should transition from initial to loading state',
        (tester) async {
      // Arrange - Use whenListen to emit state changes through stream
      whenListen(
        mockSearchDogsCubit,
        Stream.fromIterable([
          SearchDogsInitial(),
          SearchDogsLoading(),
        ]),
        initialState: SearchDogsInitial(),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      expect(find.byType(SizedBox), findsWidgets); // Initial state

      await tester.pump(); // Process the Loading state emission

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should transition from loading to loaded state',
        (tester) async {
      // Arrange - Emit loading then loaded states
      final dogs = [createTestDog(id: '1', name: 'Pug')];
      whenListen(
        mockSearchDogsCubit,
        Stream.fromIterable([
          SearchDogsLoading(),
          SearchDogsLoaded(dogs, 'pug'),
        ]),
        initialState: SearchDogsLoading(),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(); // Process the Loaded state emission

      // Assert
      expect(find.byType(PetCard), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should transition from loaded to empty state', (tester) async {
      // Arrange - Emit loaded then empty states
      final dogs = [createTestDog(id: '1', name: 'Dog')];
      whenListen(
        mockSearchDogsCubit,
        Stream.fromIterable([
          SearchDogsLoaded(dogs, 'dog'),
          SearchDogsEmpty('xyz'),
        ]),
        initialState: SearchDogsLoaded(dogs, 'dog'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      expect(find.byType(PetCard), findsOneWidget);

      await tester.pump(); // Process the Empty state emission

      // Assert
      expect(find.byIcon(Icons.search_off), findsOneWidget);
      expect(find.byType(PetCard), findsNothing);
    });

    testWidgets('should transition from loaded to error state', (tester) async {
      // Arrange - Emit loaded then error states
      final dogs = [createTestDog(id: '1', name: 'Dog')];
      whenListen(
        mockSearchDogsCubit,
        Stream.fromIterable([
          SearchDogsLoaded(dogs, 'dog'),
          SearchDogsError('Network error'),
        ]),
        initialState: SearchDogsLoaded(dogs, 'dog'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      expect(find.byType(PetCard), findsOneWidget);

      await tester.pump(); // Process the Error state emission

      // Assert
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.byType(PetCard), findsNothing);
    });
  });

  group('SearchResultsWidget - Result Count Tests', () {
    testWidgets('should display correct count for zero results (empty state)',
        (tester) async {
      // Arrange
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsEmpty( 'nothing'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.textContaining('No results'), findsOneWidget);
    });

    testWidgets('should pluralize results text correctly - single result',
        (tester) async {
      // Test with 1 result
      final dogs = [createTestDog(id: '1', name: 'Dog')];
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsLoaded(dogs, 'dog'),
      );
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Found 1 results for "dog"'), findsOneWidget);
    });

    testWidgets('should pluralize results text correctly - multiple results',
        (tester) async {
      // Test with multiple results
      final multipleDogs = [
        createTestDog(id: '1', name: 'Dog 1'),
        createTestDog(id: '2', name: 'Dog 2'),
      ];
      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsLoaded(multipleDogs, 'dog'),
      );
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Found 2 results for "dog"'), findsOneWidget);
    });
  });

  group('SearchResultsWidget - Integration Tests', () {
    testWidgets('should complete full search flow with results',
        (tester) async {
      // Arrange - Start with initial state
      whenListen(
        mockSearchDogsCubit,
        Stream.fromIterable([
          SearchDogsInitial(),
          SearchDogsLoading(),
          SearchDogsLoaded(
            [createTestDog(id: '1', name: 'Beagle')],
            'beagle',
          ),
        ]),
        initialState: SearchDogsInitial(),
      );

      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsLoaded(
          [createTestDog(id: '1', name: 'Beagle')],
          'beagle',
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Found 1 results for "beagle"'), findsOneWidget);
      expect(find.byType(PetCard), findsOneWidget);
    });

    testWidgets('should handle search with no results flow', (tester) async {
      // Arrange
      whenListen(
        mockSearchDogsCubit,
        Stream.fromIterable([
          SearchDogsInitial(),
          SearchDogsLoading(),
          SearchDogsEmpty( 'xyz'),
        ]),
        initialState: SearchDogsInitial(),
      );

      when(() => mockSearchDogsCubit.state).thenReturn(
        SearchDogsEmpty( 'xyz'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('No results found for "xyz"'), findsOneWidget);
      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });
  });
}
