import 'package:animals_tasks/core/di/di.dart';
import 'package:animals_tasks/core/styling/app_colors.dart';
import 'package:animals_tasks/features/details/presentation/cubit/get_dog_details_cubit.dart';
import 'package:animals_tasks/features/details/presentation/cubit/get_dog_details_state.dart';
import 'package:animals_tasks/features/details/presentation/screens/details_screen.dart';
import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockGetDogDetailsCubit extends MockCubit<GetDogDetailsState>
    implements GetDogDetailsCubit {}


void main() {
  late MockGetDogDetailsCubit mockCubit;
  final getIt = GetIt.instance;

  setUpAll(() async {
    getIt.reset();             // clear all old registrations
    await setupDependencies(); // register everything again
  });

  setUp(() {
    mockCubit = MockGetDogDetailsCubit();

    // Setup GetIt - only register the mock cubit we need for testing
    if (getIt.isRegistered<GetDogDetailsCubit>()) {
      getIt.unregister<GetDogDetailsCubit>();
    }
    getIt.registerFactory<GetDogDetailsCubit>(() => mockCubit);

    // Default state and behavior
    when(() => mockCubit.state).thenReturn(GetDogDetailsInitial());
    when(
      () => mockCubit.fetchDogDetails(any()),
    ).thenAnswer((_) => Future<void>.value());
  });

  tearDown(() {
    mockCubit.close();
    if (getIt.isRegistered<GetDogDetailsCubit>()) {
      getIt.unregister<GetDogDetailsCubit>();
    }
  });

  const testDogId = '1';
  const testDog = DogEntity(
    id: '1',
    name: 'Golden Retriever',
    imageUrl: 'https://cdn2.thedogapi.com/images/abc123.jpg',
    gender: 'Male',
    age: '2 years',
    weight: '30 kg',
    distance: '2.5 km away',
    breedGroup: 'Sporting',
    description: 'Friendly and intelligent dog breed',
    lifeSpan: '10-12 years',
  );

  // Helper function to create testable widget
  Widget createTestWidget({GetDogDetailsState? initialState}) {
    if (initialState != null) {
      when(() => mockCubit.state).thenReturn(initialState);
    }

    return const MaterialApp(home: DetailsScreen(dogId: testDogId));
  }

  group('DetailsScreen - Initial State and Lifecycle', () {
    testWidgets('should call fetchDogDetails on initialization', (
      tester,
    ) async {
      // Arrange
      when(() => mockCubit.state).thenReturn(GetDogDetailsLoading());

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      verify(() => mockCubit.fetchDogDetails(testDogId)).called(1);
    });

    testWidgets('should have correct AppBar background color', (tester) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, Colors.transparent);
      expect(appBar.elevation, 0);
    });

    testWidgets('should have back button in AppBar', (tester) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
      final iconButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.arrow_back_ios_new_rounded),
      );
      expect(iconButton.icon, isA<Icon>());
    });

    testWidgets('should have favorite icon in AppBar', (tester) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    });

    testWidgets('should have correct Scaffold background color', (
      tester,
    ) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, AppColors.cardBackground);
    });
  });

  group('DetailsScreen - Loading State', () {
    testWidgets('should show CircularProgressIndicator when loading', (
      tester,
    ) async {
      // Arrange
      when(() => mockCubit.state).thenReturn(GetDogDetailsLoading());

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(progressIndicator.color, AppColors.primary);
    });

    testWidgets('should center loading indicator', (tester) async {
      // Arrange
      when(() => mockCubit.state).thenReturn(GetDogDetailsLoading());

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(Center), findsWidgets);
      final center = tester.widget<Center>(
        find.ancestor(
          of: find.byType(CircularProgressIndicator),
          matching: find.byType(Center),
        ),
      );
      expect(center, isNotNull);
    });

    testWidgets('should not show any dog details when loading', (tester) async {
      // Arrange
      when(() => mockCubit.state).thenReturn(GetDogDetailsLoading());

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('About'), findsNothing);
      expect(find.text('Adopt me'), findsNothing);
    });
  });

  group('DetailsScreen - Error State', () {
    testWidgets('should display error message when state is Error', (
      tester,
    ) async {
      // Arrange
      const errorMessage = 'Failed to load dog details';
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsError(errorMessage));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should display error icon when state is Error', (
      tester,
    ) async {
      // Arrange
      when(() => mockCubit.state).thenReturn(const GetDogDetailsError('Error'));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      final icon = tester.widget<Icon>(find.byIcon(Icons.error_outline));
      expect(icon.size, 64);
      expect(icon.color, Colors.red);
    });

    testWidgets('should display Retry button when state is Error', (
      tester,
    ) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsError('Network error'));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('Retry'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Retry'), findsOneWidget);
    });

    testWidgets('should call fetchDogDetails when Retry button is tapped', (
      tester,
    ) async {
      // Arrange
      when(() => mockCubit.state).thenReturn(const GetDogDetailsError('Error'));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Tap retry button
      await tester.tap(find.text('Retry'));
      await tester.pump();

      // Assert - called once on init, once on retry
      verify(() => mockCubit.fetchDogDetails(testDogId)).called(2);
    });

    testWidgets('should center error message', (tester) async {
      // Arrange
      when(() => mockCubit.state).thenReturn(const GetDogDetailsError('Error'));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final center = tester.widget<Center>(
        find.ancestor(of: find.byType(Column), matching: find.byType(Center)),
      );
      expect(center, isNotNull);
    });

    testWidgets('should have proper error text styling', (tester) async {
      // Arrange
      const errorMessage = 'API Error occurred';
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsError(errorMessage));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final text = tester.widget<Text>(find.text(errorMessage));
      expect(text.style?.fontSize, 16);
      expect(text.style?.color, Colors.red);
      expect(text.textAlign, TextAlign.center);
    });
  });

  group('DetailsScreen - Loaded State - Dog Details', () {
    testWidgets('should display dog name', (tester) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Golden Retriever'), findsOneWidget);
      final nameText = tester.widget<Text>(find.text('Golden Retriever'));
      expect(nameText.style?.fontSize, 26);
      expect(nameText.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('should display breed group', (tester) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Sporting'), findsOneWidget);
      final breedText = tester.widget<Text>(find.text('Sporting'));
      expect(breedText.style?.fontSize, 16);
      expect(breedText.style?.color, Colors.grey);
    });

    testWidgets('should display gender info', (tester) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Male'), findsOneWidget);
      expect(find.text('Gender'), findsOneWidget);
      expect(find.byIcon(Icons.male_rounded), findsOneWidget);
    });

    testWidgets('should display age info', (tester) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('2 years'), findsOneWidget);
      expect(find.text('Age'), findsOneWidget);
      expect(find.byIcon(Icons.cake_rounded), findsOneWidget);
    });

    testWidgets('should display weight info', (tester) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('30 kg'), findsOneWidget);
      expect(find.text('Weight'), findsOneWidget);
      expect(find.byIcon(Icons.monitor_weight_rounded), findsOneWidget);
    });

    testWidgets('should display About section', (tester) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('About'), findsOneWidget);
      final aboutText = tester.widget<Text>(find.text('About'));
      expect(aboutText.style?.fontSize, 20);
      expect(aboutText.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('should display description', (tester) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Friendly and intelligent dog breed'), findsOneWidget);
      final descText = tester.widget<Text>(
        find.text('Friendly and intelligent dog breed'),
      );
      expect(descText.style?.fontSize, 15);
      expect(descText.style?.height, 1.5);
    });

    testWidgets('should display Adopt me button', (tester) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Adopt me'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Adopt me'), findsOneWidget);
    });

    testWidgets('should display dog image', (tester) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Image), findsOneWidget);
      final image = tester.widget<Image>(find.byType(Image));
      expect(image, isA<Image>());
    });
  });

  group('DetailsScreen - Edge Cases - Null Values', () {
    testWidgets('should display "Unknown Breed" when breedGroup is null', (
      tester,
    ) async {
      // Arrange
      const dogWithoutBreed = DogEntity(
        id: '1',
        name: 'Test Dog',
        imageUrl: 'https://example.com/image.jpg',
      );
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(dogWithoutBreed));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Unknown Breed'), findsOneWidget);
    });

    testWidgets('should display "Unknown Breed" when breedGroup is empty', (
      tester,
    ) async {
      // Arrange
      const dogWithEmptyBreed = DogEntity(
        id: '1',
        name: 'Test Dog',
        imageUrl: 'https://example.com/image.jpg',
        breedGroup: '',
      );
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(dogWithEmptyBreed));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Unknown Breed'), findsOneWidget);
    });

    testWidgets('should display "-" when gender is null', (tester) async {
      // Arrange
      const dogWithoutGender = DogEntity(
        id: '1',
        name: 'Test Dog',
        imageUrl: 'https://example.com/image.jpg',
      );
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(dogWithoutGender));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert - Find "-" in the gender info tile
      expect(find.text('-'), findsNWidgets(3)); // gender, age, weight
    });

    testWidgets('should display "-" when age is null', (tester) async {
      // Arrange
      const dogWithoutAge = DogEntity(
        id: '1',
        name: 'Test Dog',
        imageUrl: 'https://example.com/image.jpg',
      );
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(dogWithoutAge));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('-'), findsNWidgets(3));
    });

    testWidgets('should display "-" when weight is null', (tester) async {
      // Arrange
      const dogWithoutWeight = DogEntity(
        id: '1',
        name: 'Test Dog',
        imageUrl: 'https://example.com/image.jpg',
      );
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(dogWithoutWeight));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('-'), findsNWidgets(3));
    });

    testWidgets(
      'should display "No description available." when description is null',
      (tester) async {
        // Arrange
        const dogWithoutDescription = DogEntity(
          id: '1',
          name: 'Test Dog',
          imageUrl: 'https://example.com/image.jpg',
        );
        when(
          () => mockCubit.state,
        ).thenReturn(const GetDogDetailsLoaded(dogWithoutDescription));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('No description available.'), findsOneWidget);
      },
    );

    testWidgets(
      'should display "No description available." when description is empty',
      (tester) async {
        // Arrange
        const dogWithEmptyDescription = DogEntity(
          id: '1',
          name: 'Test Dog',
          imageUrl: 'https://example.com/image.jpg',
          description: '',
        );
        when(
          () => mockCubit.state,
        ).thenReturn(const GetDogDetailsLoaded(dogWithEmptyDescription));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('No description available.'), findsOneWidget);
      },
    );
  });

  group('DetailsScreen - Edge Cases - Long Text', () {
    testWidgets('should handle very long dog name', (tester) async {
      // Arrange
      const dogWithLongName = DogEntity(
        id: '1',
        name:
            'This is a very very very long dog breed name that might overflow',
        imageUrl: 'https://example.com/image.jpg',
      );
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(dogWithLongName));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert - Should render without overflow
      expect(tester.takeException(), isNull);
      expect(
        find.text(
          'This is a very very very long dog breed name that might overflow',
        ),
        findsOneWidget,
      );
    });

    testWidgets('should handle very long description', (tester) async {
      // Arrange
      const longDescription =
          'This is a very long description that contains multiple sentences and paragraphs. '
          'It describes the dog breed in great detail, including its history, temperament, physical characteristics, '
          'health considerations, grooming needs, exercise requirements, and suitability as a family pet. '
          'This text is intentionally very long to test how the UI handles extensive content.';
      const dogWithLongDesc = DogEntity(
        id: '1',
        name: 'Test Dog',
        imageUrl: 'https://example.com/image.jpg',
        description: longDescription,
      );
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(dogWithLongDesc));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(tester.takeException(), isNull);
      expect(
        find.textContaining('This is a very long description'),
        findsOneWidget,
      );
    });
  });

  group('DetailsScreen - User Interactions', () {
    testWidgets('should show snackbar when Adopt me button is tapped', (
      tester,
    ) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Scroll to make the button visible
      await tester.dragUntilVisible(
        find.text('Adopt me'),
        find.byType(SingleChildScrollView),
        const Offset(0, -50),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Adopt me'));
      await tester.pumpAndSettle(); // Wait for snackbar animation

      // Assert
      expect(
        find.text('Adoption request sent for Golden Retriever 💚'),
        findsOneWidget,
      );
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('snackbar should have floating behavior', (tester) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Scroll to make the button visible
      await tester.dragUntilVisible(
        find.text('Adopt me'),
        find.byType(SingleChildScrollView),
        const Offset(0, -50),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Adopt me'));
      await tester.pumpAndSettle(); // Wait for snackbar animation

      // Assert
      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.behavior, SnackBarBehavior.floating);
    });

    testWidgets('should pop navigation when back button is tapped', (
      tester,
    ) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle();

      // Assert - Screen should be popped
      expect(find.byType(DetailsScreen), findsNothing);
    });
  });

  group('DetailsScreen - UI Layout and Styling', () {
    testWidgets('should have SingleChildScrollView for scrolling', (
      tester,
    ) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should have proper padding on main content', (tester) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.padding, const EdgeInsets.all(20));
    });

    testWidgets('should have rounded image corners', (tester) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clipRRect.borderRadius, BorderRadius.circular(16));
    });

    testWidgets('info tiles should have proper styling', (tester) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final containers = tester.widgetList<Container>(find.byType(Container));
      // Find the info tile containers (they have specific width of 100)
      final infoTiles = containers.where((c) {
        final constraints = c.constraints;
        return constraints != null && constraints.maxWidth == 100;
      });

      expect(
        infoTiles.length,
        greaterThanOrEqualTo(3),
      ); // At least 3 info tiles
    });

    testWidgets('Adopt button should have proper styling', (tester) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Adopt me'),
      );
      expect(button.style?.backgroundColor?.resolve({}), AppColors.primary);
    });

    testWidgets('should center the Adopt button', (tester) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final center = find.ancestor(
        of: find.widgetWithText(ElevatedButton, 'Adopt me'),
        matching: find.byType(Center),
      );
      expect(center, findsOneWidget);
    });
  });

  group('DetailsScreen - Initial State', () {
    testWidgets('should show nothing when state is Initial', (tester) async {
      // Arrange
      when(() => mockCubit.state).thenReturn(GetDogDetailsInitial());

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('About'), findsNothing);
      expect(find.byType(SizedBox), findsWidgets); // Only SizedBox.shrink
    });
  });

  group('DetailsScreen - Different Error Messages', () {
    testWidgets('should display network error message', (tester) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsError('Network connection failed'));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('Network connection failed'), findsOneWidget);
    });

    testWidgets('should display API error message', (tester) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsError('API Error: 404 Not Found'));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('API Error: 404 Not Found'), findsOneWidget);
    });

    testWidgets('should display server error message', (tester) async {
      // Arrange
      when(() => mockCubit.state).thenReturn(
        const GetDogDetailsError('Server error: Internal server error'),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('Server error: Internal server error'), findsOneWidget);
    });
  });

  group('DetailsScreen - Multiple Dogs', () {
    testWidgets('should display Labrador correctly', (
      tester,
    ) async {
      // Arrange
      const dog1 = DogEntity(
        id: '1',
        name: 'Labrador',
        imageUrl: 'https://example.com/lab.jpg',
      );

      // Test first dog
      when(() => mockCubit.state).thenReturn(const GetDogDetailsLoaded(dog1));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should show the dog name
      expect(find.text('Labrador'), findsOneWidget);
    });

    testWidgets('should display Poodle correctly', (
      tester,
    ) async {
      // Arrange
      const dog2 = DogEntity(
        id: '2',
        name: 'Poodle',
        imageUrl: 'https://example.com/poodle.jpg',
      );

      // Test second dog
      when(() => mockCubit.state).thenReturn(const GetDogDetailsLoaded(dog2));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should show the dog name
      expect(find.text('Poodle'), findsOneWidget);
    });
  });

  group('DetailsScreen - Info Tile Icons', () {
    testWidgets('should render gender icon with correct color', (tester) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final genderIcon = tester.widget<Icon>(find.byIcon(Icons.male_rounded));
      expect(genderIcon.color, AppColors.primary);
      expect(genderIcon.size, 20);
    });

    testWidgets('should render age icon with correct color', (tester) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final ageIcon = tester.widget<Icon>(find.byIcon(Icons.cake_rounded));
      expect(ageIcon.color, AppColors.primary);
      expect(ageIcon.size, 20);
    });

    testWidgets('should render weight icon with correct color', (tester) async {
      // Arrange
      when(
        () => mockCubit.state,
      ).thenReturn(const GetDogDetailsLoaded(testDog));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final weightIcon = tester.widget<Icon>(
        find.byIcon(Icons.monitor_weight_rounded),
      );
      expect(weightIcon.color, AppColors.primary);
      expect(weightIcon.size, 20);
    });
  });
}
