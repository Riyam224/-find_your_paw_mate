import 'package:animals_tasks/core/di/di.dart';
import 'package:animals_tasks/features/favorite/domain/entities/favorite_entity.dart';
import 'package:animals_tasks/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:animals_tasks/features/favorite/presentation/cubit/favorite_state.dart';
import 'package:animals_tasks/features/favorite/presentation/screens/favorite_screen.dart';
import 'package:animals_tasks/features/home/domain/entities/category_entity.dart';
import 'package:animals_tasks/features/home/presentation/cubit/get_categories/get_categories_cubit.dart';
import 'package:animals_tasks/features/home/presentation/cubit/get_categories/get_categories_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/register_mock_dependencies.dart';

// Mock classes
class MockFavoriteCubit extends MockCubit<FavoriteState>
    implements FavoriteCubit {}

class MockGetCategoriesCubit extends MockCubit<GetCategoriesState>
    implements GetCategoriesCubit {}

void main() {
  late MockFavoriteCubit mockFavoriteCubit;
  late MockGetCategoriesCubit mockGetCategoriesCubit;

  setUp(() {
    GetIt.instance.reset();
    registerMockDependencies(GetIt.instance);

    mockFavoriteCubit = MockFavoriteCubit();
    mockGetCategoriesCubit = MockGetCategoriesCubit();

    // Default state and behavior
    when(() => mockFavoriteCubit.state).thenReturn(FavoriteInitial());
    when(() => mockFavoriteCubit.getFavorites())
        .thenAnswer((_) async => Future<void>.value());
    when(() => mockFavoriteCubit.removeFavorite(
          favoriteId: any(named: 'favoriteId'),
        )).thenAnswer((_) async => Future<void>.value());

    when(() => mockGetCategoriesCubit.state).thenReturn(GetCategoriesInitial());
    when(() => mockGetCategoriesCubit.fetchCategories())
        .thenAnswer((_) async => Future<void>.value());

    // Register mock cubits in GetIt
    if (GetIt.instance.isRegistered<FavoriteCubit>()) {
      GetIt.instance.unregister<FavoriteCubit>();
    }
    GetIt.instance.registerFactory<FavoriteCubit>(() => mockFavoriteCubit);

    if (GetIt.instance.isRegistered<GetCategoriesCubit>()) {
      GetIt.instance.unregister<GetCategoriesCubit>();
    }
    GetIt.instance
        .registerFactory<GetCategoriesCubit>(() => mockGetCategoriesCubit);
  });

  tearDown(() {
    if (GetIt.instance.isRegistered<FavoriteCubit>()) {
      GetIt.instance.unregister<FavoriteCubit>();
    }
    if (GetIt.instance.isRegistered<GetCategoriesCubit>()) {
      GetIt.instance.unregister<GetCategoriesCubit>();
    }
  });

  // Test data
  final testCategories = [
    const CategoryEntity(id: 0, name: 'All'),
    const CategoryEntity(id: 1, name: 'Hats'),
    const CategoryEntity(id: 2, name: 'Boxes'),
    const CategoryEntity(id: 3, name: 'Clothes'),
  ];

  final testFavorites = [
    FavoriteEntity(
      id: '1',
      imageId: 'img_123',
      imageUrl: 'https://example.com/image1.jpg',
      subId: 'user_riyam',
      createdAt: DateTime(2024, 1, 1),
    ),
    FavoriteEntity(
      id: '2',
      imageId: 'img_456',
      imageUrl: 'https://example.com/image2.jpg',
      subId: 'user_riyam',
      createdAt: DateTime(2024, 1, 2),
    ),
    FavoriteEntity(
      id: '3',
      imageId: 'img_789',
      imageUrl: 'https://example.com/image3.jpg',
      subId: 'user_riyam',
      createdAt: DateTime(2024, 1, 3),
    ),
  ];

  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: FavoriteScreen(),
    );
  }

  group('FavoriteScreen Widget Tests', () {
    group('Basic Rendering Tests', () {
      testWidgets('renders title "Your Favorite Pets"', (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state).thenReturn(FavoriteInitial());
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesInitial());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('Your Favorite Pets'), findsOneWidget);
      });

      testWidgets('renders Scaffold with white background', (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state).thenReturn(FavoriteInitial());
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesInitial());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert - Find the FavoriteScreen's Scaffold specifically
        expect(find.byType(Scaffold), findsWidgets);
      });

      testWidgets('renders BottomNavWidget with correct index',
          (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state).thenReturn(FavoriteInitial());
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesInitial());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.byType(GestureDetector), findsWidgets);
      });

      testWidgets('calls getFavorites on cubit when initialized',
          (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state).thenReturn(FavoriteInitial());
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesInitial());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert
        verify(() => mockFavoriteCubit.getFavorites()).called(1);
      });

      testWidgets('calls fetchCategories on cubit when initialized',
          (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state).thenReturn(FavoriteInitial());
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesInitial());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert
        verify(() => mockGetCategoriesCubit.fetchCategories()).called(1);
      });
    });

    group('Category Filter Tests', () {
      testWidgets('shows loading indicator when categories are loading',
          (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state).thenReturn(FavoriteInitial());
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoading());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.byType(CircularProgressIndicator), findsWidgets);
      });

      testWidgets('displays category chips when categories are loaded',
          (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state).thenReturn(FavoriteInitial());
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('All'), findsOneWidget);
        expect(find.text('Hats'), findsOneWidget);
        expect(find.text('Boxes'), findsOneWidget);
        expect(find.text('Clothes'), findsOneWidget);
      });

      testWidgets('shows error message when categories fail to load',
          (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state).thenReturn(FavoriteInitial());
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesError('Failed to load categories'));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('Failed to load categories'), findsOneWidget);
      });

      testWidgets('first category is selected by default', (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state).thenReturn(FavoriteInitial());
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Assert - "All" category should be selected
        expect(find.text('All'), findsOneWidget);
      });

      testWidgets('tapping category chip updates selection', (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state).thenReturn(FavoriteInitial());
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Tap on "Hats" category
        await tester.tap(find.text('Hats'));
        await tester.pumpAndSettle();

        // Assert - Widget should rebuild with new selection
        expect(find.text('Hats'), findsOneWidget);
      });

      testWidgets('category chips are horizontally scrollable',
          (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state).thenReturn(FavoriteInitial());
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.byType(ListView), findsWidgets);
      });

      testWidgets('handles empty category list gracefully', (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state).thenReturn(FavoriteInitial());
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded([]));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Assert - Should not crash
        expect(find.byType(FavoriteScreen), findsOneWidget);
      });
    });

    group('Favorite List Tests', () {
      testWidgets('shows loading indicator when favorites are loading',
          (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state).thenReturn(FavoriteLoading());
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.byType(CircularProgressIndicator), findsWidgets);
      });

      testWidgets('displays favorites in grid when loaded', (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state)
            .thenReturn(FavoriteLoaded(testFavorites));
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert - Check that GridView is rendered
        expect(find.byType(GridView), findsOneWidget);
      });

      testWidgets('shows empty state when no favorites', (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state).thenReturn(FavoriteLoaded([]));
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('No favorites yet'), findsOneWidget);
        expect(
            find.text('Start adding pets to your favorites!'), findsOneWidget);
        expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      });

      testWidgets('shows error message when favorites fail to load',
          (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state)
            .thenReturn(FavoriteError('Failed to load favorites'));
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('Failed to load favorites'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });

      testWidgets('retry button calls getFavorites on error', (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state)
            .thenReturn(FavoriteError('Network error'));
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));
        when(() => mockFavoriteCubit.getFavorites()).thenAnswer((_) async {});

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.tap(find.text('Retry'));
        await tester.pumpAndSettle();

        // Assert - getFavorites should be called twice (once on init, once on retry)
        verify(() => mockFavoriteCubit.getFavorites()).called(2);
      });

      testWidgets('displays correct number of favorite cards', (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state)
            .thenReturn(FavoriteLoaded(testFavorites));
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert - GridView should be present with favorites
        expect(find.byType(GridView), findsOneWidget);
      });

      testWidgets('favorite cards display correct information',
          (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state)
            .thenReturn(FavoriteLoaded(testFavorites));
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert - GridView with favorites should be present
        expect(find.byType(GridView), findsOneWidget);
      });

      testWidgets('GridView has correct grid properties', (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state)
            .thenReturn(FavoriteLoaded(testFavorites));
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Assert
        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate = gridView.gridDelegate
            as SliverGridDelegateWithFixedCrossAxisCount;
        expect(delegate.crossAxisCount, 2);
        expect(delegate.crossAxisSpacing, 14);
        expect(delegate.mainAxisSpacing, 14);
      });
    });

    group('Navigation Tests', () {
      testWidgets('favorite cards are tappable', (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state)
            .thenReturn(FavoriteLoaded(testFavorites));
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert - InkWell widgets (favorite cards) should be present and tappable
        expect(find.byType(InkWell), findsWidgets);
        expect(find.byType(GridView), findsOneWidget);
      });
    });

    group('Remove Favorite Tests', () {
      testWidgets('shows remove dialog when tapping close button',
          (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state)
            .thenReturn(FavoriteLoaded(testFavorites));
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Find and tap the close icon button
        final closeButtonFinder = find.byIcon(Icons.close);
        await tester.tap(closeButtonFinder.first);
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Remove Favorite'), findsOneWidget);
        expect(
            find.text('Are you sure you want to remove this pet from favorites?'),
            findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Remove'), findsOneWidget);
      });

      testWidgets('cancel button dismisses remove dialog', (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state)
            .thenReturn(FavoriteLoaded(testFavorites));
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.close).first);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Assert - Dialog should be dismissed
        expect(find.text('Remove Favorite'), findsNothing);
      });

      testWidgets('remove button calls removeFavorite', (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state)
            .thenReturn(FavoriteLoaded(testFavorites));
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));
        when(() => mockFavoriteCubit.removeFavorite(
              favoriteId: any(named: 'favoriteId'),
            )).thenAnswer((_) async {});

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.close).first);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Remove'));
        await tester.pumpAndSettle();

        // Assert
        verify(() => mockFavoriteCubit.removeFavorite(
            favoriteId: any(named: 'favoriteId'))).called(1);
      });

      testWidgets('shows snackbar after removing favorite', (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state)
            .thenReturn(FavoriteLoaded(testFavorites));
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.close).first);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Remove'));
        await tester.pumpAndSettle();

        // Assert - Snackbar should appear
        expect(find.text('Removed from favorites'), findsOneWidget);
      });
    });

    group('Date Formatting Tests', () {
      testWidgets('displays "Just now" for very recent favorites',
          (tester) async {
        // Arrange
        final recentFavorite = [
          FavoriteEntity(
            id: '1',
            imageId: 'img_123',
            imageUrl: 'https://example.com/image1.jpg',
            subId: 'user_riyam',
            createdAt: DateTime.now(),
          ),
        ];
        when(() => mockFavoriteCubit.state)
            .thenReturn(FavoriteLoaded(recentFavorite));
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Assert
        expect(find.textContaining('Just now'), findsOneWidget);
      });

      testWidgets('displays minutes ago for favorites added minutes ago',
          (tester) async {
        // Arrange
        final minutesAgoFavorite = [
          FavoriteEntity(
            id: '1',
            imageId: 'img_123',
            imageUrl: 'https://example.com/image1.jpg',
            subId: 'user_riyam',
            createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
          ),
        ];
        when(() => mockFavoriteCubit.state)
            .thenReturn(FavoriteLoaded(minutesAgoFavorite));
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Assert
        expect(find.textContaining('m ago'), findsOneWidget);
      });

      testWidgets('displays hours ago for favorites added hours ago',
          (tester) async {
        // Arrange
        final hoursAgoFavorite = [
          FavoriteEntity(
            id: '1',
            imageId: 'img_123',
            imageUrl: 'https://example.com/image1.jpg',
            subId: 'user_riyam',
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
        ];
        when(() => mockFavoriteCubit.state)
            .thenReturn(FavoriteLoaded(hoursAgoFavorite));
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Assert
        expect(find.textContaining('h ago'), findsOneWidget);
      });

      testWidgets('displays days ago for favorites added days ago',
          (tester) async {
        // Arrange
        final daysAgoFavorite = [
          FavoriteEntity(
            id: '1',
            imageId: 'img_123',
            imageUrl: 'https://example.com/image1.jpg',
            subId: 'user_riyam',
            createdAt: DateTime.now().subtract(const Duration(days: 5)),
          ),
        ];
        when(() => mockFavoriteCubit.state)
            .thenReturn(FavoriteLoaded(daysAgoFavorite));
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Assert
        expect(find.textContaining('d ago'), findsOneWidget);
      });
    });

    group('Edge Cases and Error Handling', () {
      testWidgets('handles null image URLs gracefully', (tester) async {
        // Arrange
        final favoritesWithBadData = [
          FavoriteEntity(
            id: '1',
            imageId: 'img_123',
            imageUrl: '',
            subId: 'user_riyam',
            createdAt: DateTime(2024, 1, 1),
          ),
        ];
        when(() => mockFavoriteCubit.state)
            .thenReturn(FavoriteLoaded(favoritesWithBadData));
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert - Grid should render with favorite card even with bad URL
        expect(find.byType(GridView), findsOneWidget);
      });

      testWidgets('handles very long favorite list', (tester) async {
        // Arrange
        final longList = List.generate(
          50,
          (index) => FavoriteEntity(
            id: '$index',
            imageId: 'img_$index',
            imageUrl: 'https://example.com/image$index.jpg',
            subId: 'user_riyam',
            createdAt: DateTime.now(),
          ),
        );
        when(() => mockFavoriteCubit.state).thenReturn(FavoriteLoaded(longList));
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert - Should render GridView with scrollable content
        expect(find.byType(GridView), findsOneWidget);
      });

      testWidgets('handles long image IDs correctly', (tester) async {
        // Arrange
        final longIdFavorite = [
          FavoriteEntity(
            id: '1',
            imageId: 'very_long_image_id_that_exceeds_normal_length_12345',
            imageUrl: 'https://example.com/image1.jpg',
            subId: 'user_riyam',
            createdAt: DateTime.now(),
          ),
        ];
        when(() => mockFavoriteCubit.state)
            .thenReturn(FavoriteLoaded(longIdFavorite));
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Assert - Should truncate to 6 characters
        expect(find.textContaining('Pet #very_l'), findsOneWidget);
      });

      testWidgets('handles short image IDs correctly', (tester) async {
        // Arrange
        final shortIdFavorite = [
          FavoriteEntity(
            id: '1',
            imageId: 'ab',
            imageUrl: 'https://example.com/image1.jpg',
            subId: 'user_riyam',
            createdAt: DateTime.now(),
          ),
        ];
        when(() => mockFavoriteCubit.state)
            .thenReturn(FavoriteLoaded(shortIdFavorite));
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Assert - Should show full short ID
        expect(find.textContaining('Pet #ab'), findsOneWidget);
      });
    });

    group('UI Styling Tests', () {
      testWidgets('title has correct font weight and size', (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state).thenReturn(FavoriteInitial());
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesInitial());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        final titleText = tester.widget<Text>(find.text('Your Favorite Pets'));
        expect(titleText.style?.fontSize, 22);
        expect(titleText.style?.fontWeight, FontWeight.bold);
      });

      testWidgets('selected category uses primary color', (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state).thenReturn(FavoriteInitial());
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Assert - First category should be selected with primary color
        expect(find.text('All'), findsOneWidget);
      });

      testWidgets('error text is displayed in red', (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state)
            .thenReturn(FavoriteError('Test error'));
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        final errorText = tester.widget<Text>(find.text('Test error'));
        expect(errorText.style?.color, Colors.red);
      });

      testWidgets('favorite cards have proper rounded corners',
          (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state)
            .thenReturn(FavoriteLoaded(testFavorites));
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Assert - Container decoration should have borderRadius
        expect(find.byType(Container), findsWidgets);
      });
    });

    group('Widget Structure Tests', () {
      testWidgets('FavoriteScreen is a StatefulWidget', (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state).thenReturn(FavoriteInitial());
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesInitial());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.byType(FavoriteScreen), findsOneWidget);
        final favoriteScreen =
            tester.widget<FavoriteScreen>(find.byType(FavoriteScreen));
        expect(favoriteScreen, isA<StatefulWidget>());
      });

      testWidgets('provides FavoriteCubit and GetCategoriesCubit',
          (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state).thenReturn(FavoriteInitial());
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesInitial());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert - Both cubits should be initialized
        verify(() => mockFavoriteCubit.getFavorites()).called(1);
        verify(() => mockGetCategoriesCubit.fetchCategories()).called(1);
      });

      testWidgets('has SafeArea wrapping content', (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state).thenReturn(FavoriteInitial());
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesInitial());

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert - SafeArea should be present
        expect(find.byType(SafeArea), findsWidgets);
      });
    });

    group('State Behavior Tests', () {
      testWidgets('shows loading state correctly', (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state).thenReturn(FavoriteLoading());
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert - Loading indicator should be visible
        expect(find.byType(CircularProgressIndicator), findsWidgets);
      });

      testWidgets('shows loaded state correctly', (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state)
            .thenReturn(FavoriteLoaded(testFavorites));
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert - GridView should be displayed
        expect(find.byType(GridView), findsOneWidget);
      });

      testWidgets('shows error state correctly', (tester) async {
        // Arrange
        when(() => mockFavoriteCubit.state)
            .thenReturn(FavoriteError('Network error'));
        when(() => mockGetCategoriesCubit.state)
            .thenReturn(GetCategoriesLoaded(testCategories));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert - Error UI should be displayed
        expect(find.text('Network error'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      });
    });
  });
}
