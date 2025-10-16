import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/features/home/domain/entities/category_entity.dart';
import 'package:animals_tasks/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:animals_tasks/features/home/presentation/cubit/get_categories/get_categories_cubit.dart';
import 'package:animals_tasks/features/home/presentation/cubit/get_categories/get_categories_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// 🧪 Mock class
class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}

void main() {
  late GetCategoriesCubit cubit;
  late MockGetCategoriesUseCase mockUseCase;

  final tCategories = [
    const CategoryEntity(id: 0, name: 'All'),
    const CategoryEntity(id: 1, name: 'Funny'),
  ];

  setUp(() {
    mockUseCase = MockGetCategoriesUseCase();
    cubit = GetCategoriesCubit(mockUseCase);
  });

  tearDown(() => cubit.close());

  group('📂 GetCategoriesCubit', () {
    blocTest<GetCategoriesCubit, GetCategoriesState>(
      'emits [Loading, Loaded] when categories are fetched successfully',
      build: () {
        when(() => mockUseCase()).thenAnswer((_) async => Right(tCategories));
        return cubit;
      },
      act: (cubit) => cubit.fetchCategories(),
      expect: () => [
        isA<GetCategoriesLoading>(),
        isA<GetCategoriesLoaded>().having(
          (s) => s.categories,
          'categories',
          tCategories,
        ),
      ],
      verify: (_) {
        verify(() => mockUseCase()).called(1);
      },
    );

    blocTest<GetCategoriesCubit, GetCategoriesState>(
      'emits [Loading, Error] when fetching categories fails',
      build: () {
        when(
          () => mockUseCase(),
        ).thenAnswer((_) async => Left(ServerFailure('API Error')));
        return cubit;
      },
      act: (cubit) => cubit.fetchCategories(),
      expect: () => [
        isA<GetCategoriesLoading>(),
        isA<GetCategoriesError>().having(
          (s) => s.message,
          'message',
          'API Error',
        ),
      ],
    );

    blocTest<GetCategoriesCubit, GetCategoriesState>(
      'emits [Loading, Loaded] with empty list when no categories found',
      build: () {
        when(() => mockUseCase()).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.fetchCategories(),
      expect: () => [
        isA<GetCategoriesLoading>(),
        isA<GetCategoriesLoaded>().having(
          (s) => s.categories,
          'categories',
          isEmpty,
        ),
      ],
    );
  });
}
