import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:animals_tasks/features/home/presentation/widgets/pet_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Test data constants
  const testImageUrl = 'https://cdn2.thedogapi.com/images/test123.jpg';
  const testDogName = 'Golden Retriever';
  const testGender = 'Male';
  const testAge = '2 years';
  const testDistance = '2.5 km away';

  // Helper function to create DogEntity with default values
  DogEntity createTestDog({
    String id = '1',
    String name = testDogName,
    String imageUrl = testImageUrl,
    String? gender = testGender,
    String? age = testAge,
    String? distance = testDistance,
    String? weight,
    String? lifeSpan,
    String? breedGroup,
    String? description,
    bool isFavorite = false,
  }) {
    return DogEntity(
      id: id,
      name: name,
      imageUrl: imageUrl,
      gender: gender,
      age: age,
      distance: distance,
      weight: weight,
      lifeSpan: lifeSpan,
      breedGroup: breedGroup,
      description: description,
      isFavorite: isFavorite,
    );
  }

  // Helper function to create testable widget
  Widget createTestWidget(DogEntity dog) {
    return MaterialApp(
      home: Scaffold(
        body: PetCard(dog: dog),
      ),
    );
  }

  group('PetCard - Rendering Tests', () {
    testWidgets('should render Card widget', (tester) async {
      // Arrange
      final dog = createTestDog();

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should render dog name', (tester) async {
      // Arrange
      final dog = createTestDog(name: 'Labrador');

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      expect(find.text('Labrador'), findsOneWidget);
    });

    testWidgets('should render CachedNetworkImage', (tester) async {
      // Arrange
      final dog = createTestDog();

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('should render favorite icon', (tester) async {
      // Arrange
      final dog = createTestDog();

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('should render location icon', (tester) async {
      // Arrange
      final dog = createTestDog();

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      expect(find.byIcon(Icons.location_on), findsOneWidget);
    });
  });

  group('PetCard - Dog Information Display Tests', () {
    testWidgets('should display gender and age in correct format',
        (tester) async {
      // Arrange
      final dog = createTestDog(gender: 'Female', age: '3 years');

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      expect(find.text('Female • 3 years'), findsOneWidget);
    });

    testWidgets('should display distance', (tester) async {
      // Arrange
      final dog = createTestDog(distance: '5.0 km away');

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      expect(find.text('5.0 km away'), findsOneWidget);
    });

    testWidgets('should display dog name with correct styling',
        (tester) async {
      // Arrange
      final dog = createTestDog(name: 'Beagle');

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      final text = tester.widget<Text>(find.text('Beagle'));
      expect(text.style?.fontWeight, FontWeight.bold);
      expect(text.style?.fontSize, 16);
    });

    testWidgets('should format gender and age with bullet separator',
        (tester) async {
      // Arrange
      final dog = createTestDog(gender: 'Male', age: '1 year');

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      expect(find.text('Male • 1 year'), findsOneWidget);
    });
  });

  group('PetCard - Null Field Handling Tests', () {
    testWidgets('should handle null gender gracefully', (tester) async {
      // Arrange
      final dog = createTestDog(gender: null);

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      expect(find.text(' • $testAge'), findsOneWidget);
    });

    testWidgets('should handle null age gracefully', (tester) async {
      // Arrange
      final dog = createTestDog(age: null);

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      expect(find.text('$testGender • '), findsOneWidget);
    });

    testWidgets('should handle both gender and age as null', (tester) async {
      // Arrange
      final dog = createTestDog(gender: null, age: null);

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      expect(find.text(' • '), findsOneWidget);
    });

    testWidgets('should handle null distance gracefully', (tester) async {
      // Arrange
      final dog = createTestDog(distance: null);

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert - Should render empty text for distance
      expect(find.text(''), findsWidgets);
    });

    testWidgets('should handle all optional fields as null', (tester) async {
      // Arrange
      final dog = createTestDog(
        gender: null,
        age: null,
        distance: null,
        weight: null,
        lifeSpan: null,
        breedGroup: null,
        description: null,
      );

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert - Card should still render with name and image
      expect(find.byType(PetCard), findsOneWidget);
      expect(find.text(testDogName), findsOneWidget);
    });
  });

  group('PetCard - Image Handling Tests', () {
    testWidgets('should use correct image URL', (tester) async {
      // Arrange
      const customImageUrl = 'https://example.com/dog.jpg';
      final dog = createTestDog(imageUrl: customImageUrl);

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      final cachedImage =
          tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
      expect(cachedImage.imageUrl, customImageUrl);
    });

    testWidgets('should have correct image dimensions', (tester) async {
      // Arrange
      final dog = createTestDog();

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      final cachedImage =
          tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
      expect(cachedImage.height, 100);
      expect(cachedImage.width, 100);
    });

    testWidgets('should use BoxFit.cover for image', (tester) async {
      // Arrange
      final dog = createTestDog();

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      final cachedImage =
          tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
      expect(cachedImage.fit, BoxFit.cover);
    });

    testWidgets('should have placeholder for loading images', (tester) async {
      // Arrange
      final dog = createTestDog();

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      final cachedImage =
          tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
      expect(cachedImage.placeholder, isNotNull);
    });

    testWidgets('should have error widget for failed images', (tester) async {
      // Arrange
      final dog = createTestDog();

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      final cachedImage =
          tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
      expect(cachedImage.errorWidget, isNotNull);
    });

    testWidgets('should have ClipRRect with rounded corners', (tester) async {
      // Arrange
      final dog = createTestDog();

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      final clipRRect = tester.widget<ClipRRect>(find.descendant(
        of: find.byType(PetCard),
        matching: find.byType(ClipRRect),
      ));
      expect(clipRRect.borderRadius, BorderRadius.circular(8));
    });
  });

  group('PetCard - Styling Tests', () {
    testWidgets('should have correct card elevation', (tester) async {
      // Arrange
      final dog = createTestDog();

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 2);
    });

    testWidgets('should have rounded corners', (tester) async {
      // Arrange
      final dog = createTestDog();

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      final card = tester.widget<Card>(find.byType(Card));
      final shape = card.shape as RoundedRectangleBorder;
      expect(shape.borderRadius, BorderRadius.circular(12));
    });

    testWidgets('should have correct card margin', (tester) async {
      // Arrange
      final dog = createTestDog();

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.margin, const EdgeInsets.symmetric(vertical: 8));
    });

    testWidgets('should have correct internal padding', (tester) async {
      // Arrange
      final dog = createTestDog();

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert - Find the Padding widget with all(12.0) padding
      final paddingWidgets = tester.widgetList<Padding>(find.descendant(
        of: find.byType(Card),
        matching: find.byType(Padding),
      ));

      // Find the Padding with EdgeInsets.all(12.0)
      final targetPadding = paddingWidgets.firstWhere(
        (p) => p.padding == const EdgeInsets.all(12.0),
        orElse: () => throw Exception('No Padding with EdgeInsets.all(12.0) found'),
      );

      expect(targetPadding.padding, const EdgeInsets.all(12.0));
    });

    testWidgets('should use Row layout for content', (tester) async {
      // Arrange
      final dog = createTestDog();

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      expect(
          find.descendant(
            of: find.byType(PetCard),
            matching: find.byType(Row),
          ),
          findsWidgets);
    });

    testWidgets('should use Column for dog information', (tester) async {
      // Arrange
      final dog = createTestDog();

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      expect(
          find.descendant(
            of: find.byType(PetCard),
            matching: find.byType(Column),
          ),
          findsOneWidget);
    });
  });

  group('PetCard - Layout Tests', () {
    testWidgets('should layout image on the left side', (tester) async {
      // Arrange
      final dog = createTestDog();

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert - Use .first since there may be multiple Row widgets
      final row = tester.widgetList<Row>(find.descendant(
        of: find.byType(Padding),
        matching: find.byType(Row),
      )).first;

      expect(row.children.first, isA<ClipRRect>());
    });

    testWidgets('should have SizedBox between image and text', (tester) async {
      // Arrange
      final dog = createTestDog();

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert - May find multiple SizedBox widgets, use findsWidgets
      expect(
          find.descendant(
            of: find.byType(Row),
            matching: find.byWidgetPredicate(
              (widget) => widget is SizedBox && widget.width == 16,
            ),
          ),
          findsWidgets);
    });

    testWidgets('should have Expanded widget for dog info', (tester) async {
      // Arrange
      final dog = createTestDog();

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      expect(
          find.descendant(
            of: find.byType(Row),
            matching: find.byType(Expanded),
          ),
          findsOneWidget);
    });

    testWidgets('should layout favorite icon on the right', (tester) async {
      // Arrange
      final dog = createTestDog();

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert - Use .first since there may be multiple Row widgets
      final row = tester.widgetList<Row>(find.descendant(
        of: find.byType(Padding),
        matching: find.byType(Row),
      )).first;

      expect(row.children.last, isA<IconButton>());
    });
  });

  group('PetCard - Edge Cases', () {
    testWidgets('should handle empty string fields', (tester) async {
      // Arrange
      final dog = createTestDog(
        gender: '',
        age: '',
        distance: '',
      );

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      expect(find.byType(PetCard), findsOneWidget);
      expect(find.text(' • '), findsOneWidget);
    });

    testWidgets('should handle very long dog name', (tester) async {
      // Arrange
      const longName =
          'Golden Retriever Mixed Breed With Very Long Name That Might Overflow';
      final dog = createTestDog(name: longName);

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      expect(find.text(longName), findsOneWidget);
    });

    testWidgets('should handle special characters in name', (tester) async {
      // Arrange
      final dog = createTestDog(name: 'Max & Charlie\'s Dog!');

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      expect(find.text('Max & Charlie\'s Dog!'), findsOneWidget);
    });

    testWidgets('should handle single character name', (tester) async {
      // Arrange
      final dog = createTestDog(name: 'M');

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      expect(find.text('M'), findsOneWidget);
    });

    testWidgets('should handle very long distance text', (tester) async {
      // Arrange
      final dog = createTestDog(distance: '123.456 kilometers away from you');

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      expect(find.text('123.456 kilometers away from you'), findsOneWidget);
    });

    testWidgets('should handle unusual gender values', (tester) async {
      // Arrange
      final dog = createTestDog(gender: 'Unknown', age: 'N/A');

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      expect(find.text('Unknown • N/A'), findsOneWidget);
    });

    testWidgets('should handle zero distance', (tester) async {
      // Arrange
      final dog = createTestDog(distance: '0 km away');

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      expect(find.text('0 km away'), findsOneWidget);
    });

    testWidgets('should handle invalid image URL format', (tester) async {
      // Arrange
      final dog = createTestDog(imageUrl: 'not-a-valid-url');

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert - Should still render without crashing
      expect(find.byType(PetCard), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });
  });

  group('PetCard - Multiple Dogs Tests', () {
    testWidgets('should display multiple different dog cards', (tester) async {
      // Arrange
      final dogs = [
        createTestDog(id: '1', name: 'Max'),
        createTestDog(id: '2', name: 'Bella'),
        createTestDog(id: '3', name: 'Charlie'),
      ];

      // Act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ListView.builder(
            itemCount: dogs.length,
            itemBuilder: (context, index) => PetCard(dog: dogs[index]),
          ),
        ),
      ));

      // Assert
      expect(find.text('Max'), findsOneWidget);
      expect(find.text('Bella'), findsOneWidget);
      expect(find.text('Charlie'), findsOneWidget);
      expect(find.byType(PetCard), findsNWidgets(3));
    });

    testWidgets('should display dogs with different attributes',
        (tester) async {
      // Arrange
      final dogs = [
        createTestDog(name: 'Rex', gender: 'Male', age: '5 years'),
        createTestDog(name: 'Luna', gender: 'Female', age: '2 years'),
        createTestDog(name: 'Buddy', gender: null, age: null),
      ];

      // Act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ListView.builder(
            itemCount: dogs.length,
            itemBuilder: (context, index) => PetCard(dog: dogs[index]),
          ),
        ),
      ));

      // Assert
      expect(find.text('Rex'), findsOneWidget);
      expect(find.text('Male • 5 years'), findsOneWidget);
      expect(find.text('Luna'), findsOneWidget);
      expect(find.text('Female • 2 years'), findsOneWidget);
      expect(find.text('Buddy'), findsOneWidget);
    });
  });

  group('PetCard - Icon Styling Tests', () {
    testWidgets('should display location icon with correct color',
        (tester) async {
      // Arrange
      final dog = createTestDog();

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      final locationIcon = tester.widget<Icon>(find.byIcon(Icons.location_on));
      expect(locationIcon.size, 16);
      expect(locationIcon.color, Colors.red);
    });

    testWidgets('should display favorite icon with correct color',
        (tester) async {
      // Arrange
      final dog = createTestDog();

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert
      final favoriteIcon =
          tester.widget<Icon>(find.byIcon(Icons.favorite_border));
      expect(favoriteIcon.color, Colors.teal);
    });
  });

  group('PetCard - Integration Tests', () {
    testWidgets('should display complete dog information card', (tester) async {
      // Arrange
      final dog = createTestDog(
        name: 'Golden Retriever',
        gender: 'Male',
        age: '3 years',
        distance: '2.5 km away',
      );

      // Act
      await tester.pumpWidget(createTestWidget(dog));

      // Assert - Verify all components are present
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsOneWidget);
      expect(find.text('Golden Retriever'), findsOneWidget);
      expect(find.text('Male • 3 years'), findsOneWidget);
      expect(find.text('2.5 km away'), findsOneWidget);
      expect(find.byIcon(Icons.location_on), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });
  });
}
