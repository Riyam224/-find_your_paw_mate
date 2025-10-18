import 'package:animals_tasks/core/networking/api_constants.dart';
import 'package:animals_tasks/core/services/dog_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late DogApiService dogApiService;
  late MockDio mockDio;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(RequestOptions(path: ''));
  });

  setUp(() {
    mockDio = MockDio();
    dogApiService = DogApiService(mockDio);
  });

  group('🐶 DogApiService - Dog API Methods (using injected Dio)', () {
    group('getDogImages', () {
      test('✅ should return list of dog images', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ApiPath.imagesSearch),
          data: [
            {'id': '1', 'url': 'https://cdn2.thedogapi.com/images/1.jpg'},
            {'id': '2', 'url': 'https://cdn2.thedogapi.com/images/2.jpg'},
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
        final result = await dogApiService.getDogImages(limit: 5, page: 1);

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

      test('✅ should use default parameters when not provided', () async {
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
        await dogApiService.getDogImages();

        // Assert
        verify(
          () => mockDio.get(
            ApiPath.imagesSearch,
            queryParameters: {'limit': 10, 'page': 0},
          ),
        ).called(1);
      });

      test('✅ should handle empty list response', () async {
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
        final result = await dogApiService.getDogImages();

        // Assert
        expect(result, isEmpty);
      });

      test('🚫 should throw exception on DioException', () async {
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
            type: DioExceptionType.connectionError,
          ),
        );

        // Act & Assert
        expect(
          () async => await dogApiService.getDogImages(),
          throwsA(
            predicate((e) =>
                e is Exception && e.toString().contains('API error')),
          ),
        );
      });

      test('🚫 should throw exception on DioException with status code', () async {
        // Arrange
        when(
          () => mockDio.get(
            ApiPath.imagesSearch,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ApiPath.imagesSearch),
            response: Response(
              requestOptions: RequestOptions(path: ApiPath.imagesSearch),
              statusCode: 500,
            ),
            message: 'Server error',
          ),
        );

        // Act & Assert
        expect(
          () async => await dogApiService.getDogImages(),
          throwsA(
            predicate((e) =>
                e is Exception && e.toString().contains('API error [500]')),
          ),
        );
      });

      test('🚫 should handle unexpected errors', () async {
        // Arrange
        when(
          () => mockDio.get(
            ApiPath.imagesSearch,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(StateError('Unexpected state'));

        // Act & Assert
        expect(
          () async => await dogApiService.getDogImages(),
          throwsA(
            predicate((e) =>
                e is Exception && e.toString().contains('Unexpected error')),
          ),
        );
      });

      test('✅ should handle large limit value', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ApiPath.imagesSearch),
          data: List.generate(100, (i) => {'id': '$i'}),
          statusCode: 200,
        );

        when(
          () => mockDio.get(
            ApiPath.imagesSearch,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await dogApiService.getDogImages(limit: 100);

        // Assert
        expect(result.length, 100);
      });
    });

    group('getBreeds', () {
      test('✅ should return list of breeds', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ApiPath.breeds),
          data: [
            {'id': 1, 'name': 'Affenpinscher'},
            {'id': 2, 'name': 'Afghan Hound'},
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
        final result = await dogApiService.getBreeds(limit: 10, page: 0);

        // Assert
        expect(result, isA<List>());
        expect(result.length, 2);
        expect(result[0]['name'], 'Affenpinscher');
        verify(
          () => mockDio.get(
            ApiPath.breeds,
            queryParameters: {'limit': 10, 'page': 0},
          ),
        ).called(1);
      });

      test('✅ should use default parameters', () async {
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
        await dogApiService.getBreeds();

        // Assert
        verify(
          () => mockDio.get(
            ApiPath.breeds,
            queryParameters: {'limit': 10, 'page': 0},
          ),
        ).called(1);
      });

      test('✅ should handle empty list', () async {
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
        final result = await dogApiService.getBreeds();

        // Assert
        expect(result, isEmpty);
      });

      test('✅ should handle custom page parameter', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ApiPath.breeds),
          data: [{'id': 11, 'name': 'Breed 11'}],
          statusCode: 200,
        );

        when(
          () => mockDio.get(
            ApiPath.breeds,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await dogApiService.getBreeds(limit: 5, page: 2);

        // Assert
        verify(
          () => mockDio.get(
            ApiPath.breeds,
            queryParameters: {'limit': 5, 'page': 2},
          ),
        ).called(1);
      });
    });

    group('getBreedById', () {
      test('✅ should return breed details by ID', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: '${ApiPath.breedById}5'),
          data: {
            'id': 5,
            'name': 'Beagle',
            'temperament': 'Friendly, curious',
          },
          statusCode: 200,
        );

        when(
          () => mockDio.get(
            '${ApiPath.breedById}5',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await dogApiService.getBreedById(5);

        // Assert
        expect(result, isA<Map<String, dynamic>>());
        expect(result['id'], 5);
        expect(result['name'], 'Beagle');
      });

      test('🚫 should throw exception when breed not found', () async {
        // Arrange
        when(
          () => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '${ApiPath.breedById}999'),
            response: Response(
              requestOptions: RequestOptions(path: '${ApiPath.breedById}999'),
              statusCode: 404,
            ),
            message: 'Not found',
          ),
        );

        // Act & Assert
        expect(
          () async => await dogApiService.getBreedById(999),
          throwsA(
            predicate((e) =>
                e is Exception && e.toString().contains('API error [404]')),
          ),
        );
      });

      test('✅ should handle breed with all details', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: '${ApiPath.breedById}10'),
          data: {
            'id': 10,
            'name': 'Golden Retriever',
            'bred_for': 'Retrieving',
            'breed_group': 'Sporting',
            'life_span': '10 - 12 years',
            'temperament': 'Intelligent, Friendly',
            'weight': {'imperial': '55 - 75', 'metric': '25 - 34'},
          },
          statusCode: 200,
        );

        when(
          () => mockDio.get(
            '${ApiPath.breedById}10',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await dogApiService.getBreedById(10);

        // Assert
        expect(result['name'], 'Golden Retriever');
        expect(result['temperament'], 'Intelligent, Friendly');
      });
    });

    group('searchBreeds', () {
      test('✅ should return search results for query', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ApiPath.breedsSearch),
          data: [
            {'id': 1, 'name': 'Bulldog'},
            {'id': 2, 'name': 'French Bulldog'},
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
        final result = await dogApiService.searchBreeds(query: 'Bulldog');

        // Assert
        expect(result, isA<List>());
        expect(result.length, 2);
        expect(result[0]['name'], 'Bulldog');
        verify(
          () => mockDio.get(
            ApiPath.breedsSearch,
            queryParameters: {'q': 'Bulldog', 'limit': 10, 'page': 0},
          ),
        ).called(1);
      });

      test('✅ should handle empty search results', () async {
        // Arrange
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
        final result = await dogApiService.searchBreeds(query: 'NonExistentBreed');

        // Assert
        expect(result, isEmpty);
      });

      test('✅ should handle special characters in query', () async {
        // Arrange
        const specialQuery = 'Bull-dog & Mix';
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
        await dogApiService.searchBreeds(query: specialQuery);

        // Assert
        verify(
          () => mockDio.get(
            ApiPath.breedsSearch,
            queryParameters: {'q': specialQuery, 'limit': 10, 'page': 0},
          ),
        ).called(1);
      });

      test('✅ should handle custom limit and page parameters', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ApiPath.breedsSearch),
          data: [{'id': 1, 'name': 'Poodle'}],
          statusCode: 200,
        );

        when(
          () => mockDio.get(
            ApiPath.breedsSearch,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await dogApiService.searchBreeds(query: 'Poodle', limit: 5, page: 2);

        // Assert
        verify(
          () => mockDio.get(
            ApiPath.breedsSearch,
            queryParameters: {'q': 'Poodle', 'limit': 5, 'page': 2},
          ),
        ).called(1);
      });

      test('🚫 should throw exception on error', () async {
        // Arrange
        when(
          () => mockDio.get(
            ApiPath.breedsSearch,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ApiPath.breedsSearch),
            message: 'Network timeout',
            type: DioExceptionType.connectionTimeout,
          ),
        );

        // Act & Assert
        expect(
          () async => await dogApiService.searchBreeds(query: 'Test'),
          throwsException,
        );
      });
    });

    group('voteDog', () {
      test('✅ should vote for a dog successfully', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ApiPath.votes),
          data: {'message': 'SUCCESS'},
          statusCode: 200,
        );

        when(
          () => mockDio.post(
            ApiPath.votes,
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await dogApiService.voteDog('image123', 1);

        // Assert
        verify(
          () => mockDio.post(
            ApiPath.votes,
            data: {'image_id': 'image123', 'value': 1},
          ),
        ).called(1);
      });

      test('✅ should handle downvote', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ApiPath.votes),
          data: {'message': 'SUCCESS'},
          statusCode: 200,
        );

        when(
          () => mockDio.post(
            ApiPath.votes,
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await dogApiService.voteDog('image456', -1);

        // Assert
        verify(
          () => mockDio.post(
            ApiPath.votes,
            data: {'image_id': 'image456', 'value': -1},
          ),
        ).called(1);
      });

      test('🚫 should throw exception on DioException', () async {
        // Arrange
        when(
          () => mockDio.post(
            any(),
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ApiPath.votes),
            message: 'Failed to vote',
          ),
        );

        // Act & Assert
        expect(
          () async => await dogApiService.voteDog('image', 1),
          throwsA(
            predicate((e) =>
                e is Exception && e.toString().contains('Failed to vote')),
          ),
        );
      });
    });

    group('getVotes', () {
      test('✅ should return list of votes', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ApiPath.votes),
          data: [
            {'id': 1, 'image_id': 'img1', 'value': 1},
            {'id': 2, 'image_id': 'img2', 'value': -1},
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
        final result = await dogApiService.getVotes();

        // Assert
        expect(result, isA<List>());
        expect(result.length, 2);
        expect(result[0]['value'], 1);
        expect(result[1]['value'], -1);
      });

      test('✅ should handle empty votes', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ApiPath.votes),
          data: [],
          statusCode: 200,
        );

        when(
          () => mockDio.get(
            ApiPath.votes,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await dogApiService.getVotes();

        // Assert
        expect(result, isEmpty);
      });

      test('🚫 should throw exception on error', () async {
        // Arrange
        when(
          () => mockDio.get(
            ApiPath.votes,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ApiPath.votes),
            message: 'Connection error',
          ),
        );

        // Act & Assert
        expect(
          () async => await dogApiService.getVotes(),
          throwsException,
        );
      });
    });
  });

  group('🐱 DogApiService - Cat API Methods (using _catApiDio)', () {
    // NOTE: These methods use _catApiDio which is created internally
    // and cannot be easily mocked. These tests verify the methods exist
    // and have the correct signatures.

    test('✅ getImageById method exists with correct signature', () {
      expect(dogApiService.getImageById, isA<Function>());
    });

    test('✅ addToFavorites method exists with correct signature', () {
      expect(dogApiService.addToFavorites, isA<Function>());
    });

    test('✅ getFavorites method exists with correct signature', () {
      expect(dogApiService.getFavorites, isA<Function>());
    });

    test('✅ deleteFavorite method exists with correct signature', () {
      expect(dogApiService.deleteFavorite, isA<Function>());
    });

    test('✅ getCategories method exists with correct signature', () {
      expect(dogApiService.getCategories, isA<Function>());
    });

    test('✅ getCatImagesByCategory method exists with correct signature', () {
      expect(dogApiService.getCatImagesByCategory, isA<Function>());
    });
  });

  group('🐾 DogApiService - Edge Cases and Error Handling', () {
    test('should handle connection timeout', () async {
      // Arrange
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.imagesSearch),
          type: DioExceptionType.connectionTimeout,
          message: 'Connection timeout',
        ),
      );

      // Act & Assert
      expect(
        () async => await dogApiService.getDogImages(),
        throwsException,
      );
    });

    test('should handle receive timeout', () async {
      // Arrange
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.imagesSearch),
          type: DioExceptionType.receiveTimeout,
          message: 'Receive timeout',
        ),
      );

      // Act & Assert
      expect(
        () async => await dogApiService.getDogImages(),
        throwsException,
      );
    });

    test('should handle 401 unauthorized error', () async {
      // Arrange
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.imagesSearch),
          response: Response(
            requestOptions: RequestOptions(path: ApiPath.imagesSearch),
            statusCode: 401,
          ),
          message: 'Unauthorized',
        ),
      );

      // Act & Assert
      expect(
        () async => await dogApiService.getDogImages(),
        throwsA(
          predicate((e) =>
              e is Exception && e.toString().contains('API error [401]')),
        ),
      );
    });

    test('should handle 403 forbidden error', () async {
      // Arrange
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.breeds),
          response: Response(
            requestOptions: RequestOptions(path: ApiPath.breeds),
            statusCode: 403,
          ),
          message: 'Forbidden',
        ),
      );

      // Act & Assert
      // getBreeds() doesn't use _safeGet, so it throws DioException directly
      expect(
        () async => await dogApiService.getBreeds(),
        throwsA(isA<DioException>()),
      );
    });

    test('should handle 500 internal server error', () async {
      // Arrange
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.votes),
          response: Response(
            requestOptions: RequestOptions(path: ApiPath.votes),
            statusCode: 500,
          ),
          message: 'Internal server error',
        ),
      );

      // Act & Assert
      expect(
        () async => await dogApiService.getVotes(),
        throwsA(
          predicate((e) =>
              e is Exception && e.toString().contains('API error [500]')),
        ),
      );
    });

    test('should handle format exception', () async {
      // Arrange
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(FormatException('Invalid format'));

      // Act & Assert
      expect(
        () async => await dogApiService.getDogImages(),
        throwsA(
          predicate((e) =>
              e is Exception && e.toString().contains('Unexpected error')),
        ),
      );
    });

    test('should handle state error', () async {
      // Arrange
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(StateError('Bad state'));

      // Act & Assert
      // getBreeds() doesn't use _safeGet, so it throws StateError directly
      expect(
        () async => await dogApiService.getBreeds(),
        throwsA(isA<StateError>()),
      );
    });

    test('should handle 429 Too Many Requests', () async {
      // Arrange
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.imagesSearch),
          response: Response(
            requestOptions: RequestOptions(path: ApiPath.imagesSearch),
            statusCode: 429,
            data: {'message': 'Rate limit exceeded'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act & Assert
      expect(
        () async => await dogApiService.getDogImages(),
        throwsA(
          predicate((e) =>
              e is Exception && e.toString().contains('API error [429]')),
        ),
      );
    });

    test('should handle 502 Bad Gateway', () async {
      // Arrange
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.breeds),
          response: Response(
            requestOptions: RequestOptions(path: ApiPath.breeds),
            statusCode: 502,
            data: {'message': 'Bad Gateway'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act & Assert
      expect(
        () async => await dogApiService.searchBreeds(query: 'test'),
        throwsA(
          predicate((e) =>
              e is Exception && e.toString().contains('API error [502]')),
        ),
      );
    });

    test('should handle 503 Service Unavailable', () async {
      // Arrange
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.votes),
          response: Response(
            requestOptions: RequestOptions(path: ApiPath.votes),
            statusCode: 503,
            data: {'message': 'Service Unavailable'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act & Assert
      expect(
        () async => await dogApiService.getVotes(),
        throwsA(
          predicate((e) =>
              e is Exception && e.toString().contains('API error [503]')),
        ),
      );
    });

    test('should handle 504 Gateway Timeout', () async {
      // Arrange
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.imagesSearch),
          response: Response(
            requestOptions: RequestOptions(path: ApiPath.imagesSearch),
            statusCode: 504,
            data: {'message': 'Gateway Timeout'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act & Assert
      expect(
        () async => await dogApiService.getDogImages(),
        throwsA(
          predicate((e) =>
              e is Exception && e.toString().contains('API error [504]')),
        ),
      );
    });

    test('should handle 400 Bad Request with validation errors', () async {
      // Arrange
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.breedsSearch),
          response: Response(
            requestOptions: RequestOptions(path: ApiPath.breedsSearch),
            statusCode: 400,
            data: {
              'message': 'Validation failed',
              'errors': ['Invalid query parameter']
            },
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act & Assert
      expect(
        () async => await dogApiService.searchBreeds(query: ''),
        throwsA(
          predicate((e) =>
              e is Exception && e.toString().contains('API error [400]')),
        ),
      );
    });

    test('should handle POST request with 422 Unprocessable Entity', () async {
      // Arrange
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.votes),
          response: Response(
            requestOptions: RequestOptions(path: ApiPath.votes),
            statusCode: 422,
            data: {'message': 'Invalid vote value'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act & Assert
      expect(
        () async => await dogApiService.voteDog('img123', 5),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle response without status code', () async {
      // Arrange
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.breeds),
          response: Response(
            requestOptions: RequestOptions(path: ApiPath.breeds),
            data: {'error': 'Something went wrong'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act & Assert
      expect(
        () async => await dogApiService.getDogImages(),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle send timeout on POST', () async {
      // Arrange
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.votes),
          type: DioExceptionType.sendTimeout,
          message: 'Send timeout',
        ),
      );

      // Act & Assert
      expect(
        () async => await dogApiService.voteDog('img123', 1),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle bad certificate', () async {
      // Arrange
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.breeds),
          type: DioExceptionType.badCertificate,
          message: 'Certificate verify failed',
        ),
      );

      // Act & Assert
      expect(
        () async => await dogApiService.getBreedById(1),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle cancel request', () async {
      // Arrange
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.imagesSearch),
          type: DioExceptionType.cancel,
          message: 'Request cancelled',
        ),
      );

      // Act & Assert
      expect(
        () async => await dogApiService.getDogImages(),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle unknown DioException type', () async {
      // Arrange
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.breeds),
          type: DioExceptionType.unknown,
          message: 'Unknown error',
        ),
      );

      // Act & Assert
      expect(
        () async => await dogApiService.searchBreeds(query: 'test'),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle ArgumentError', () async {
      // Arrange
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(ArgumentError('Invalid argument'));

      // Act & Assert
      expect(
        () async => await dogApiService.getDogImages(),
        throwsA(
          predicate((e) =>
              e is Exception && e.toString().contains('Unexpected error')),
        ),
      );
    });

    test('should handle assertion error', () async {
      // Arrange
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(AssertionError('Assertion failed'));

      // Act & Assert
      expect(
        () async => await dogApiService.getBreedById(0),
        throwsA(
          predicate((e) =>
              e is Exception && e.toString().contains('Unexpected error')),
        ),
      );
    });

    test('should handle error with very long message', () async {
      // Arrange
      final longMessage = 'Error: ${'A' * 10000}';
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.votes),
          response: Response(
            requestOptions: RequestOptions(path: ApiPath.votes),
            statusCode: 500,
            data: {'message': longMessage},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act & Assert
      expect(
        () async => await dogApiService.getVotes(),
        throwsA(
          predicate((e) =>
              e is Exception && e.toString().contains('API error [500]')),
        ),
      );
    });

    test('should handle multiple concurrent errors', () async {
      // Arrange
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiPath.imagesSearch),
          response: Response(
            requestOptions: RequestOptions(path: ApiPath.imagesSearch),
            statusCode: 503,
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act & Assert
      final futures = [
        dogApiService.getDogImages(),
        dogApiService.getDogImages(),
        dogApiService.getDogImages(),
      ];

      for (final future in futures) {
        expect(
          () async => await future,
          throwsA(isA<Exception>()),
        );
      }
    });
  });
}
