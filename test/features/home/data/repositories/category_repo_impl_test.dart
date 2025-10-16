import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/core/services/dog_api_service.dart';
import 'package:animals_tasks/features/home/data/repositories/category_repo_impl.dart';
import 'package:animals_tasks/features/home/domain/entities/category_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDogApiService extends Mock implements DogApiService {}

void main() {
  late MockDogApiService mockApiService;
  late CategoryRepositoryImpl repository;

  setUp(() {
    mockApiService = MockDogApiService();
    repository = CategoryRepositoryImpl(mockApiService);
  });

  group('🐾 CategoryRepositoryImpl.getCategories', () {
    final tResponse = [
      {'id': 1, 'name': 'boxes'},
      {'id': 2, 'name': 'clothes'},
      {'id': 3, 'name': 'hats'},
      {'id': 4, 'name': 'sinks'},
    ];

    test('✅ returns full category list with "All" at the top', () async {
      // Arrange
      when(
        () => mockApiService.getCategories(),
      ).thenAnswer((_) async => tResponse);

      // Act
      final result = await repository.getCategories();

      // Assert
      expect(result.isRight(), true);
      result.fold((_) => fail('Expected success'), (categories) {
        expect(categories.length, 5); // includes "All"
        expect(categories.first.name, 'All');
        expect(categories.last.name, 'sinks');
      });
      verify(() => mockApiService.getCategories()).called(1);
    });

    test('🕳️ handles empty API response by returning only "All"', () async {
      when(() => mockApiService.getCategories()).thenAnswer((_) async => []);

      final result = await repository.getCategories();

      result.fold((_) => fail('Expected success'), (categories) {
        expect(categories.length, 1);
        expect(categories.first.name, 'All');
      });
    });

    test('🚫 returns ServerFailure on DioException', () async {
      when(() => mockApiService.getCategories()).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/categories'),
          response: Response(
            requestOptions: RequestOptions(path: '/categories'),
            statusCode: 500,
            data: {'message': 'Internal Server Error'},
          ),
        ),
      );

      final result = await repository.getCategories();

      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ServerFailure>());
        expect(failure.message, contains('Internal Server Error'));
      }, (_) => fail('Expected failure'));
    });

    test('❓ returns UnknownFailure for unexpected errors', () async {
      when(
        () => mockApiService.getCategories(),
      ).thenThrow(Exception('Something weird happened'));

      final result = await repository.getCategories();

      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<UnknownFailure>());
        expect(failure.message, contains('Unexpected error'));
      }, (_) => fail('Expected failure'));
    });

    test('🧩 correctly converts each item to CategoryEntity', () async {
      when(
        () => mockApiService.getCategories(),
      ).thenAnswer((_) async => tResponse);

      final result = await repository.getCategories();

      result.fold((_) => fail('Expected success'), (categories) {
        expect(categories[1], isA<CategoryEntity>());
        expect(categories[1].name, 'boxes');
        expect(categories[4].name, 'sinks');
      });
    });
  });
}
