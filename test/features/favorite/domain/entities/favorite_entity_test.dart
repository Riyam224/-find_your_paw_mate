import 'package:flutter_test/flutter_test.dart';
import 'package:animals_tasks/features/favorite/domain/entities/favorite_entity.dart';

void main() {
  group('🐾 FavoriteEntity', () {
    final favorite = FavoriteEntity(
      id: '1',
      imageId: 'dog_123',
      imageUrl: 'https://example.com/dog.jpg',
      subId: 'user_1',
      createdAt: DateTime(2025, 10, 18),
      petName: 'Buddy',
      breedName: 'Golden Retriever',
      breedId: '123',
    );

    test('✅ supports value equality', () {
      final copy = FavoriteEntity(
        id: '1',
        imageId: 'dog_123',
        imageUrl: 'https://example.com/dog.jpg',
        subId: 'user_1',
        createdAt: DateTime(2025, 10, 18),
        petName: 'Buddy',
        breedName: 'Golden Retriever',
        breedId: '123',
      );

      expect(favorite, equals(copy));
      expect(favorite.props, copy.props);
    });

    test('✅ copyWith returns new instance with updated fields', () {
      final updated = favorite.copyWith(
        petName: 'Rocky',
        breedName: 'Labrador',
      );

      expect(updated.petName, 'Rocky');
      expect(updated.breedName, 'Labrador');
      expect(updated.id, favorite.id); // unchanged
      expect(updated.imageUrl, favorite.imageUrl);
      expect(updated, isNot(equals(favorite))); // should not be same object
    });

    test('✅ copyWith with no changes returns identical values', () {
      final identicalCopy = favorite.copyWith();
      expect(identicalCopy, equals(favorite));
    });

    test('✅ props contains all fields', () {
      final expectedProps = [
        favorite.id,
        favorite.imageId,
        favorite.imageUrl,
        favorite.subId,
        favorite.createdAt,
        favorite.petName,
        favorite.breedName,
        favorite.breedId,
      ];

      expect(favorite.props, expectedProps);
    });

    test('✅ handles optional nullable fields correctly', () {
      final noOptional = FavoriteEntity(
        id: '2',
        imageId: 'cat_321',
        imageUrl: 'https://example.com/cat.jpg',
        createdAt: DateTime(2025, 1, 1),
      );

      expect(noOptional.petName, isNull);
      expect(noOptional.breedName, isNull);
      expect(noOptional.breedId, isNull);
      expect(noOptional.subId, isNull);
    });
  });
}
