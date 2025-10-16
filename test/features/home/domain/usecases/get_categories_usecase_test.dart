import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/features/home/domain/entities/category_entity.dart';
import 'package:animals_tasks/features/home/domain/repositories/category_repo.dart';
import 'package:animals_tasks/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  late MockCategoryRepository mockRepo;
  late GetCategoriesUseCase usecase;

  const tCategory = CategoryEntity(id: 1, name: 'Cats');
  final tCategories = [tCategory];
  final tMultipleCategories = [
    const CategoryEntity(id: 1, name: 'Cats'),
    const CategoryEntity(id: 2, name: 'Dogs'),
    const CategoryEntity(id: 3, name: 'Birds'),
    const CategoryEntity(id: 4, name: 'Fish'),
  ];

  setUp(() {
    mockRepo = MockCategoryRepository();
    usecase = GetCategoriesUseCase(mockRepo);
  });

  group('🐾 GetCategoriesUseCase', () {
    test('returns list of categories on success', () async {
      when(
        () => mockRepo.getCategories(),
      ).thenAnswer((_) async => Right(tCategories));

      final result = await usecase();

      expect(result, Right(tCategories));
      verify(() => mockRepo.getCategories()).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns ServerFailure when repository fails', () async {
      when(
        () => mockRepo.getCategories(),
      ).thenAnswer((_) async => Left(ServerFailure('API Error')));

      final result = await usecase();

      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected failure but got success'),
      );
      verify(() => mockRepo.getCategories()).called(1);
    });

    test('returns empty list when repository gives no data', () async {
      when(
        () => mockRepo.getCategories(),
      ).thenAnswer((_) async => const Right([]));

      final result = await usecase();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right but got Left'),
        (categories) => expect(categories, isEmpty),
      );
    });

    test('throws exception when something unexpected happens', () async {
      when(
        () => mockRepo.getCategories(),
      ).thenThrow(Exception('Unexpected error'));

      expect(() async => await usecase(), throwsA(isA<Exception>()));
    });

    test('returns NetworkFailure when network error occurs', () async {
      when(
        () => mockRepo.getCategories(),
      ).thenAnswer((_) async => Left(NetworkFailure('No internet connection')));

      final result = await usecase();

      result.fold((failure) {
        expect(failure, isA<NetworkFailure>());
        expect(failure.message, 'No internet connection');
      }, (_) => fail('Expected failure but got success'));
    });

    test('returns UnknownFailure for unknown errors', () async {
      when(
        () => mockRepo.getCategories(),
      ).thenAnswer((_) async => Left(UnknownFailure('Unknown error')));

      final result = await usecase();

      result.fold((failure) {
        expect(failure, isA<UnknownFailure>());
        expect(failure.message, 'Unknown error');
      }, (_) => fail('Expected failure but got success'));
    });

    test('returns multiple categories successfully', () async {
      when(
        () => mockRepo.getCategories(),
      ).thenAnswer((_) async => Right(tMultipleCategories));

      final result = await usecase();

      result.fold((_) => fail('Expected Right but got Left'), (categories) {
        expect(categories.length, 4);
        expect(categories.first.name, 'Cats');
        expect(categories.last.name, 'Fish');
      });
    });

    test('returns single category successfully', () async {
      when(
        () => mockRepo.getCategories(),
      ).thenAnswer((_) async => Right([tCategory]));

      final result = await usecase();

      result.fold((_) => fail('Expected Right but got Left'), (categories) {
        expect(categories.length, 1);
        expect(categories.first, tCategory);
      });
    });

    test('can be called multiple times without breaking anything', () async {
      when(
        () => mockRepo.getCategories(),
      ).thenAnswer((_) async => Right(tCategories));

      final result1 = await usecase();
      final result2 = await usecase();

      expect(result1, Right(tCategories));
      expect(result2, Right(tCategories));
      verify(() => mockRepo.getCategories()).called(2);
    });

    test('returns correct Either type', () async {
      when(
        () => mockRepo.getCategories(),
      ).thenAnswer((_) async => Right(tCategories));

      final result = await usecase();

      expect(result, isA<Either<Failure, List<CategoryEntity>>>());
      expect(result, isA<Right<Failure, List<CategoryEntity>>>());
    });

    test('calls repository exactly once per call', () async {
      when(
        () => mockRepo.getCategories(),
      ).thenAnswer((_) async => Right(tCategories));

      await usecase();

      verify(() => mockRepo.getCategories()).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('handles categories with unique IDs', () async {
      final mockList = [
        const CategoryEntity(id: 101, name: 'Category A'),
        const CategoryEntity(id: 202, name: 'Category B'),
        const CategoryEntity(id: 303, name: 'Category C'),
      ];
      when(
        () => mockRepo.getCategories(),
      ).thenAnswer((_) async => Right(mockList));

      final result = await usecase();

      result.fold((_) => fail('Expected Right but got Left'), (categories) {
        expect(categories.map((c) => c.id), [101, 202, 303]);
      });
    });

    test('handles special characters in names', () async {
      final specialCategories = [
        const CategoryEntity(id: 1, name: 'Cats & Dogs'),
        const CategoryEntity(id: 2, name: 'Birds (Exotic)'),
        const CategoryEntity(id: 3, name: 'Fish - Tropical'),
      ];
      when(
        () => mockRepo.getCategories(),
      ).thenAnswer((_) async => Right(specialCategories));

      final result = await usecase();

      result.fold((_) => fail('Expected Right but got Left'), (categories) {
        expect(categories[0].name, contains('&'));
        expect(categories[1].name, contains('('));
        expect(categories[2].name, contains('-'));
      });
    });

    test('completes future successfully', () async {
      when(
        () => mockRepo.getCategories(),
      ).thenAnswer((_) async => Right(tCategories));

      final future = usecase();

      expect(future, isA<Future<Either<Failure, List<CategoryEntity>>>>());
      await expectLater(future, completes);
    });

    test(
      'returns same result when called twice (referential transparency)',
      () async {
        when(
          () => mockRepo.getCategories(),
        ).thenAnswer((_) async => Right(tCategories));

        final result1 = await usecase();
        final result2 = await usecase();

        expect(result1.runtimeType, result2.runtimeType);
        expect(
          result1.fold((l) => l, (r) => r),
          result2.fold((l) => l, (r) => r),
        );
      },
    );

    test('throws TypeError if repository throws one', () async {
      when(() => mockRepo.getCategories()).thenThrow(TypeError());

      expect(() async => await usecase(), throwsA(isA<TypeError>()));
    });

    test('handles ServerFailure with custom error message', () async {
      const errorMessage = 'Failed to fetch categories from server';
      when(
        () => mockRepo.getCategories(),
      ).thenAnswer((_) async => Left(ServerFailure(errorMessage)));

      final result = await usecase();

      result.fold((failure) {
        expect(failure, isA<ServerFailure>());
        expect(failure.message, errorMessage);
      }, (_) => fail('Expected Left but got Right'));
    });

    test('handles NetworkFailure for timeout', () async {
      when(
        () => mockRepo.getCategories(),
      ).thenAnswer((_) async => Left(NetworkFailure('Request timeout')));

      final result = await usecase();

      result.fold((failure) {
        expect(failure, isA<NetworkFailure>());
        expect(failure.message, 'Request timeout');
      }, (_) => fail('Expected failure but got success'));
    });

    test('delegates call to repository as-is', () async {
      when(
        () => mockRepo.getCategories(),
      ).thenAnswer((_) async => Right(tCategories));

      final result = await usecase();

      verify(() => mockRepo.getCategories()).called(1);
      expect(result, Right(tCategories));
    });

    test('ensures returned list remains immutable', () async {
      final original = [
        const CategoryEntity(id: 1, name: 'Cats'),
        const CategoryEntity(id: 2, name: 'Dogs'),
      ];
      when(
        () => mockRepo.getCategories(),
      ).thenAnswer((_) async => Right(original));

      final result = await usecase();

      result.fold((_) => fail('Expected Right but got Left'), (categories) {
        expect(categories[0].id, 1);
        expect(categories[1].id, 2);
      });
    });
  });
}

