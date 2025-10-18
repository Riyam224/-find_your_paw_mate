import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:animals_tasks/features/home/domain/repositories/dog_repo.dart';
import 'package:animals_tasks/features/home/domain/usecases/search_dogs_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDogRepository extends Mock implements DogRepository {}

void main() {
  late MockDogRepository mockRepo;
  late SearchDogsUseCase usecase;

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
    usecase = SearchDogsUseCase(mockRepo);
  });

  group('🐶 SearchDogsUseCase', () {
    const tQuery = 'Bulldog';

    test('returns dog list on success', () async {
      when(
        () => mockRepo.searchDogs(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => Right(tDogs));

      final result = await usecase(query: tQuery, limit: 10, page: 0);

      expect(result, Right(tDogs));
      verify(
        () => mockRepo.searchDogs(query: tQuery, limit: 10, page: 0),
      ).called(1);
    });

    test('returns ServerFailure when repository fails', () async {
      when(
        () => mockRepo.searchDogs(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => Left(ServerFailure('API Error')));

      final result = await usecase(query: tQuery, limit: 5, page: 2);

      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected ServerFailure but got success'),
      );
    });

    test('returns empty list when no results found', () async {
      when(
        () => mockRepo.searchDogs(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => const Right([]));

      final result = await usecase(query: 'NothingHere');

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), isEmpty);
    });

    test('throws when unexpected exception occurs', () async {
      when(
        () => mockRepo.searchDogs(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenThrow(Exception('Unexpected error'));

      expect(
        () async => await usecase(query: tQuery),
        throwsA(isA<Exception>()),
      );
    });

    test('returns NetworkFailure when internet is down', () async {
      when(
        () => mockRepo.searchDogs(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => Left(NetworkFailure('No internet')));

      final result = await usecase(query: tQuery);

      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected NetworkFailure but got success'),
      );
    });

    test('returns UnknownFailure on unexpected error', () async {
      when(
        () => mockRepo.searchDogs(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer(
        (_) async => Left(UnknownFailure('Something weird happened')),
      );

      final result = await usecase(query: tQuery);

      result.fold(
        (failure) => expect(failure, isA<UnknownFailure>()),
        (_) => fail('Expected UnknownFailure but got success'),
      );
    });

    test('handles multiple search results correctly', () async {
      when(
        () => mockRepo.searchDogs(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => Right(tMultipleDogs));

      final result = await usecase(query: 'dog');

      result.fold((_) => fail('Should not fail'), (dogs) {
        expect(dogs.length, 3);
        expect(dogs[1].name, 'Bulldog');
      });
    });

    test('uses default params when none provided', () async {
      when(
        () => mockRepo.searchDogs(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => Right(tDogs));

      final result = await usecase(query: tQuery);

      expect(result, Right(tDogs));
      verify(
        () => mockRepo.searchDogs(query: tQuery, limit: 10, page: 0),
      ).called(1);
    });

    test('works with custom limit', () async {
      when(
        () => mockRepo.searchDogs(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => Right(tDogs));

      await usecase(query: tQuery, limit: 50);
      verify(
        () => mockRepo.searchDogs(query: tQuery, limit: 50, page: 0),
      ).called(1);
    });

    test('works with custom page', () async {
      when(
        () => mockRepo.searchDogs(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => Right(tDogs));

      await usecase(query: tQuery, page: 5);
      verify(
        () => mockRepo.searchDogs(query: tQuery, limit: 10, page: 5),
      ).called(1);
    });

    test('handles limit = 1 properly', () async {
      when(
        () => mockRepo.searchDogs(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => Right([tDog]));

      final result = await usecase(query: tQuery, limit: 1);
      result.fold(
        (_) => fail('Should not fail'),
        (dogs) => expect(dogs.length, 1),
      );
    });

    test('handles large limit gracefully', () async {
      when(
        () => mockRepo.searchDogs(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => Right(tMultipleDogs));

      final result = await usecase(query: tQuery, limit: 100);
      expect(result.isRight(), true);
    });

    test('handles very large page numbers', () async {
      when(
        () => mockRepo.searchDogs(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => const Right([]));

      final result = await usecase(query: tQuery, page: 999);
      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), isEmpty);
    });

    test('handles empty search query', () async {
      when(
        () => mockRepo.searchDogs(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => const Right([]));

      final result = await usecase(query: '');

      expect(result.isRight(), true);
      verify(
        () => mockRepo.searchDogs(query: '', limit: 10, page: 0),
      ).called(1);
    });

    test('handles query with spaces', () async {
      when(
        () => mockRepo.searchDogs(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => Right(tDogs));

      final result = await usecase(query: '  Bulldog  ');
      expect(result.isRight(), true);
      verify(
        () => mockRepo.searchDogs(query: '  Bulldog  ', limit: 10, page: 0),
      ).called(1);
    });

    test('handles special characters in query', () async {
      when(
        () => mockRepo.searchDogs(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => Right(tDogs));

      final result = await usecase(query: 'Bull-dog');
      expect(result.isRight(), true);
      verify(
        () => mockRepo.searchDogs(query: 'Bull-dog', limit: 10, page: 0),
      ).called(1);
    });

    test('handles case sensitivity correctly', () async {
      when(
        () => mockRepo.searchDogs(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => Right(tDogs));

      await usecase(query: 'bulldog');
      verify(
        () => mockRepo.searchDogs(query: 'bulldog', limit: 10, page: 0),
      ).called(1);

      await usecase(query: 'BULLDOG');
      verify(
        () => mockRepo.searchDogs(query: 'BULLDOG', limit: 10, page: 0),
      ).called(1);
    });
  });
}
