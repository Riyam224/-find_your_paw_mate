import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:animals_tasks/features/favorite/domain/usecases/remove_favorite_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

void main() {
  late MockFavoriteRepository mockRepository;
  late RemoveFavoriteUseCase useCase;

  const tFavoriteId = '123';
  const tInvalidFavoriteId = 'invalid-id';

  setUp(() {
    mockRepository = MockFavoriteRepository();
    useCase = RemoveFavoriteUseCase(mockRepository);
  });

  group('RemoveFavoriteUseCase', () {
    test('should return success when favorite is removed', () async {
      // Arrange
      when(
        () => mockRepository.removeFavorite(favoriteId: any(named: 'favoriteId')),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(favoriteId: tFavoriteId);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockRepository.removeFavorite(favoriteId: tFavoriteId)).called(1);
    });

    test('should pass favoriteId parameter correctly', () async {
      // Arrange
      const customFavoriteId = '456';
      when(
        () => mockRepository.removeFavorite(favoriteId: any(named: 'favoriteId')),
      ).thenAnswer((_) async => const Right(null));

      // Act
      await useCase(favoriteId: customFavoriteId);

      // Assert
      verify(() => mockRepository.removeFavorite(favoriteId: customFavoriteId)).called(1);
    });

    test('should handle numeric string favoriteId', () async {
      // Arrange
      const numericId = '999';
      when(
        () => mockRepository.removeFavorite(favoriteId: any(named: 'favoriteId')),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(favoriteId: numericId);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockRepository.removeFavorite(favoriteId: numericId)).called(1);
    });

    test('should handle very large favoriteId', () async {
      // Arrange
      const largeId = '9999999999999';
      when(
        () => mockRepository.removeFavorite(favoriteId: any(named: 'favoriteId')),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(favoriteId: largeId);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockRepository.removeFavorite(favoriteId: largeId)).called(1);
    });

    test('should return UnknownFailure when favoriteId is invalid', () async {
      // Arrange
      when(
        () => mockRepository.removeFavorite(favoriteId: any(named: 'favoriteId')),
      ).thenAnswer((_) async => Left(UnknownFailure('Invalid favorite ID: $tInvalidFavoriteId')));

      // Act
      final result = await useCase(favoriteId: tInvalidFavoriteId);

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
    });

    test('should return UnknownFailure when favoriteId is empty', () async {
      // Arrange
      const emptyId = '';
      when(
        () => mockRepository.removeFavorite(favoriteId: any(named: 'favoriteId')),
      ).thenAnswer((_) async => Left(UnknownFailure('Invalid favorite ID: $emptyId')));

      // Act
      final result = await useCase(favoriteId: emptyId);

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

    test('should return UnknownFailure for non-numeric favoriteId', () async {
      // Arrange
      const alphaId = 'abc123';
      when(
        () => mockRepository.removeFavorite(favoriteId: any(named: 'favoriteId')),
      ).thenAnswer((_) async => Left(UnknownFailure('Invalid favorite ID: $alphaId')));

      // Act
      final result = await useCase(favoriteId: alphaId);

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

    test('should return ServerFailure when favorite not found', () async {
      // Arrange
      when(
        () => mockRepository.removeFavorite(favoriteId: any(named: 'favoriteId')),
      ).thenAnswer((_) async => Left(ServerFailure('Failed to remove favorite [404]: Favorite not found')));

      // Act
      final result = await useCase(favoriteId: tFavoriteId);

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

    test('should return ServerFailure on 500 server error', () async {
      // Arrange
      when(
        () => mockRepository.removeFavorite(favoriteId: any(named: 'favoriteId')),
      ).thenAnswer((_) async => Left(ServerFailure('Failed to remove favorite [500]: Internal server error')));

      // Act
      final result = await useCase(favoriteId: tFavoriteId);

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

    test('should return NetworkFailure on network issue', () async {
      // Arrange
      when(
        () => mockRepository.removeFavorite(favoriteId: any(named: 'favoriteId')),
      ).thenAnswer((_) async => Left(NetworkFailure('No internet connection')));

      // Act
      final result = await useCase(favoriteId: tFavoriteId);

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
        () => mockRepository.removeFavorite(favoriteId: any(named: 'favoriteId')),
      ).thenAnswer((_) async => Left(UnknownFailure('Unexpected error occurred')));

      // Act
      final result = await useCase(favoriteId: tFavoriteId);

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
        () => mockRepository.removeFavorite(favoriteId: any(named: 'favoriteId')),
      ).thenThrow(Exception('Unexpected exception'));

      // Act & Assert
      expect(
        () async => await useCase(favoriteId: tFavoriteId),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle authorization errors', () async {
      // Arrange
      when(
        () => mockRepository.removeFavorite(favoriteId: any(named: 'favoriteId')),
      ).thenAnswer((_) async => Left(ServerFailure('Failed to remove favorite [401]: Unauthorized')));

      // Act
      final result = await useCase(favoriteId: tFavoriteId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('401'));
          expect(failure.message, contains('Unauthorized'));
        },
        (_) => fail('Should fail'),
      );
    });

    test('should handle forbidden errors', () async {
      // Arrange
      when(
        () => mockRepository.removeFavorite(favoriteId: any(named: 'favoriteId')),
      ).thenAnswer((_) async => Left(ServerFailure('Failed to remove favorite [403]: Forbidden')));

      // Act
      final result = await useCase(favoriteId: tFavoriteId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('403'));
          expect(failure.message, contains('Forbidden'));
        },
        (_) => fail('Should fail'),
      );
    });

    test('should handle timeout errors', () async {
      // Arrange
      when(
        () => mockRepository.removeFavorite(favoriteId: any(named: 'favoriteId')),
      ).thenAnswer((_) async => Left(ServerFailure('Failed to remove favorite [0]: Connection timeout')));

      // Act
      final result = await useCase(favoriteId: tFavoriteId);

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

    test('should call repository exactly once', () async {
      // Arrange
      when(
        () => mockRepository.removeFavorite(favoriteId: any(named: 'favoriteId')),
      ).thenAnswer((_) async => const Right(null));

      // Act
      await useCase(favoriteId: tFavoriteId);

      // Assert
      verify(() => mockRepository.removeFavorite(favoriteId: tFavoriteId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle removing already removed favorite', () async {
      // Arrange
      when(
        () => mockRepository.removeFavorite(favoriteId: any(named: 'favoriteId')),
      ).thenAnswer((_) async => Left(ServerFailure('Failed to remove favorite [404]: INVALID_FAVOURITE_ID')));

      // Act
      final result = await useCase(favoriteId: tFavoriteId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('INVALID_FAVOURITE_ID'));
        },
        (_) => fail('Should fail'),
      );
    });

    test('should handle special characters in favoriteId', () async {
      // Arrange
      const specialId = '123-abc_456';
      when(
        () => mockRepository.removeFavorite(favoriteId: any(named: 'favoriteId')),
      ).thenAnswer((_) async => Left(UnknownFailure('Invalid favorite ID: $specialId')));

      // Act
      final result = await useCase(favoriteId: specialId);

      // Assert
      expect(result.isLeft(), true);
      verify(() => mockRepository.removeFavorite(favoriteId: specialId)).called(1);
    });

    test('should handle negative favoriteId', () async {
      // Arrange
      const negativeId = '-123';
      when(
        () => mockRepository.removeFavorite(favoriteId: any(named: 'favoriteId')),
      ).thenAnswer((_) async => Left(UnknownFailure('Invalid favorite ID: $negativeId')));

      // Act
      final result = await useCase(favoriteId: negativeId);

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

    test('should handle zero favoriteId', () async {
      // Arrange
      const zeroId = '0';
      when(
        () => mockRepository.removeFavorite(favoriteId: any(named: 'favoriteId')),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(favoriteId: zeroId);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockRepository.removeFavorite(favoriteId: zeroId)).called(1);
    });
  });
}
