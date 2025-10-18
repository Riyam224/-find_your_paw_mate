import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/features/favorite/domain/entities/favorite_entity.dart';
import 'package:animals_tasks/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:animals_tasks/features/favorite/domain/usecases/add_favorite_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

void main() {
  late MockFavoriteRepository mockRepository;
  late AddFavoriteUseCase useCase;

  final tFavorite = FavoriteEntity(
    id: '123',
    imageId: 'abc123',
    imageUrl: 'https://cdn2.thedogapi.com/images/abc123.jpg',
    subId: 'user-123',
    createdAt: DateTime(2024, 1, 15, 10, 30),
    petName: 'Golden Retriever',
    breedName: 'Golden Retriever',
    breedId: '1',
  );

  const tImageId = 'abc123';
  const tSubId = 'user-123';

  setUp(() {
    mockRepository = MockFavoriteRepository();
    useCase = AddFavoriteUseCase(mockRepository);
  });

  group('AddFavoriteUseCase', () {
    test('should return FavoriteEntity on successful addition', () async {
      // Arrange
      when(
        () => mockRepository.addFavorite(
          imageId: any(named: 'imageId'),
          subId: any(named: 'subId'),
        ),
      ).thenAnswer((_) async => Right(tFavorite));

      // Act
      final result = await useCase(imageId: tImageId);

      // Assert
      expect(result.isRight(), true);
      expect(result, Right(tFavorite));
      result.fold(
        (_) => fail('Should succeed'),
        (favorite) {
          expect(favorite, isA<FavoriteEntity>());
          expect(favorite.id, '123');
          expect(favorite.imageId, tImageId);
          expect(favorite.imageUrl, contains(tImageId));
        },
      );
      verify(() => mockRepository.addFavorite(imageId: tImageId, subId: null)).called(1);
    });

    test('should pass imageId parameter correctly', () async {
      // Arrange
      const customImageId = 'custom-image-123';
      final customFavorite = FavoriteEntity(
        id: '999',
        imageId: customImageId,
        imageUrl: 'https://cdn2.thedogapi.com/images/$customImageId.jpg',
        createdAt: DateTime.now(),
      );

      when(
        () => mockRepository.addFavorite(
          imageId: any(named: 'imageId'),
          subId: any(named: 'subId'),
        ),
      ).thenAnswer((_) async => Right(customFavorite));

      // Act
      await useCase(imageId: customImageId);

      // Assert
      verify(() => mockRepository.addFavorite(imageId: customImageId, subId: null)).called(1);
    });

    test('should pass subId parameter when provided', () async {
      // Arrange
      when(
        () => mockRepository.addFavorite(
          imageId: any(named: 'imageId'),
          subId: any(named: 'subId'),
        ),
      ).thenAnswer((_) async => Right(tFavorite));

      // Act
      await useCase(imageId: tImageId, subId: tSubId);

      // Assert
      verify(() => mockRepository.addFavorite(imageId: tImageId, subId: tSubId)).called(1);
    });

    test('should pass null subId when not provided', () async {
      // Arrange
      when(
        () => mockRepository.addFavorite(
          imageId: any(named: 'imageId'),
          subId: any(named: 'subId'),
        ),
      ).thenAnswer((_) async => Right(tFavorite));

      // Act
      await useCase(imageId: tImageId);

      // Assert
      verify(() => mockRepository.addFavorite(imageId: tImageId, subId: null)).called(1);
    });

    test('should return favorite without optional fields', () async {
      // Arrange
      final favoriteWithoutOptionals = FavoriteEntity(
        id: '456',
        imageId: tImageId,
        imageUrl: 'https://cdn2.thedogapi.com/images/$tImageId.jpg',
        createdAt: DateTime.now(),
      );

      when(
        () => mockRepository.addFavorite(
          imageId: any(named: 'imageId'),
          subId: any(named: 'subId'),
        ),
      ).thenAnswer((_) async => Right(favoriteWithoutOptionals));

      // Act
      final result = await useCase(imageId: tImageId);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should succeed'),
        (favorite) {
          expect(favorite.id, '456');
          expect(favorite.subId, isNull);
          expect(favorite.petName, isNull);
          expect(favorite.breedName, isNull);
          expect(favorite.breedId, isNull);
        },
      );
    });

    test('should handle empty imageId gracefully', () async {
      // Arrange
      const emptyImageId = '';
      final emptyFavorite = FavoriteEntity(
        id: '0',
        imageId: emptyImageId,
        imageUrl: 'https://cdn2.thedogapi.com/images/$emptyImageId.jpg',
        createdAt: DateTime.now(),
      );

      when(
        () => mockRepository.addFavorite(
          imageId: any(named: 'imageId'),
          subId: any(named: 'subId'),
        ),
      ).thenAnswer((_) async => Right(emptyFavorite));

      // Act
      final result = await useCase(imageId: emptyImageId);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockRepository.addFavorite(imageId: emptyImageId, subId: null)).called(1);
    });

    test('should handle special characters in imageId', () async {
      // Arrange
      const specialImageId = 'image-123_test.v2';
      final specialFavorite = FavoriteEntity(
        id: '789',
        imageId: specialImageId,
        imageUrl: 'https://cdn2.thedogapi.com/images/$specialImageId.jpg',
        createdAt: DateTime.now(),
      );

      when(
        () => mockRepository.addFavorite(
          imageId: any(named: 'imageId'),
          subId: any(named: 'subId'),
        ),
      ).thenAnswer((_) async => Right(specialFavorite));

      // Act
      final result = await useCase(imageId: specialImageId);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockRepository.addFavorite(imageId: specialImageId, subId: null)).called(1);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(
        () => mockRepository.addFavorite(
          imageId: any(named: 'imageId'),
          subId: any(named: 'subId'),
        ),
      ).thenAnswer((_) async => Left(ServerFailure('Failed to add favorite [400]: Image already favorited')));

      // Act
      final result = await useCase(imageId: tImageId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('Failed to add favorite'));
          expect(failure.message, contains('400'));
          expect(failure.message, contains('Image already favorited'));
        },
        (_) => fail('Should fail'),
      );
    });

    test('should return ServerFailure on duplicate favorite', () async {
      // Arrange
      when(
        () => mockRepository.addFavorite(
          imageId: any(named: 'imageId'),
          subId: any(named: 'subId'),
        ),
      ).thenAnswer((_) async => Left(ServerFailure('Failed to add favorite [400]: DUPLICATE_FAVOURITE')));

      // Act
      final result = await useCase(imageId: tImageId, subId: tSubId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('DUPLICATE_FAVOURITE'));
        },
        (_) => fail('Should fail'),
      );
    });

    test('should return NetworkFailure on network issue', () async {
      // Arrange
      when(
        () => mockRepository.addFavorite(
          imageId: any(named: 'imageId'),
          subId: any(named: 'subId'),
        ),
      ).thenAnswer((_) async => Left(NetworkFailure('No internet connection')));

      // Act
      final result = await useCase(imageId: tImageId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<NetworkFailure>());
          expect(failure.message, contains('No internet connection'));
        },
        (_) => fail('Should fail'),
      );
    });

    test('should return UnknownFailure on unknown error', () async {
      // Arrange
      when(
        () => mockRepository.addFavorite(
          imageId: any(named: 'imageId'),
          subId: any(named: 'subId'),
        ),
      ).thenAnswer((_) async => Left(UnknownFailure('Unexpected error occurred')));

      // Act
      final result = await useCase(imageId: tImageId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<UnknownFailure>());
          expect(failure.message, contains('Unexpected error'));
        },
        (_) => fail('Should fail'),
      );
    });

    test('should throw when unexpected exception happens', () async {
      // Arrange
      when(
        () => mockRepository.addFavorite(
          imageId: any(named: 'imageId'),
          subId: any(named: 'subId'),
        ),
      ).thenThrow(Exception('Unexpected exception'));

      // Act & Assert
      expect(
        () async => await useCase(imageId: tImageId),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle 404 error when image not found', () async {
      // Arrange
      when(
        () => mockRepository.addFavorite(
          imageId: any(named: 'imageId'),
          subId: any(named: 'subId'),
        ),
      ).thenAnswer((_) async => Left(ServerFailure('Failed to add favorite [404]: Image not found')));

      // Act
      final result = await useCase(imageId: 'non-existent-image');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('404'));
          expect(failure.message, contains('Image not found'));
        },
        (_) => fail('Should fail'),
      );
    });

    test('should handle 500 server error', () async {
      // Arrange
      when(
        () => mockRepository.addFavorite(
          imageId: any(named: 'imageId'),
          subId: any(named: 'subId'),
        ),
      ).thenAnswer((_) async => Left(ServerFailure('Failed to add favorite [500]: Internal server error')));

      // Act
      final result = await useCase(imageId: tImageId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('500'));
          expect(failure.message, contains('Internal server error'));
        },
        (_) => fail('Should fail'),
      );
    });

    test('should handle very long imageId', () async {
      // Arrange
      const longImageId = 'very-long-image-id-that-contains-many-characters-and-numbers-123456789';
      final longFavorite = FavoriteEntity(
        id: '1000',
        imageId: longImageId,
        imageUrl: 'https://cdn2.thedogapi.com/images/$longImageId.jpg',
        createdAt: DateTime.now(),
      );

      when(
        () => mockRepository.addFavorite(
          imageId: any(named: 'imageId'),
          subId: any(named: 'subId'),
        ),
      ).thenAnswer((_) async => Right(longFavorite));

      // Act
      final result = await useCase(imageId: longImageId);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockRepository.addFavorite(imageId: longImageId, subId: null)).called(1);
    });

    test('should call repository exactly once', () async {
      // Arrange
      when(
        () => mockRepository.addFavorite(
          imageId: any(named: 'imageId'),
          subId: any(named: 'subId'),
        ),
      ).thenAnswer((_) async => Right(tFavorite));

      // Act
      await useCase(imageId: tImageId);

      // Assert
      verify(() => mockRepository.addFavorite(imageId: tImageId, subId: null)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
