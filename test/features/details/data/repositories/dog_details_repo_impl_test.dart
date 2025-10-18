import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/core/services/dog_api_service.dart';
import 'package:animals_tasks/features/details/data/repositories/dog_details_repo_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDogApiService extends Mock implements DogApiService {}

void main() {
  late DogDetailsRepositoryImpl repository;
  late MockDogApiService mockApiService;

  setUp(() {
    mockApiService = MockDogApiService();
    repository = DogDetailsRepositoryImpl(mockApiService);
  });

  group('DogDetailsRepositoryImpl', () {
    group('getDogDetails', () {
      test('should return DogEntity when dog breed ID is provided (numeric)',
          () async {
        // Arrange
        const dogId = '1';
        final mockResponse = {
          'id': 1,
          'name': 'Golden Retriever',
          'bred_for': 'Hunting',
          'breed_group': 'Sporting',
          'life_span': '10-12 years',
          'temperament': 'Friendly, Intelligent',
          'reference_image_id': 'abc123',
          'weight': {'metric': '25-32'},
        };

        when(() => mockApiService.getBreedById(1))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.getDogDetails(dogId);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should return dog entity'),
          (dog) {
            expect(dog.name, 'Golden Retriever');
            expect(dog.breedGroup, 'Sporting');
            expect(dog.imageUrl, contains('abc123'));
          },
        );
        verify(() => mockApiService.getBreedById(1)).called(1);
      });

      test('should return DogEntity when cat image ID is provided (string)',
          () async {
        // Arrange
        const catId = 'cat_abc123';
        final mockResponse = {
          'id': 'cat_abc123',
          'url': 'https://example.com/cat.jpg',
          'breeds': [
            {
              'name': 'Siamese',
              'temperament': 'Affectionate, Intelligent',
              'life_span': '12-15',
              'weight': {'metric': '3-5'},
              'description': 'Beautiful cat breed',
            }
          ],
        };

        when(() => mockApiService.getImageById(catId))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.getDogDetails(catId);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should return cat entity'),
          (cat) {
            expect(cat.name, 'Siamese');
            expect(cat.breedGroup, 'Affectionate, Intelligent');
            expect(cat.description, 'Beautiful cat breed');
          },
        );
        verify(() => mockApiService.getImageById(catId)).called(1);
      });

      test('should return ServerFailure when DioException occurs', () async {
        // Arrange
        const dogId = '1';
        when(() => mockApiService.getBreedById(1))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          message: 'Network error',
        ));

        // Act
        final result = await repository.getDogDetails(dogId);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.message, contains('API Error'));
          },
          (dog) => fail('Should return failure'),
        );
      });

      test('should return UnknownFailure when unexpected error occurs',
          () async {
        // Arrange
        const dogId = '1';
        when(() => mockApiService.getBreedById(1))
            .thenThrow(Exception('Unexpected error'));

        // Act
        final result = await repository.getDogDetails(dogId);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, contains('Unexpected error'));
          },
          (dog) => fail('Should return failure'),
        );
      });
    });

    group('🌐 Network Failure Edge Cases', () {
      test('🌐 handles connection timeout for dog breed', () async {
        const dogId = '1';
        when(() => mockApiService.getBreedById(1)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/breeds/1'),
            message: 'Connection timeout',
            type: DioExceptionType.connectionTimeout,
          ),
        );

        final result = await repository.getDogDetails(dogId);

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.message, contains('API Error'));
          },
          (dog) => fail('Should return failure'),
        );
      });

      test('🌐 handles receive timeout for cat image', () async {
        const catId = 'cat_abc123';
        when(() => mockApiService.getImageById(catId)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/images/$catId'),
            message: 'Receive timeout',
            type: DioExceptionType.receiveTimeout,
          ),
        );

        final result = await repository.getDogDetails(catId);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (dog) => fail('Should return failure'),
        );
      });

      test('🚫 handles 401 Unauthorized', () async {
        const dogId = '1';
        when(() => mockApiService.getBreedById(1)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/breeds/1'),
            response: Response(
              requestOptions: RequestOptions(path: '/breeds/1'),
              statusCode: 401,
              data: {'message': 'Unauthorized'},
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        final result = await repository.getDogDetails(dogId);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (dog) => fail('Should return failure'),
        );
      });

      test('🚫 handles 404 Not Found', () async {
        const dogId = '999';
        when(() => mockApiService.getBreedById(999)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/breeds/999'),
            response: Response(
              requestOptions: RequestOptions(path: '/breeds/999'),
              statusCode: 404,
              data: {'message': 'Breed not found'},
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        final result = await repository.getDogDetails(dogId);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (dog) => fail('Should return failure'),
        );
      });

      test('🚫 handles 500 Internal Server Error', () async {
        const dogId = '1';
        when(() => mockApiService.getBreedById(1)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/breeds/1'),
            response: Response(
              requestOptions: RequestOptions(path: '/breeds/1'),
              statusCode: 500,
              data: {'message': 'Internal Server Error'},
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        final result = await repository.getDogDetails(dogId);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (dog) => fail('Should return failure'),
        );
      });

      test('🌐 handles connection error', () async {
        const dogId = '1';
        when(() => mockApiService.getBreedById(1)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/breeds/1'),
            message: 'No internet connection',
            type: DioExceptionType.connectionError,
          ),
        );

        final result = await repository.getDogDetails(dogId);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (dog) => fail('Should return failure'),
        );
      });

      test('🚫 handles request cancellation', () async {
        const catId = 'cat_xyz';
        when(() => mockApiService.getImageById(catId)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/images/$catId'),
            message: 'Request cancelled',
            type: DioExceptionType.cancel,
          ),
        );

        final result = await repository.getDogDetails(catId);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (dog) => fail('Should return failure'),
        );
      });

      test('❓ handles FormatException', () async {
        const dogId = '1';
        when(() => mockApiService.getBreedById(1))
            .thenThrow(const FormatException('Invalid response'));

        final result = await repository.getDogDetails(dogId);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<UnknownFailure>()),
          (dog) => fail('Should return failure'),
        );
      });

      test('❓ handles TypeError', () async {
        const catId = 'cat_123';
        when(() => mockApiService.getImageById(catId)).thenThrow(TypeError());

        final result = await repository.getDogDetails(catId);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<UnknownFailure>()),
          (dog) => fail('Should return failure'),
        );
      });

      test('🚫 handles 503 Service Unavailable', () async {
        const dogId = '1';
        when(() => mockApiService.getBreedById(1)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/breeds/1'),
            response: Response(
              requestOptions: RequestOptions(path: '/breeds/1'),
              statusCode: 503,
              data: {'message': 'Service temporarily unavailable'},
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        final result = await repository.getDogDetails(dogId);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (dog) => fail('Should return failure'),
        );
      });

      test('🌐 handles send timeout', () async {
        const dogId = '1';
        when(() => mockApiService.getBreedById(1)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/breeds/1'),
            message: 'Send timeout',
            type: DioExceptionType.sendTimeout,
          ),
        );

        final result = await repository.getDogDetails(dogId);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (dog) => fail('Should return failure'),
        );
      });

      test('❓ handles invalid dog ID format', () async {
        const invalidId = 'invalid!@#';
        when(() => mockApiService.getImageById(invalidId))
            .thenThrow(ArgumentError('Invalid ID format'));

        final result = await repository.getDogDetails(invalidId);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<UnknownFailure>()),
          (dog) => fail('Should return failure'),
        );
      });

      test('✅ handles empty dog ID by treating as cat', () async {
        const emptyId = '';
        final mockResponse = {
          'id': '',
          'url': 'https://example.com/cat.jpg',
          'breeds': [
            {
              'name': 'Unknown',
              'temperament': 'Friendly',
              'life_span': '10-15',
              'weight': {'metric': '3-5'},
            }
          ],
        };

        when(() => mockApiService.getImageById(emptyId))
            .thenAnswer((_) async => mockResponse);

        final result = await repository.getDogDetails(emptyId);

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should return success'),
          (dog) => expect(dog.name, 'Unknown'),
        );
      });
    });
  });
}
