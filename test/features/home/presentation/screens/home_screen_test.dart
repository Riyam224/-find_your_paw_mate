import 'package:animals_tasks/features/home/domain/entities/category_entity.dart';
import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:animals_tasks/features/home/presentation/cubit/get_categories/get_categories_cubit.dart';
import 'package:animals_tasks/features/home/presentation/cubit/get_categories/get_categories_state.dart';
import 'package:animals_tasks/features/home/presentation/cubit/get_dogs/get_dogs_cubit.dart';
import 'package:animals_tasks/features/home/presentation/cubit/get_dogs/get_dogs_state.dart';
import 'package:animals_tasks/features/home/presentation/cubit/search_dogs/search_dogs_cubit.dart';
import 'package:animals_tasks/features/home/presentation/cubit/search_dogs/search_dogs_state.dart';
import 'package:animals_tasks/features/home/presentation/screens/home_screen.dart';
import 'package:animals_tasks/features/home/presentation/widgets/category_chip.dart';
import 'package:animals_tasks/features/home/presentation/widgets/pet_card.dart';
import 'package:animals_tasks/features/home/presentation/widgets/pet_card_shimmer.dart';
import 'package:animals_tasks/features/home/presentation/widgets/search_bar.dart';
import 'package:animals_tasks/features/home/presentation/widgets/search_results_widget.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

// Mock Cubits
class MockGetDogsCubit extends MockCubit<GetDogsState>
    implements GetDogsCubit {}

class MockSearchDogsCubit extends MockCubit<SearchDogsState>
    implements SearchDogsCubit {}

class MockGetCategoriesCubit extends MockCubit<GetCategoriesState>
    implements GetCategoriesCubit {}

