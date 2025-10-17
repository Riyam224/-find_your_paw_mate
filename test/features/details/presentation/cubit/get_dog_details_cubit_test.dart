import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/features/details/domain/usecases/get_dog_details_usecase.dart';
import 'package:animals_tasks/features/details/presentation/cubit/get_dog_details_cubit.dart';
import 'package:animals_tasks/features/details/presentation/cubit/get_dog_details_state.dart';
import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetDogDetailsUseCase extends Mock implements GetDogDetailsUseCase {}

void main() {
  late GetDogDetailsCubit cubit;
  late MockGetDogDetailsUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetDogDetailsUseCase();
    cubit = GetDogDetailsCubit(mockUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  const testDogId = '1';
  const testDog = DogEntity(
    id: '1',
    name: 'Golden Retriever',
    imageUrl: 'https://example.com/image.jpg',
    gender: 'Male',
    age: '2 years',
    weight: '30 kg',
    breedGroup: 'Sporting',
    description: 'Friendly and intelligent dog',
  );

  group('GetDogDetailsCubit', () {
    test('initial state should be GetDogDetailsInitial', () {
      expect(cubit.state, isA<GetDogDetailsInitial>());
    });

    blocTest<GetDogDetailsCubit, GetDogDetailsState>(
      'should emit [Loading, Loaded] when fetchDogDetails is successful',
      build: () {
        when(() => mockUseCase(testDogId))
            .thenAnswer((_) async => const Right(testDog));
        return cubit;
      },
      act: (cubit) => cubit.fetchDogDetails(testDogId),
      expect: () => [
        GetDogDetailsLoading(),
        const GetDogDetailsLoaded(testDog),
      ],
      verify: (_) {
        verify(() => mockUseCase(testDogId)).called(1);
      },
    );

    blocTest<GetDogDetailsCubit, GetDogDetailsState>(
      'should emit [Loading, Error] when fetchDogDetails fails with ServerFailure',
      build: () {
        when(() => mockUseCase(testDogId))
            .thenAnswer((_) async => Left(ServerFailure('Server error')));
        return cubit;
      },
      act: (cubit) => cubit.fetchDogDetails(testDogId),
      expect: () => [
        GetDogDetailsLoading(),
        const GetDogDetailsError('Server error'),
      ],
      verify: (_) {
        verify(() => mockUseCase(testDogId)).called(1);
      },
    );

    blocTest<GetDogDetailsCubit, GetDogDetailsState>(
      'should emit [Loading, Error] when fetchDogDetails fails with UnknownFailure',
      build: () {
        when(() => mockUseCase(testDogId))
            .thenAnswer((_) async => Left(UnknownFailure('Unknown error')));
        return cubit;
      },
      act: (cubit) => cubit.fetchDogDetails(testDogId),
      expect: () => [
        GetDogDetailsLoading(),
        const GetDogDetailsError('Unknown error'),
      ],
      verify: (_) {
        verify(() => mockUseCase(testDogId)).called(1);
      },
    );

    blocTest<GetDogDetailsCubit, GetDogDetailsState>(
      'should handle multiple fetchDogDetails calls',
      build: () {
        when(() => mockUseCase(testDogId))
            .thenAnswer((_) async => const Right(testDog));
        when(() => mockUseCase('2'))
            .thenAnswer((_) async => const Right(DogEntity(
                  id: '2',
                  name: 'Labrador',
                  imageUrl: 'https://example.com/labrador.jpg',
                )));
        return cubit;
      },
      act: (cubit) async {
        await cubit.fetchDogDetails(testDogId);
        await cubit.fetchDogDetails('2');
      },
      expect: () => [
        GetDogDetailsLoading(),
        const GetDogDetailsLoaded(testDog),
        GetDogDetailsLoading(),
        const GetDogDetailsLoaded(DogEntity(
          id: '2',
          name: 'Labrador',
          imageUrl: 'https://example.com/labrador.jpg',
        )),
      ],
    );
  });
}
