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
  });
}
