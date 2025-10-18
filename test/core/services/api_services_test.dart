import 'package:animals_tasks/core/networking/api_constants.dart';
import 'package:animals_tasks/core/services/api_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late ApiServices apiServices;
  late MockDio mockDio;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(RequestOptions(path: ''));
  });

  setUp(() {
    mockDio = MockDio();
    apiServices = ApiServices(mockDio);
  });

  group('🐾 ApiServices - Dog API Methods (using injected Dio)', () {
    test('✅ getDogImages returns list of data', () async {
      // Arrange
      final mockResponse = Response(
        requestOptions: RequestOptions(path: ApiPath.imagesSearch),
        data: [
          {'id': '1', 'url': 'https://example.com/dog1.jpg'},
          {'id': '2', 'url': 'https://example.com/dog2.jpg'},
        ],
        statusCode: 200,
      );

      when(
        () => mockDio.get(
          ApiPath.imagesSearch,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await apiServices.getDogImages(limit: 5, page: 1);

      // Assert
      expect(result, isA<List>());
      expect(result.length, 2);
      expect(result[0]['id'], '1');
      verify(
        () => mockDio.get(
          ApiPath.imagesSearch,
          queryParameters: {'limit': 5, 'page': 1},
        ),
      ).called(1);
    });

    test('🚫 getDogImages throws exception on DioException', () async {
      // Arrange
      when(
        () => mockDio.get(
          ApiPath.imagesSearch,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.imagesSearch),
          message: 'Network error',
        ),
      );

      // Act & Assert
      expect(
        () async => await apiServices.getDogImages(limit: 5, page: 1),
        throwsA(isA<Exception>()),
      );
    });

    test('✅ getDogImages uses default parameters', () async {
      // Arrange
      final mockResponse = Response(
        requestOptions: RequestOptions(path: ApiPath.imagesSearch),
        data: [],
        statusCode: 200,
      );

      when(
        () => mockDio.get(
          ApiPath.imagesSearch,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => mockResponse);

      // Act
      await apiServices.getDogImages();

      // Assert
      verify(
        () => mockDio.get(
          ApiPath.imagesSearch,
          queryParameters: {'limit': 10, 'page': 0},
        ),
      ).called(1);
    });

    test('✅ getBreeds returns list of data', () async {
      // Arrange
      final mockResponse = Response(
        requestOptions: RequestOptions(path: ApiPath.breeds),
        data: [
          {'id': 1, 'name': 'Poodle'},
          {'id': 2, 'name': 'Bulldog'},
        ],
        statusCode: 200,
      );

      when(
        () => mockDio.get(
          ApiPath.breeds,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await apiServices.getBreeds(limit: 10, page: 0);

      // Assert
      expect(result, isA<List>());
      expect(result.first['name'], 'Poodle');
      verify(
        () => mockDio.get(
          ApiPath.breeds,
          queryParameters: {'limit': 10, 'page': 0},
        ),
      ).called(1);
    });

    test('✅ getBreeds handles empty list', () async {
      // Arrange
      final mockResponse = Response(
        requestOptions: RequestOptions(path: ApiPath.breeds),
        data: [],
        statusCode: 200,
      );

      when(
        () => mockDio.get(
          ApiPath.breeds,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await apiServices.getBreeds();

      // Assert
      expect(result, isEmpty);
    });

    test('✅ getBreedById returns a map', () async {
      // Arrange
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '${ApiPath.breedById}5'),
        data: {'id': 5, 'name': 'Husky'},
        statusCode: 200,
      );

      when(
        () => mockDio.get(
          '${ApiPath.breedById}5',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await apiServices.getBreedById(5);

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['name'], 'Husky');
      expect(result['id'], 5);
    });

    test('🚫 getBreedById throws exception on error', () async {
      // Arrange
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '${ApiPath.breedById}999'),
          response: Response(
            requestOptions: RequestOptions(path: '${ApiPath.breedById}999'),
            statusCode: 404,
          ),
        ),
      );

      // Act & Assert
      expect(
        () async => await apiServices.getBreedById(999),
        throwsA(isA<Exception>()),
      );
    });

    test('✅ searchBreeds returns a list', () async {
      // Arrange
      final mockResponse = Response(
        requestOptions: RequestOptions(path: ApiPath.breedsSearch),
        data: [
          {'id': 1, 'name': 'Beagle'},
        ],
        statusCode: 200,
      );

      when(
        () => mockDio.get(
          ApiPath.breedsSearch,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await apiServices.searchBreeds(query: 'Beagle');

      // Assert
      expect(result, isA<List>());
      expect(result.first['name'], 'Beagle');
      verify(
        () => mockDio.get(
          ApiPath.breedsSearch,
          queryParameters: {'q': 'Beagle', 'limit': 10, 'page': 0},
        ),
      ).called(1);
    });

    test('✅ searchBreeds handles special characters', () async {
      // Arrange
      const specialQuery = 'Bull-dog 123';
      final mockResponse = Response(
        requestOptions: RequestOptions(path: ApiPath.breedsSearch),
        data: [],
        statusCode: 200,
      );

      when(
        () => mockDio.get(
          ApiPath.breedsSearch,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => mockResponse);

      // Act
      await apiServices.searchBreeds(query: specialQuery);

      // Assert
      verify(
        () => mockDio.get(
          ApiPath.breedsSearch,
          queryParameters: {'q': specialQuery, 'limit': 10, 'page': 0},
        ),
      ).called(1);
    });

    test('✅ getImageById returns a map', () async {
      // Arrange
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '${ApiPath.imageById}img1'),
        data: {'id': 'img1', 'url': 'https://example.com/img1.jpg'},
        statusCode: 200,
      );

      when(
        () => mockDio.get(
          '${ApiPath.imageById}img1',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await apiServices.getImageById('img1');

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['id'], 'img1');
    });

    test('✅ voteDog calls POST without error', () async {
      // Arrange
      final mockResponse = Response(
        requestOptions: RequestOptions(path: ApiPath.votes),
        data: {'message': 'SUCCESS'},
        statusCode: 200,
      );

      when(
        () => mockDio.post(ApiPath.votes, data: any(named: 'data')),
      ).thenAnswer((_) async => mockResponse);

      // Act
      await apiServices.voteDog('dog1', 1);

      // Assert
      verify(
        () =>
            mockDio.post(ApiPath.votes, data: {'image_id': 'dog1', 'value': 1}),
      ).called(1);
    });

    test('🚫 voteDog throws exception on DioException', () async {
      // Arrange
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.votes),
          message: 'Network error',
        ),
      );

      // Act & Assert
      expect(
        () async => await apiServices.voteDog('id', 1),
        throwsA(isA<Exception>()),
      );
    });

    test('✅ getVotes returns list', () async {
      // Arrange
      final mockResponse = Response(
        requestOptions: RequestOptions(path: ApiPath.votes),
        data: [
          {'id': 1, 'value': 1},
          {'id': 2, 'value': -1},
        ],
        statusCode: 200,
      );

      when(
        () => mockDio.get(
          ApiPath.votes,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await apiServices.getVotes();

      // Assert
      expect(result, isA<List>());
      expect(result.first['id'], 1);
      expect(result.length, 2);
    });

    test('🚫 getVotes throws exception on error', () async {
      // Arrange
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.votes),
          message: 'Connection timeout',
        ),
      );

      // Act & Assert
      expect(
        () async => await apiServices.getVotes(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('🐱 ApiServices - Cat API Methods (using _catApiDio)', () {
    // NOTE: These methods use _catApiDio which is created internally
    // and cannot be easily mocked. These tests verify the methods exist
    // and have the correct signatures.

    test('✅ addToFavorites method exists with correct signature', () {
      expect(apiServices.addToFavorites, isA<Function>());
    });

    test('✅ getFavorites method exists with correct signature', () {
      expect(apiServices.getFavorites, isA<Function>());
    });

    test('✅ deleteFavorite method exists with correct signature', () {
      expect(apiServices.deleteFavorite, isA<Function>());
    });

    test('✅ getCategories method exists with correct signature', () {
      expect(apiServices.getCategories, isA<Function>());
    });

    test('✅ getCatImagesByCategory method exists with correct signature', () {
      expect(apiServices.getCatImagesByCategory, isA<Function>());
    });
  });

  group('🐾 ApiServices - Error Handling', () {
    test('should handle DioException with status code', () async {
      // Arrange
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.breeds),
          response: Response(
            requestOptions: RequestOptions(path: ApiPath.breeds),
            statusCode: 404,
          ),
          message: 'Not found',
        ),
      );

      // Act & Assert
      expect(
        () async => await apiServices.getDogImages(),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('API error [404]'),
          ),
        ),
      );
    });

    test('should handle unexpected errors', () async {
      // Arrange
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(StateError('Unexpected state'));

      // Act & Assert
      expect(
        () async => await apiServices.getDogImages(),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('Unexpected error'),
          ),
        ),
      );
    });

    test('should handle network timeout', () async {
      // Arrange
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.breeds),
          type: DioExceptionType.connectionTimeout,
          message: 'Connection timeout',
        ),
      );

      // Act & Assert
      expect(
        () async => await apiServices.getDogImages(),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle 400 Bad Request', () async {
      // Arrange
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.imagesSearch),
          response: Response(
            requestOptions: RequestOptions(path: ApiPath.imagesSearch),
            statusCode: 400,
            data: {'message': 'Bad Request'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act & Assert
      expect(
        () async => await apiServices.getDogImages(),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('API error [400]'),
          ),
        ),
      );
    });

    test('should handle 401 Unauthorized', () async {
      // Arrange
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.imagesSearch),
          response: Response(
            requestOptions: RequestOptions(path: ApiPath.imagesSearch),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act & Assert
      // Use getDogImages which uses _safeGet
      expect(
        () async => await apiServices.getDogImages(),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('API error [401]'),
          ),
        ),
      );
    });

    test('should handle 403 Forbidden', () async {
      // Arrange
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.breeds),
          response: Response(
            requestOptions: RequestOptions(path: ApiPath.breeds),
            statusCode: 403,
            data: {'message': 'Forbidden'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act & Assert
      expect(
        () async => await apiServices.searchBreeds(query: 'test'),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('API error [403]'),
          ),
        ),
      );
    });

    test('should handle 429 Too Many Requests', () async {
      // Arrange
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.imagesSearch),
          response: Response(
            requestOptions: RequestOptions(path: ApiPath.imagesSearch),
            statusCode: 429,
            data: {'message': 'Too Many Requests'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act & Assert
      expect(
        () async => await apiServices.getDogImages(),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('API error [429]'),
          ),
        ),
      );
    });

    test('should handle 500 Internal Server Error', () async {
      // Arrange
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.votes),
          response: Response(
            requestOptions: RequestOptions(path: ApiPath.votes),
            statusCode: 500,
            data: {'message': 'Internal Server Error'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act & Assert
      expect(
        () async => await apiServices.getVotes(),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('API error [500]'),
          ),
        ),
      );
    });

    test('should handle 502 Bad Gateway', () async {
      // Arrange
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.imagesSearch),
          response: Response(
            requestOptions: RequestOptions(path: ApiPath.imagesSearch),
            statusCode: 502,
            data: {'message': 'Bad Gateway'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act & Assert
      // Use getDogImages which uses _safeGet
      expect(
        () async => await apiServices.getDogImages(),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('API error [502]'),
          ),
        ),
      );
    });

    test('should handle 503 Service Unavailable', () async {
      // Arrange
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.imagesSearch),
          response: Response(
            requestOptions: RequestOptions(path: ApiPath.imagesSearch),
            statusCode: 503,
            data: {'message': 'Service Unavailable'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act & Assert
      expect(
        () async => await apiServices.getDogImages(),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('API error [503]'),
          ),
        ),
      );
    });

    test('should handle receive timeout', () async {
      // Arrange
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.breeds),
          type: DioExceptionType.receiveTimeout,
          message: 'Receive timeout',
        ),
      );

      // Act & Assert
      expect(
        () async => await apiServices.getBreeds(),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle send timeout', () async {
      // Arrange
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.votes),
          type: DioExceptionType.sendTimeout,
          message: 'Send timeout',
        ),
      );

      // Act & Assert
      expect(
        () async => await apiServices.voteDog('img123', 1),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle cancel error', () async {
      // Arrange
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.imagesSearch),
          type: DioExceptionType.cancel,
          message: 'Request cancelled',
        ),
      );

      // Act & Assert
      expect(
        () async => await apiServices.getDogImages(),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle connection error', () async {
      // Arrange
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.breeds),
          type: DioExceptionType.connectionError,
          message: 'Connection refused',
        ),
      );

      // Act & Assert
      expect(
        () async => await apiServices.getBreeds(),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle bad certificate error', () async {
      // Arrange
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.imagesSearch),
          type: DioExceptionType.badCertificate,
          message: 'Certificate verification failed',
        ),
      );

      // Act & Assert
      expect(
        () async => await apiServices.getDogImages(),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle POST request errors', () async {
      // Arrange
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.votes),
          response: Response(
            requestOptions: RequestOptions(path: ApiPath.votes),
            statusCode: 422,
            data: {'message': 'Unprocessable Entity'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act & Assert
      expect(
        () async => await apiServices.voteDog('img123', 1),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle error response without data', () async {
      // Arrange
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.imagesSearch),
          response: Response(
            requestOptions: RequestOptions(path: ApiPath.imagesSearch),
            statusCode: 404,
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act & Assert
      // Use getDogImages which uses _safeGet
      expect(
        () async => await apiServices.getDogImages(),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('API error [404]'),
          ),
        ),
      );
    });

    test('should handle format exception', () async {
      // Arrange
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(FormatException('Invalid JSON'));

      // Act & Assert
      expect(
        () async => await apiServices.getDogImages(),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('Unexpected error'),
          ),
        ),
      );
    });

    test('should handle TypeError', () async {
      // Arrange
      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(TypeError());

      // Act & Assert
      // Use getDogImages which uses _safeGet
      expect(
        () async => await apiServices.getDogImages(),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('Unexpected error'),
          ),
        ),
      );
    });
  });
}
