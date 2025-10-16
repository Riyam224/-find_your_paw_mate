import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:animals_tasks/features/home/domain/repositories/dog_repo.dart';
import 'package:animals_tasks/features/home/domain/usecases/get_dogs_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDogRepository extends Mock implements DogRepository {}

void main() {
  late MockDogRepository mockRepo;
  late GetDogsUseCase usecase;

  final tDog = DogEntity(
    id: '1',
    name: 'Abyssinian',
    imageUrl: 'https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg',
  );

  final tDogs = [tDog];

  final tMultipleDogs = [
    tDog,
    DogEntity(
      id: '2',
      name: 'Bulldog',
      imageUrl: 'https://cdn2.thecatapi.com/images/1XYvRd7oD.jpg',
    ),
    DogEntity(
      id: '3',
      name: 'Poodle',
      imageUrl: 'https://cdn2.thecatapi.com/images/2XYvRd7oD.jpg',
    ),
  ];

  setUp(() {
    mockRepo = MockDogRepository();
    usecase = GetDogsUseCase(mockRepo);
  });

  group('🐾 GetDogsUseCase', () {
    test('returns list of DogEntity on success', () async {
      when(
        () => mockRepo.getDogs(
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => Right(tDogs));

      final result = await usecase(limit: 10, page: 0);

      expect(result, Right(tDogs));
      verify(() => mockRepo.getDogs(limit: 10, page: 0)).called(1);
    });

    test('returns ServerFailure when repository fails', () async {
      when(
        () => mockRepo.getDogs(
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => Left(ServerFailure('API Error')));

      final result = await usecase(limit: 5, page: 2);

      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
      verify(() => mockRepo.getDogs(limit: 5, page: 2)).called(1);
    });

    test('returns empty list when repository gives no data', () async {
      when(
        () => mockRepo.getDogs(
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => const Right([]));

      final result = await usecase();

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), isEmpty);
    });

    test('throws when unexpected exception happens', () async {
      when(
        () => mockRepo.getDogs(
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenThrow(Exception('Unexpected error'));

      expect(() async => await usecase(limit: 3), throwsA(isA<Exception>()));
    });

    test('returns NetworkFailure on network issue', () async {
      when(
        () => mockRepo.getDogs(
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => Left(NetworkFailure('No internet connection')));

      final result = await usecase(limit: 10, page: 0);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected failure'),
      );
    });

    test('returns UnknownFailure on unknown error', () async {
      when(
        () => mockRepo.getDogs(
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer(
        (_) async => Left(UnknownFailure('Something weird happened')),
      );

      final result = await usecase();

      result.fold(
        (failure) => expect(failure, isA<UnknownFailure>()),
        (_) => fail('Expected failure'),
      );
    });

    test('handles multiple dogs correctly', () async {
      when(
        () => mockRepo.getDogs(
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => Right(tMultipleDogs));

      final result = await usecase(limit: 20, page: 1);

      expect(result.isRight(), true);
      result.fold((_) => fail('Should not fail'), (dogs) {
        expect(dogs.length, 3);
        expect(dogs.first.name, 'Abyssinian');
      });
    });

    test('uses default parameters when not provided', () async {
      when(
        () => mockRepo.getDogs(
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => Right(tDogs));

      final result = await usecase();

      expect(result, Right(tDogs));
      verify(() => mockRepo.getDogs(limit: 10, page: 0)).called(1);
    });

    test('accepts custom limit parameter', () async {
      when(
        () => mockRepo.getDogs(
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => Right(tDogs));

      await usecase(limit: 50);
      verify(() => mockRepo.getDogs(limit: 50, page: 0)).called(1);
    });

    test('accepts custom page parameter', () async {
      when(
        () => mockRepo.getDogs(
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => Right(tDogs));

      await usecase(page: 5);
      verify(() => mockRepo.getDogs(limit: 10, page: 5)).called(1);
    });

    test('handles small limit gracefully', () async {
      when(
        () => mockRepo.getDogs(
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => Right([tDog]));

      final result = await usecase(limit: 1);
      result.fold(
        (_) => fail('Should not fail'),
        (dogs) => expect(dogs.length, 1),
      );
    });

    test('handles large limit value', () async {
      when(
        () => mockRepo.getDogs(
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => Right(tMultipleDogs));

      final result = await usecase(limit: 100);
      expect(result.isRight(), true);
    });

    test('handles very high page number', () async {
      when(
        () => mockRepo.getDogs(
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => const Right([]));

      final result = await usecase(limit: 10, page: 999);

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), isEmpty);
    });
  });
}
