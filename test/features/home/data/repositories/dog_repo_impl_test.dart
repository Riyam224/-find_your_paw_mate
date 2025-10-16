import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/core/networking/api_constants.dart';
import 'package:animals_tasks/core/services/dog_api_service.dart';
import 'package:animals_tasks/features/home/data/repositories/dog_repo_impl.dart';
import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDogApiService extends Mock implements DogApiService {}

void main() {
  late MockDogApiService mockApi;
  late DogRepositoryImpl repo;

  setUp(() {
    mockApi = MockDogApiService();
    repo = DogRepositoryImpl(mockApi);
  });

  group('🐶 getDogs', () {
    final tResponse = [
      {'id': 1, 'name': 'Bulldog', 'reference_image_id': 'abc123'},
    ];

    test('✅ returns list of DogEntity on success', () async {
      when(
        () => mockApi.getBreeds(
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => tResponse);

      final result = await repo.getDogs(limit: 5, page: 1);

      expect(result.isRight(), true);
      result.fold((_) => fail('Should succeed'), (dogs) {
        expect(dogs.first, isA<DogEntity>());
        expect(dogs.first.name, 'Bulldog');
        expect(dogs.first.imageUrl, '${ApiPath.dogImageCdn}abc123.jpg');
      });
    });

    test('⚙️ uses default values if not provided', () async {
      when(
        () => mockApi.getBreeds(
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => []);
      await repo.getDogs();
      verify(() => mockApi.getBreeds(limit: 10, page: 0)).called(1);
    });

    test('🕳️ returns empty list when no data', () async {
      when(
        () => mockApi.getBreeds(
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => []);
      final result = await repo.getDogs();
      result.fold(
        (_) => fail('Should succeed'),
        (dogs) => expect(dogs, isEmpty),
      );
    });

    test('🚫 returns ServerFailure on Dio error', () async {
      when(
        () => mockApi.getBreeds(
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/breeds'),
          message: 'Timeout',
          type: DioExceptionType.connectionTimeout,
        ),
      );
      final result = await repo.getDogs();
      result.fold(
        (f) => expect(f, isA<ServerFailure>()),
        (_) => fail('Should fail'),
      );
    });

    test('❓ returns UnknownFailure on other exceptions', () async {
      when(
        () => mockApi.getBreeds(
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenThrow(Exception('Something weird'));
      final result = await repo.getDogs();
      result.fold(
        (f) => expect(f, isA<UnknownFailure>()),
        (_) => fail('Should fail'),
      );
    });
  });

  group('🔍 searchDogs', () {
    const tQuery = 'Bulldog';
    final tResponse = [
      {'id': 1, 'name': 'Bulldog', 'reference_image_id': 'abc123'},
    ];

    test('✅ returns results on success', () async {
      when(
        () => mockApi.searchBreeds(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => tResponse);

      final result = await repo.searchDogs(query: tQuery);
      result.fold(
        (_) => fail('Should succeed'),
        (dogs) => expect(dogs.first.name, 'Bulldog'),
      );
    });

    test('🕳️ returns empty list for no results', () async {
      when(
        () => mockApi.searchBreeds(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => []);
      final result = await repo.searchDogs(query: 'RandomBreed');
      result.fold(
        (_) => fail('Should succeed'),
        (dogs) => expect(dogs, isEmpty),
      );
    });

    test('🚫 returns ServerFailure on Dio error', () async {
      when(
        () => mockApi.searchBreeds(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/breeds/search'),
          message: 'Error',
        ),
      );
      final result = await repo.searchDogs(query: tQuery);
      result.fold(
        (f) => expect(f, isA<ServerFailure>()),
        (_) => fail('Should fail'),
      );
    });

    test('❓ returns UnknownFailure on unknown error', () async {
      when(
        () => mockApi.searchBreeds(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenThrow(StateError('Invalid state'));
      final result = await repo.searchDogs(query: tQuery);
      result.fold(
        (f) => expect(f, isA<UnknownFailure>()),
        (_) => fail('Should fail'),
      );
    });
  });

  group('🐱 getCatsByCategory', () {
    const tCategoryId = 1;
    final tResponse = [
      {
        'id': 'cat1',
        'url': 'https://test.jpg',
        'breeds': [
          {
            'name': 'Abyssinian',
            'temperament': 'Active, Energetic',
            'weight': {'metric': '3 - 5'},
            'life_span': '14 - 15',
          },
        ],
      },
    ];

    test('✅ returns cats as DogEntity', () async {
      when(
        () => mockApi.getCatImagesByCategory(any(), limit: any(named: 'limit')),
      ).thenAnswer((_) async => tResponse);

      final result = await repo.getCatsByCategory(tCategoryId);
      result.fold((_) => fail('Should succeed'), (cats) {
        expect(cats.first.name, 'Abyssinian');
        expect(cats.first.imageUrl, contains('test.jpg'));
      });
    });

    test('🚫 returns ServerFailure on Dio error', () async {
      when(
        () => mockApi.getCatImagesByCategory(any(), limit: any(named: 'limit')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/images/search'),
          message: 'API error',
        ),
      );
      final result = await repo.getCatsByCategory(tCategoryId);
      result.fold(
        (f) => expect(f, isA<ServerFailure>()),
        (_) => fail('Should fail'),
      );
    });
  });
}
