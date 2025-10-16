// ignore_for_file: unnecessary_cast

import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:animals_tasks/features/home/domain/repositories/dog_repo.dart';
import 'package:animals_tasks/features/home/domain/usecases/get_dogs_usecase.dart';
import 'package:animals_tasks/features/home/presentation/cubit/get_dogs/get_dogs_cubit.dart';
import 'package:animals_tasks/features/home/presentation/cubit/get_dogs/get_dogs_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetDogsUseCase extends Mock implements GetDogsUseCase {}

class MockDogRepository extends Mock implements DogRepository {}

void main() {
  late GetDogsCubit cubit;
  late MockGetDogsUseCase mockUseCase;
  late MockDogRepository mockRepo;

  final tDogs = [
    const DogEntity(id: '1', name: 'Beagle', imageUrl: 'url1'),
    const DogEntity(id: '2', name: 'Poodle', imageUrl: 'url2'),
  ];

  setUp(() {
    mockUseCase = MockGetDogsUseCase();
    mockRepo = MockDogRepository();
    cubit = GetDogsCubit(mockUseCase, mockRepo);
  });

  tearDown(() => cubit.close());

  group('🐶 GetDogsCubit', () {
    blocTest<GetDogsCubit, GetDogsState>(
      'emits [Loading, Loaded] when fetchDogs succeeds',
      build: () {
        when(
          () => mockUseCase(
            limit: any(named: 'limit'),
            page: any(named: 'page'),
          ),
        ).thenAnswer((_) async => Right(tDogs));
        return cubit;
      },
      act: (cubit) => cubit.fetchDogs(),
      expect: () => [
        isA<GetDogsLoading>(),
        isA<GetDogsLoaded>().having(
          (s) => (s as GetDogsLoaded).dogs.length,
          'dogs count',
          2,
        ),
      ],
      verify: (_) {
        verify(() => mockUseCase(limit: 10, page: 0)).called(1);
      },
    );

    blocTest<GetDogsCubit, GetDogsState>(
      'emits [Loading, Error] when fetchDogs fails',
      build: () {
        when(
          () => mockUseCase(
            limit: any(named: 'limit'),
            page: any(named: 'page'),
          ),
        ).thenAnswer((_) async => Left(ServerFailure('API Error')));
        return cubit;
      },
      act: (cubit) => cubit.fetchDogs(),
      expect: () => [
        isA<GetDogsLoading>(),
        isA<GetDogsError>().having(
          (s) => (s as GetDogsError).message,
          'error',
          contains('API Error'),
        ),
      ],
    );

    blocTest<GetDogsCubit, GetDogsState>(
      'emits [Loading, Loaded] when fetchCatsByCategory succeeds',
      build: () {
        when(
          () => mockRepo.getCatsByCategory(any(), limit: any(named: 'limit')),
        ).thenAnswer((_) async => Right(tDogs));
        return cubit;
      },
      act: (cubit) => cubit.fetchCatsByCategory(1),
      expect: () => [
        isA<GetDogsLoading>(),
        isA<GetDogsLoaded>().having(
          (s) => (s as GetDogsLoaded).dogs.first.name,
          'first dog',
          'Beagle',
        ),
      ],
      verify: (_) {
        verify(() => mockRepo.getCatsByCategory(1, limit: 10)).called(1);
      },
    );

    blocTest<GetDogsCubit, GetDogsState>(
      'emits [Loading, Error] when fetchCatsByCategory fails',
      build: () {
        when(
          () => mockRepo.getCatsByCategory(any(), limit: any(named: 'limit')),
        ).thenAnswer((_) async => Left(ServerFailure('No internet')));
        return cubit;
      },
      act: (cubit) => cubit.fetchCatsByCategory(2),
      expect: () => [
        isA<GetDogsLoading>(),
        isA<GetDogsError>().having(
          (s) => (s as GetDogsError).message,
          'error',
          contains('No internet'),
        ),
      ],
    );
  });
}
