import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/features/details/domain/repositories/dog_details_repo.dart';
import 'package:animals_tasks/features/details/domain/usecases/get_dog_details_usecase.dart';
import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDogDetailsRepository extends Mock implements DogDetailsRepository {}

void main() {
  late GetDogDetailsUseCase useCase;
  late MockDogDetailsRepository mockRepository;

  setUp(() {
    mockRepository = MockDogDetailsRepository();
    useCase = GetDogDetailsUseCase(mockRepository);
  });

  const testDogId = '1';
  const testDog = DogEntity(
    id: '1',
    name: 'Golden Retriever',
    imageUrl: 'https://example.com/image.jpg',
    gender: 'Male',
    age: '2 years',
    weight: '30 kg',
    distance: '2.5 km',
    breedGroup: 'Sporting',
    description: 'Friendly and intelligent dog',
  );

  group('GetDogDetailsUseCase', () {
    test('should get dog details from the repository', () async {
      // Arrange
      when(() => mockRepository.getDogDetails(testDogId))
          .thenAnswer((_) async => const Right(testDog));

      // Act
      final result = await useCase(testDogId);

      // Assert
      expect(result, const Right(testDog));
      verify(() => mockRepository.getDogDetails(testDogId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      final failure = ServerFailure('Server error');
      when(() => mockRepository.getDogDetails(testDogId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(testDogId);

      // Assert
      expect(result, Left(failure));
      verify(() => mockRepository.getDogDetails(testDogId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
