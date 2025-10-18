import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/core/services/dog_api_service.dart';
import 'package:animals_tasks/features/favorite/data/repositories/favorite_repository_impl.dart';
import 'package:animals_tasks/features/favorite/domain/entities/favorite_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDogApiService extends Mock implements DogApiService {}

void main() {
  late MockDogApiService mockApiService;
  late FavoriteRepositoryImpl repository;

  setUp(() {
    mockApiService = MockDogApiService();
    repository = FavoriteRepositoryImpl(mockApiService);
  });

  group('getFavorites', () {
    final tFavoritesResponse = [
      {
        'id': 123,
        'image_id': 'abc123',
        'sub_id': 'user-123',
        'created_at': '2024-01-15T10:30:00.000Z',
        'image': {
          'id': 'abc123',
          'url': 'https://cdn2.thedogapi.com/images/abc123.jpg',
          'breeds': [
            {
              'id': 1,
              'name': 'Golden Retriever',
            }
          ],
        },
      },
      {
        'id': 456,
        'image_id': 'xyz789',
        'sub_id': 'user-123',
        'created_at': '2024-01-16T14:20:00.000Z',
        'image': {
          'id': 'xyz789',
          'url': 'https://cdn2.thedogapi.com/images/xyz789.jpg',
        },
      },
    ];

    test('should return list of FavoriteEntity on success', () async {
      // Arrange
      when(() => mockApiService.getFavorites())
          .thenAnswer((_) async => tFavoritesResponse);

      // Act
      final result = await repository.getFavorites();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should succeed'),
        (favorites) {
          expect(favorites, isA<List<FavoriteEntity>>());
          expect(favorites.length, 2);
          expect(favorites[0].id, '123');
          expect(favorites[0].imageId, 'abc123');
          expect(favorites[0].imageUrl, 'https://cdn2.thedogapi.com/images/abc123.jpg');
          expect(favorites[0].petName, 'Golden Retriever');
          expect(favorites[0].breedName, 'Golden Retriever');
          expect(favorites[1].id, '456');
          expect(favorites[1].imageId, 'xyz789');
        },
      );
      verify(() => mockApiService.getFavorites()).called(1);
    });

    test('should return empty list when no favorites exist', () async {
      // Arrange
      when(() => mockApiService.getFavorites()).thenAnswer((_) async => []);

      // Act
      final result = await repository.getFavorites();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should succeed'),
        (favorites) {
          expect(favorites, isEmpty);
        },
      );
    });

    test('should handle favorites without image object (constructs URL from imageId)', () async {
      // Arrange
      final responsesWithoutImage = [
        {
          'id': 999,
          'image_id': 'test-id',
          'sub_id': 'user-123',
          'created_at': '2024-01-15T10:30:00.000Z',
        },
      ];

      when(() => mockApiService.getFavorites())
          .thenAnswer((_) async => responsesWithoutImage);

      // Act
      final result = await repository.getFavorites();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should succeed'),
        (favorites) {
          expect(favorites.length, 1);
          expect(favorites[0].imageUrl, 'https://cdn2.thedogapi.com/images/test-id.jpg');
        },
      );
    });

    test('should return ServerFailure on DioException with response', () async {
      // Arrange
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/favourites'),
        response: Response(
          requestOptions: RequestOptions(path: '/favourites'),
          statusCode: 404,
          data: {'message': 'Not found'},
        ),
        type: DioExceptionType.badResponse,
      );

      when(() => mockApiService.getFavorites()).thenThrow(dioException);

      // Act
      final result = await repository.getFavorites();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('Failed to fetch favorites'));
          expect(failure.message, contains('404'));
          expect(failure.message, contains('Not found'));
        },
        (_) => fail('Should fail'),
      );
    });

    test('should return ServerFailure on DioException without response', () async {
      // Arrange
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/favourites'),
        message: 'Connection timeout',
        type: DioExceptionType.connectionTimeout,
      );

      when(() => mockApiService.getFavorites()).thenThrow(dioException);

      // Act
      final result = await repository.getFavorites();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('Failed to fetch favorites'));
          expect(failure.message, contains('Connection timeout'));
        },
        (_) => fail('Should fail'),
      );
    });

    test('should return UnknownFailure on non-Dio exceptions', () async {
      // Arrange
      when(() => mockApiService.getFavorites())
          .thenThrow(Exception('Unexpected error'));

      // Act
      final result = await repository.getFavorites();

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

    test('should handle malformed JSON gracefully', () async {
      // Arrange
      final malformedResponse = [
        {
          'id': null,
          'image_id': null,
          'created_at': 'invalid-date',
        },
      ];

      when(() => mockApiService.getFavorites())
          .thenAnswer((_) async => malformedResponse);

      // Act
      final result = await repository.getFavorites();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should succeed'),
        (favorites) {
          expect(favorites.length, 1);
          expect(favorites[0].id, '0'); // Default id
          expect(favorites[0].imageId, ''); // Default imageId
        },
      );
    });
  });

  group('addFavorite', () {
    const tImageId = 'abc123';
    const tSubId = 'user-123';

    final tAddFavoriteResponse = {
      'id': 789,
      'message': 'SUCCESS',
    };

    test('should return FavoriteEntity on successful addition', () async {
      // Arrange
      when(() => mockApiService.addToFavorites(any()))
          .thenAnswer((_) async => tAddFavoriteResponse);

      // Act
      final result = await repository.addFavorite(imageId: tImageId);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should succeed'),
        (favorite) {
          expect(favorite, isA<FavoriteEntity>());
          expect(favorite.id, '789');
          expect(favorite.imageId, tImageId);
          expect(favorite.imageUrl, 'https://cdn2.thedogapi.com/images/$tImageId.jpg');
          expect(favorite.createdAt, isA<DateTime>());
        },
      );
      verify(() => mockApiService.addToFavorites(tImageId)).called(1);
    });

    test('should pass imageId to API service correctly', () async {
      // Arrange
      when(() => mockApiService.addToFavorites(any()))
          .thenAnswer((_) async => tAddFavoriteResponse);

      // Act
      await repository.addFavorite(imageId: tImageId, subId: tSubId);

      // Assert
      verify(() => mockApiService.addToFavorites(tImageId)).called(1);
    });

    test('should handle response with null id', () async {
      // Arrange
      final responseWithNullId = {
        'id': null,
        'message': 'SUCCESS',
      };

      when(() => mockApiService.addToFavorites(any()))
          .thenAnswer((_) async => responseWithNullId);

      // Act
      final result = await repository.addFavorite(imageId: tImageId);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should succeed'),
        (favorite) {
          expect(favorite.id, '0'); // Default id when null
        },
      );
    });

    test('should return ServerFailure on DioException with response', () async {
      // Arrange
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/favourites'),
        response: Response(
          requestOptions: RequestOptions(path: '/favourites'),
          statusCode: 400,
          data: {'message': 'Image already favorited'},
        ),
        type: DioExceptionType.badResponse,
      );

      when(() => mockApiService.addToFavorites(any())).thenThrow(dioException);

      // Act
      final result = await repository.addFavorite(imageId: tImageId);

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

    test('should return ServerFailure on DioException without response data', () async {
      // Arrange
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/favourites'),
        response: Response(
          requestOptions: RequestOptions(path: '/favourites'),
          statusCode: 500,
        ),
        message: 'Server error',
        type: DioExceptionType.badResponse,
      );

      when(() => mockApiService.addToFavorites(any())).thenThrow(dioException);

      // Act
      final result = await repository.addFavorite(imageId: tImageId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('500'));
        },
        (_) => fail('Should fail'),
      );
    });

    test('should return ServerFailure on network timeout', () async {
      // Arrange
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/favourites'),
        message: 'Connection timeout',
        type: DioExceptionType.connectionTimeout,
      );

      when(() => mockApiService.addToFavorites(any())).thenThrow(dioException);

      // Act
      final result = await repository.addFavorite(imageId: tImageId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('Connection timeout'));
        },
        (_) => fail('Should fail'),
      );
    });

    test('should return UnknownFailure on non-Dio exceptions', () async {
      // Arrange
      when(() => mockApiService.addToFavorites(any()))
          .thenThrow(FormatException('Invalid format'));

      // Act
      final result = await repository.addFavorite(imageId: tImageId);

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
  });

  group('removeFavorite', () {
    const tFavoriteId = '123';
    const tInvalidFavoriteId = 'invalid-id';

    test('should return success (Right(null)) when favorite is removed', () async {
      // Arrange
      when(() => mockApiService.deleteFavorite(any()))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.removeFavorite(favoriteId: tFavoriteId);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockApiService.deleteFavorite(123)).called(1);
    });

    test('should parse favoriteId correctly as int', () async {
      // Arrange
      when(() => mockApiService.deleteFavorite(any()))
          .thenAnswer((_) async {});

      // Act
      await repository.removeFavorite(favoriteId: '456');

      // Assert
      verify(() => mockApiService.deleteFavorite(456)).called(1);
    });

    test('should return UnknownFailure when favoriteId is not a valid integer', () async {
      // Act
      final result = await repository.removeFavorite(favoriteId: tInvalidFavoriteId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<UnknownFailure>());
          expect(failure.message, contains('Invalid favorite ID'));
          expect(failure.message, contains(tInvalidFavoriteId));
        },
        (_) => fail('Should fail'),
      );
      verifyNever(() => mockApiService.deleteFavorite(any()));
    });

    test('should return UnknownFailure when favoriteId is empty', () async {
      // Act
      final result = await repository.removeFavorite(favoriteId: '');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<UnknownFailure>());
          expect(failure.message, contains('Invalid favorite ID'));
        },
        (_) => fail('Should fail'),
      );
    });

    test('should return UnknownFailure when favoriteId contains non-numeric characters', () async {
      // Act
      final result = await repository.removeFavorite(favoriteId: '123abc');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<UnknownFailure>());
          expect(failure.message, contains('Invalid favorite ID'));
        },
        (_) => fail('Should fail'),
      );
    });

    test('should return ServerFailure on DioException with response', () async {
      // Arrange
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/favourites/123'),
        response: Response(
          requestOptions: RequestOptions(path: '/favourites/123'),
          statusCode: 404,
          data: {'message': 'Favorite not found'},
        ),
        type: DioExceptionType.badResponse,
      );

      when(() => mockApiService.deleteFavorite(any())).thenThrow(dioException);

      // Act
      final result = await repository.removeFavorite(favoriteId: tFavoriteId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('Failed to remove favorite'));
          expect(failure.message, contains('404'));
          expect(failure.message, contains('Favorite not found'));
        },
        (_) => fail('Should fail'),
      );
    });

    test('should return ServerFailure on DioException without response', () async {
      // Arrange
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/favourites/123'),
        message: 'Network error',
        type: DioExceptionType.connectionError,
      );

      when(() => mockApiService.deleteFavorite(any())).thenThrow(dioException);

      // Act
      final result = await repository.removeFavorite(favoriteId: tFavoriteId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('Network error'));
        },
        (_) => fail('Should fail'),
      );
    });

    test('should return UnknownFailure on non-Dio exceptions', () async {
      // Arrange
      when(() => mockApiService.deleteFavorite(any()))
          .thenThrow(StateError('Invalid state'));

      // Act
      final result = await repository.removeFavorite(favoriteId: tFavoriteId);

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

    test('should handle very large favorite IDs', () async {
      // Arrange
      const largeId = '9999999999999';
      when(() => mockApiService.deleteFavorite(any()))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.removeFavorite(favoriteId: largeId);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockApiService.deleteFavorite(9999999999999)).called(1);
    });
  });
}