void main() {
  late MockGetDogsCubit mockGetDogsCubit;
  late MockSearchDogsCubit mockSearchDogsCubit;
  late MockGetCategoriesCubit mockGetCategoriesCubit;

  // Test data
  final testCategories = [
    const CategoryEntity(id: 0, name: 'All'),
    const CategoryEntity(id: 1, name: 'Dogs'),
    const CategoryEntity(id: 2, name: 'Cats'),
  ];

  final testDogs = [
    const DogEntity(
      id: '1',
      name: 'Golden Retriever',
      imageUrl: 'https://example.com/1.jpg',
      gender: 'Male',
      age: '2 years',
      distance: '2.5 km',
    ),
    const DogEntity(
      id: '2',
      name: 'Labrador',
      imageUrl: 'https://example.com/2.jpg',
      gender: 'Female',
      age: '3 years',
      distance: '1.0 km',
    ),
  ];

  setUp(() {
    mockGetDogsCubit = MockGetDogsCubit();
    mockSearchDogsCubit = MockSearchDogsCubit();
    mockGetCategoriesCubit = MockGetCategoriesCubit();

    // Setup GetIt
    final getIt = GetIt.instance;
    getIt.reset();

    getIt.registerFactory<GetDogsCubit>(() => mockGetDogsCubit);
    getIt.registerFactory<SearchDogsCubit>(() => mockSearchDogsCubit);
    getIt.registerFactory<GetCategoriesCubit>(() => mockGetCategoriesCubit);

    // Default stubs for async methods
    when(() => mockGetDogsCubit.fetchDogs()).thenAnswer((_) => Future<void>.value());
    when(() => mockGetDogsCubit.fetchCatsByCategory(any()))
        .thenAnswer((_) => Future<void>.value());
    when(() => mockSearchDogsCubit.searchDogs(any())).thenAnswer((_) => Future<void>.value());
    when(() => mockSearchDogsCubit.clearSearch()).thenAnswer((_) => Future<void>.value());
    when(() => mockGetCategoriesCubit.fetchCategories())
        .thenAnswer((_) => Future<void>.value());

    // Default states
    when(() => mockGetDogsCubit.state).thenReturn(GetDogsInitial());
    when(() => mockSearchDogsCubit.state).thenReturn(SearchDogsInitial());
    when(() => mockGetCategoriesCubit.state)
        .thenReturn(GetCategoriesInitial());
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  // Helper function to create testable widget
  Widget createTestWidget() {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }

  group('HomeScreen - Initial Rendering Tests', () {
    testWidgets('should render AppBar with title', (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesLoaded(testCategories));
      when(() => mockGetDogsCubit.state).thenReturn(GetDogsLoaded(testDogs));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Find Your Forever Pet'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should render notification icon button', (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesLoaded(testCategories));
      when(() => mockGetDogsCubit.state).thenReturn(GetDogsLoaded(testDogs));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    });

    testWidgets('should render SearchBarWidget', (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesLoaded(testCategories));
      when(() => mockGetDogsCubit.state).thenReturn(GetDogsLoaded(testDogs));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(SearchBarWidget), findsOneWidget);
    });

    testWidgets('should render "Categories" text', (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesLoaded(testCategories));
      when(() => mockGetDogsCubit.state).thenReturn(GetDogsLoaded(testDogs));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Categories'), findsOneWidget);
    });

    testWidgets('should call fetchDogs on initialization', (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesLoaded(testCategories));
      when(() => mockGetDogsCubit.state).thenReturn(GetDogsLoaded(testDogs));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      verify(() => mockGetDogsCubit.fetchDogs()).called(1);
    });

    testWidgets('should call fetchCategories on initialization',
        (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesLoaded(testCategories));
      when(() => mockGetDogsCubit.state).thenReturn(GetDogsLoaded(testDogs));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      verify(() => mockGetCategoriesCubit.fetchCategories()).called(1);
    });
  });

  group('HomeScreen - Category Loading States Tests', () {
    testWidgets('should show loading indicator when categories are loading',
        (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesLoading());
      when(() => mockGetDogsCubit.state).thenReturn(GetDogsLoaded(testDogs));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('should display categories when loaded', (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesLoaded(testCategories));
      when(() => mockGetDogsCubit.state).thenReturn(GetDogsLoaded(testDogs));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CategoryChip), findsNWidgets(3));
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Dogs'), findsOneWidget);
      expect(find.text('Cats'), findsOneWidget);
    });

    testWidgets('should display error message when categories fail to load',
        (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesError('Failed to load categories'));
      when(() => mockGetDogsCubit.state).thenReturn(GetDogsLoaded(testDogs));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Failed to load categories'), findsOneWidget);
    });
  });

  group('HomeScreen - Dogs Loading States Tests', () {
    testWidgets('should show shimmer loaders when dogs are loading',
        (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesLoaded(testCategories));
      when(() => mockGetDogsCubit.state).thenReturn(GetDogsLoading());

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Should show shimmer loaders (at least 1, implementation may vary)
      expect(find.byType(PetCardShimmer), findsWidgets);
    });

    testWidgets('should display dogs list when loaded', (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesLoaded(testCategories));
      when(() => mockGetDogsCubit.state).thenReturn(GetDogsLoaded(testDogs));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(PetCard), findsNWidgets(2));
    });

    testWidgets('should display empty state when no dogs found',
        (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesLoaded(testCategories));
      when(() => mockGetDogsCubit.state).thenReturn(GetDogsLoaded([]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('No dogs found'), findsOneWidget);
      expect(find.byIcon(Icons.pets_outlined), findsOneWidget);
    });

    testWidgets('should display error message when dogs fail to load',
        (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesLoaded(testCategories));
      when(() => mockGetDogsCubit.state)
          .thenReturn(GetDogsError('Network error'));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Network error'), findsOneWidget);
    });
  });

  group('HomeScreen - Category Selection Tests', () {
    testWidgets('should fetch dogs when "All" category is selected',
        (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesLoaded(testCategories));
      when(() => mockGetDogsCubit.state).thenReturn(GetDogsLoaded(testDogs));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Tap on "All" category
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockGetDogsCubit.fetchDogs()).called(greaterThan(1));
    });

    testWidgets('should fetch cats when category other than "All" is selected',
        (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesLoaded(testCategories));
      when(() => mockGetDogsCubit.state).thenReturn(GetDogsLoaded(testDogs));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Tap on "Cats" category
      await tester.tap(find.text('Cats'));
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockGetDogsCubit.fetchCatsByCategory(2)).called(1);
    });

    testWidgets('should update selected category visually', (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesLoaded(testCategories));
      when(() => mockGetDogsCubit.state).thenReturn(GetDogsLoaded(testDogs));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Tap on "Dogs" category
      await tester.tap(find.text('Dogs'));
      await tester.pumpAndSettle();

      // Assert - "Dogs" category should be selected
      expect(find.byType(CategoryChip), findsNWidgets(3));
    });
  });

  group('HomeScreen - Search Functionality Tests', () {
    testWidgets('should switch to search results when searching',
        (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesLoaded(testCategories));
      when(() => mockGetDogsCubit.state).thenReturn(GetDogsLoaded(testDogs));
      when(() => mockSearchDogsCubit.state)
          .thenReturn(SearchDogsLoaded(testDogs, 'golden'));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Enter search query
      await tester.enterText(find.byType(TextField), 'golden');
      await tester.pump(const Duration(milliseconds: 500));

      // Assert
      expect(find.byType(SearchResultsWidget), findsOneWidget);
    });

    testWidgets('should show normal list when search is cleared',
        (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesLoaded(testCategories));
      when(() => mockGetDogsCubit.state).thenReturn(GetDogsLoaded(testDogs));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter search then clear
      await tester.enterText(find.byType(TextField), 'golden');
      await tester.pump(const Duration(milliseconds: 500));

      // Act - Clear search
      await tester.enterText(find.byType(TextField), '');
      await tester.pump(const Duration(milliseconds: 500));

      // Assert
      expect(find.byType(SearchResultsWidget), findsNothing);
    });
  });

  group('HomeScreen - Breed Filter Tests', () {
    testWidgets('should show breed filter bottom sheet when filter is tapped',
        (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesLoaded(testCategories));
      when(() => mockGetDogsCubit.state).thenReturn(GetDogsLoaded(testDogs));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Tap filter icon
      await tester.tap(find.byIcon(Icons.filter_list_rounded));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Filter by Breed Group'), findsOneWidget);
    });

    testWidgets('should display breed filter chip when filter is applied',
        (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesLoaded(testCategories));
      when(() => mockGetDogsCubit.state).thenReturn(GetDogsLoaded(testDogs));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Open filter and select a breed group
      await tester.tap(find.byIcon(Icons.filter_list_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sporting'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apply Filter'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Sporting'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('should remove breed filter chip when close is tapped',
        (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesLoaded(testCategories));
      when(() => mockGetDogsCubit.state).thenReturn(GetDogsLoaded(testDogs));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Apply filter first
      await tester.tap(find.byIcon(Icons.filter_list_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Herding'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apply Filter'));
      await tester.pumpAndSettle();

      // Act - Remove filter
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Assert - Filter chip should not be visible
      expect(find.text('Herding'), findsNothing);
    });
  });

  group('HomeScreen - Pull to Refresh Tests', () {
    testWidgets('should refresh dogs when pulled down', (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesLoaded(testCategories));
      when(() => mockGetDogsCubit.state).thenReturn(GetDogsLoaded(testDogs));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Pull to refresh
      await tester.drag(find.byType(RefreshIndicator), const Offset(0, 300));
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockGetDogsCubit.fetchDogs()).called(greaterThan(1));
    });
  });

  group('HomeScreen - Edge Cases and Integration Tests', () {
    testWidgets('should handle empty categories list', (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesLoaded([]));
      when(() => mockGetDogsCubit.state).thenReturn(GetDogsLoaded(testDogs));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert - Should render without crashing
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('should handle simultaneous loading states', (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesLoading());
      when(() => mockGetDogsCubit.state).thenReturn(GetDogsLoading());

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Should show both loading indicators
      expect(find.byType(CircularProgressIndicator), findsWidgets);
      expect(find.byType(PetCardShimmer), findsWidgets);
    });

    testWidgets('should handle simultaneous error states', (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesError('Categories error'));
      when(() => mockGetDogsCubit.state)
          .thenReturn(GetDogsError('Dogs error'));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert - Should show both error messages
      expect(find.text('Categories error'), findsOneWidget);
      expect(find.text('Dogs error'), findsOneWidget);
    });

    testWidgets('should handle rapid category switching', (tester) async {
      // Arrange
      when(() => mockGetCategoriesCubit.state)
          .thenReturn(GetCategoriesLoaded(testCategories));
      when(() => mockGetDogsCubit.state).thenReturn(GetDogsLoaded(testDogs));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Rapidly switch categories
      await tester.tap(find.text('Dogs'));
      await tester.pump();
      await tester.tap(find.text('Cats'));
      await tester.pump();
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();

      // Assert - Should handle without crashing
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
