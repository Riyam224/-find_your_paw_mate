// ignore_for_file: unnecessary_cast

import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:animals_tasks/features/home/domain/usecases/search_dogs_usecase.dart';
import 'package:animals_tasks/features/home/presentation/cubit/search_dogs/search_dogs_cubit.dart';
import 'package:animals_tasks/features/home/presentation/cubit/search_dogs/search_dogs_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchDogsUseCase extends Mock implements SearchDogsUseCase {}

void main() {
  late SearchDogsCubit cubit;
  late MockSearchDogsUseCase mockUseCase;

  final tDogs = [
    const DogEntity(id: '1', name: 'Beagle', imageUrl: 'url1'),
    const DogEntity(id: '2', name: 'Husky', imageUrl: 'url2'),
  ];

  setUp(() {
    mockUseCase = MockSearchDogsUseCase();
    cubit = SearchDogsCubit(mockUseCase);
  });

  tearDown(() => cubit.close());

  group('🔍 SearchDogsCubit', () {
    blocTest<SearchDogsCubit, SearchDogsState>(
      'emits [Loading, Loaded] when searchDogs succeeds with results',
      build: () {
        when(
          () => mockUseCase(
            query: any(named: 'query'),
            limit: any(named: 'limit'),
            page: any(named: 'page'),
          ),
        ).thenAnswer((_) async => Right(tDogs));
        return cubit;
      },
      act: (cubit) => cubit.searchDogs('beagle'),
      expect: () => [
        isA<SearchDogsLoading>(),
        isA<SearchDogsLoaded>()
            .having((s) => (s as SearchDogsLoaded).dogs.length, 'dogs count', 2)
            .having((s) => (s as SearchDogsLoaded).query, 'query', 'beagle'),
      ],
      verify: (_) {
        verify(
          () => mockUseCase(query: 'beagle', limit: 20, page: 0),
        ).called(1);
      },
    );

    blocTest<SearchDogsCubit, SearchDogsState>(
      'emits [Loading, Empty] when search returns no dogs',
      build: () {
        when(
          () => mockUseCase(
            query: any(named: 'query'),
            limit: any(named: 'limit'),
            page: any(named: 'page'),
          ),
        ).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.searchDogs('unknown'),
      expect: () => [
        isA<SearchDogsLoading>(),
        isA<SearchDogsEmpty>().having(
          (s) => (s as SearchDogsEmpty).query,
          'query',
          'unknown',
        ),
      ],
    );

    blocTest<SearchDogsCubit, SearchDogsState>(
      'emits [Loading, Error] when search fails',
      build: () {
        when(
          () => mockUseCase(
            query: any(named: 'query'),
            limit: any(named: 'limit'),
            page: any(named: 'page'),
          ),
        ).thenAnswer((_) async => Left(ServerFailure('API Error')));
        return cubit;
      },
      act: (cubit) => cubit.searchDogs('husky'),
      expect: () => [
        isA<SearchDogsLoading>(),
        isA<SearchDogsError>().having(
          (s) => (s as SearchDogsError).message,
          'error',
          contains('API Error'),
        ),
      ],
    );

    blocTest<SearchDogsCubit, SearchDogsState>(
      'emits only [Initial] when query is empty',
      build: () => cubit,
      act: (cubit) => cubit.searchDogs('   '),
      expect: () => [isA<SearchDogsInitial>()],
      verify: (_) => verifyNever(() => mockUseCase(query: any(named: 'query'))),
    );

    blocTest<SearchDogsCubit, SearchDogsState>(
      'emits [Initial] when clearSearch() is called',
      build: () => cubit,
      act: (cubit) => cubit.clearSearch(),
      expect: () => [isA<SearchDogsInitial>()],
    );

    blocTest<SearchDogsCubit, SearchDogsState>(
      'handles NetworkFailure',
      build: () {
        when(
          () => mockUseCase(
            query: any(named: 'query'),
            limit: any(named: 'limit'),
            page: any(named: 'page'),
          ),
        ).thenAnswer((_) async => Left(NetworkFailure('No internet connection')));
        return cubit;
      },
      act: (cubit) => cubit.searchDogs('test'),
      expect: () => [
        isA<SearchDogsLoading>(),
        isA<SearchDogsError>().having(
          (s) => (s as SearchDogsError).message,
          'error',
          contains('No internet'),
        ),
      ],
    );

    blocTest<SearchDogsCubit, SearchDogsState>(
      'handles UnknownFailure',
      build: () {
        when(
          () => mockUseCase(
            query: any(named: 'query'),
            limit: any(named: 'limit'),
            page: any(named: 'page'),
          ),
        ).thenAnswer((_) async => Left(UnknownFailure('Unexpected error')));
        return cubit;
      },
      act: (cubit) => cubit.searchDogs('test'),
      expect: () => [
        isA<SearchDogsLoading>(),
        isA<SearchDogsError>().having(
          (s) => (s as SearchDogsError).message,
          'error',
          contains('Unexpected error'),
        ),
      ],
    );

    blocTest<SearchDogsCubit, SearchDogsState>(
      'handles special characters in query',
      build: () {
        when(
          () => mockUseCase(
            query: any(named: 'query'),
            limit: any(named: 'limit'),
            page: any(named: 'page'),
          ),
        ).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.searchDogs('!@#\$%'),
      expect: () => [
        isA<SearchDogsLoading>(),
        isA<SearchDogsEmpty>(),
      ],
      verify: (_) {
        verify(
          () => mockUseCase(query: '!@#\$%', limit: 20, page: 0),
        ).called(1);
      },
    );

    blocTest<SearchDogsCubit, SearchDogsState>(
      'handles very long query string',
      build: () {
        when(
          () => mockUseCase(
            query: any(named: 'query'),
            limit: any(named: 'limit'),
            page: any(named: 'page'),
          ),
        ).thenAnswer((_) async => Right(tDogs));
        return cubit;
      },
      act: (cubit) => cubit.searchDogs('a' * 100),
      expect: () => [
        isA<SearchDogsLoading>(),
        isA<SearchDogsLoaded>(),
      ],
    );

    blocTest<SearchDogsCubit, SearchDogsState>(
      'handles query with only spaces',
      build: () => cubit,
      act: (cubit) => cubit.searchDogs('     '),
      expect: () => [isA<SearchDogsInitial>()],
      verify: (_) => verifyNever(() => mockUseCase(query: any(named: 'query'))),
    );

    blocTest<SearchDogsCubit, SearchDogsState>(
      'handles empty string query',
      build: () => cubit,
      act: (cubit) => cubit.searchDogs(''),
      expect: () => [isA<SearchDogsInitial>()],
      verify: (_) => verifyNever(() => mockUseCase(query: any(named: 'query'))),
    );

    blocTest<SearchDogsCubit, SearchDogsState>(
      'handles query with leading/trailing spaces',
      build: () {
        when(
          () => mockUseCase(
            query: any(named: 'query'),
            limit: any(named: 'limit'),
            page: any(named: 'page'),
          ),
        ).thenAnswer((_) async => Right(tDogs));
        return cubit;
      },
      act: (cubit) => cubit.searchDogs('  bulldog  '),
      expect: () => [
        isA<SearchDogsLoading>(),
        isA<SearchDogsLoaded>(),
      ],
    );

    blocTest<SearchDogsCubit, SearchDogsState>(
      'handles single character query',
      build: () {
        when(
          () => mockUseCase(
            query: any(named: 'query'),
            limit: any(named: 'limit'),
            page: any(named: 'page'),
          ),
        ).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.searchDogs('a'),
      expect: () => [
        isA<SearchDogsLoading>(),
        isA<SearchDogsEmpty>(),
      ],
    );

    blocTest<SearchDogsCubit, SearchDogsState>(
      'handles numeric query',
      build: () {
        when(
          () => mockUseCase(
            query: any(named: 'query'),
            limit: any(named: 'limit'),
            page: any(named: 'page'),
          ),
        ).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.searchDogs('12345'),
      expect: () => [
        isA<SearchDogsLoading>(),
        isA<SearchDogsEmpty>(),
      ],
    );
  });
}
