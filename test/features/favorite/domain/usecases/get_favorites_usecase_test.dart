import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/features/favorite/domain/entities/favorite_entity.dart';
import 'package:animals_tasks/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:animals_tasks/features/favorite/domain/usecases/get_favorites_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

void main() {
  late MockFavoriteRepository mockRepository;
  late GetFavoritesUseCase useCase;

  final tFavorite1 = FavoriteEntity(
    id: '123',
    imageId: 'abc123',
    imageUrl: 'https://cdn2.thedogapi.com/images/abc123.jpg',
    subId: 'user-123',
    createdAt: DateTime(2024, 1, 15, 10, 30),
    petName: 'Golden Retriever',
    breedName: 'Golden Retriever',
    breedId: '1',
  );

  final tFavorite2 = FavoriteEntity(
    id: '456',
    imageId: 'xyz789',
    imageUrl: 'https://cdn2.thedogapi.com/images/xyz789.jpg',
    subId: 'user-123',
    createdAt: DateTime(2024, 1, 16, 14, 20),
    petName: 'Bulldog',
    breedName: 'Bulldog',
    breedId: '2',
  );

  final tFavorites = [tFavorite1, tFavorite2];

  setUp(() {
    mockRepository = MockFavoriteRepository();
    useCase = GetFavoritesUseCase(mockRepository);
  });

  group('GetFavoritesUseCase', () {
    test('should return list of FavoriteEntity on success', () async {
      // Arrange
      when(
        () => mockRepository.getFavorites(
          subId: any(named: 'subId'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => Right(tFavorites));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isRight(), true);
      expect(result, Right(tFavorites));
      result.fold(
        (_) => fail('Should succeed'),
        (favorites) {
          expect(favorites, isA<List<FavoriteEntity>>());
          expect(favorites.length, 2);
          expect(favorites[0].id, '123');
          expect(favorites[1].id, '456');
        },
      );
      verify(() => mockRepository.getFavorites(subId: null, limit: 10)).called(1);
    });

    test('should return empty list when no favorites exist', () async {
      // Arrange
      when(
        () => mockRepository.getFavorites(
          subId: any(named: 'subId'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => const Right([]));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should succeed'),
        (favorites) {
          expect(favorites, isEmpty);
        },
      );
    });

    test('should use default limit parameter when not provided', () async {
      // Arrange
      when(
        () => mockRepository.getFavorites(
          subId: any(named: 'subId'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => Right(tFavorites));

      // Act
      await useCase();

      // Assert
      verify(() => mockRepository.getFavorites(subId: null, limit: 10)).called(1);
    });

    test('should pass custom limit parameter correctly', () async {
      // Arrange
      when(
        () => mockRepository.getFavorites(
          subId: any(named: 'subId'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => Right(tFavorites));

      // Act
      await useCase(limit: 50);

      // Assert
      verify(() => mockRepository.getFavorites(subId: null, limit: 50)).called(1);
    });

    test('should pass subId parameter correctly', () async {
      // Arrange
      const tSubId = 'user-456';
      when(
        () => mockRepository.getFavorites(
          subId: any(named: 'subId'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => Right(tFavorites));

      // Act
      await useCase(subId: tSubId, limit: 20);

      // Assert
      verify(() => mockRepository.getFavorites(subId: tSubId, limit: 20)).called(1);
    });

    test('should handle small limit value gracefully', () async {
      // Arrange
      when(
        () => mockRepository.getFavorites(
          subId: any(named: 'subId'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => Right([tFavorite1]));

      // Act
      final result = await useCase(limit: 1);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should succeed'),
        (favorites) {
          expect(favorites.length, 1);
        },
      );
    });

    test('should handle large limit value', () async {
      // Arrange
      when(
        () => mockRepository.getFavorites(
          subId: any(named: 'subId'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => Right(tFavorites));

      // Act
      final result = await useCase(limit: 100);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockRepository.getFavorites(subId: null, limit: 100)).called(1);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(
        () => mockRepository.getFavorites(
          subId: any(named: 'subId'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => Left(ServerFailure('Failed to fetch favorites [404]: Not found')));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('Failed to fetch favorites'));
          expect(failure.message, contains('404'));
        },
        (_) => fail('Should fail'),
      );
    });

    test('should return NetworkFailure on network issue', () async {
      // Arrange
      when(
        () => mockRepository.getFavorites(
          subId: any(named: 'subId'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => Left(NetworkFailure('No internet connection')));

      // Act
      final result = await useCase(limit: 10);

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
        () => mockRepository.getFavorites(
          subId: any(named: 'subId'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => Left(UnknownFailure('Unexpected error occurred')));

      // Act
      final result = await useCase();

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
        () => mockRepository.getFavorites(
          subId: any(named: 'subId'),
          limit: any(named: 'limit'),
        ),
      ).thenThrow(Exception('Unexpected exception'));

      // Act & Assert
      expect(
        () async => await useCase(),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle multiple favorites correctly', () async {
      // Arrange
      final multipleFavorites = [
        tFavorite1,
        tFavorite2,
        FavoriteEntity(
          id: '789',
          imageId: 'def456',
          imageUrl: 'https://cdn2.thedogapi.com/images/def456.jpg',
          subId: 'user-123',
          createdAt: DateTime(2024, 1, 17, 9, 15),
        ),
      ];

      when(
        () => mockRepository.getFavorites(
          subId: any(named: 'subId'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => Right(multipleFavorites));

      // Act
      final result = await useCase(limit: 20);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should succeed'),
        (favorites) {
          expect(favorites.length, 3);
          expect(favorites[0].petName, 'Golden Retriever');
          expect(favorites[1].petName, 'Bulldog');
          expect(favorites[2].petName, isNull);
        },
      );
    });

    test('should handle favorites without optional fields', () async {
      // Arrange
      final favoriteWithoutOptionals = FavoriteEntity(
        id: '999',
        imageId: 'test-id',
        imageUrl: 'https://test.com/image.jpg',
        createdAt: DateTime.now(),
      );

      when(
        () => mockRepository.getFavorites(
          subId: any(named: 'subId'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => Right([favoriteWithoutOptionals]));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should succeed'),
        (favorites) {
          expect(favorites.length, 1);
          expect(favorites[0].subId, isNull);
          expect(favorites[0].petName, isNull);
          expect(favorites[0].breedName, isNull);
          expect(favorites[0].breedId, isNull);
        },
      );
    });

    test('should pass all parameters when both subId and limit provided', () async {
      // Arrange
      const tSubId = 'custom-user';
      const tLimit = 25;

      when(
        () => mockRepository.getFavorites(
          subId: any(named: 'subId'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => Right(tFavorites));

      // Act
      await useCase(subId: tSubId, limit: tLimit);

      // Assert
      verify(() => mockRepository.getFavorites(subId: tSubId, limit: tLimit)).called(1);
    });
  });
}
