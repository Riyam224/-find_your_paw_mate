import 'package:dio/dio.dart';
import '../networking/api_constants.dart';

class DogApiService {
  final Dio _dio;
  late final Dio _catApiDio; // Separate Dio instance for Cat API

  /// 💉 Inject Dio instance through constructor (configured in DI)
  DogApiService(this._dio) {
    // Initialize Cat API Dio instance
    _catApiDio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.catApiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'x-api-key': ApiConstants.catApiKey,
        },
      ),
    );
  }

  // 🐾 Helper to safely handle requests
  Future<Response> _safeGet(String path, {Map<String, dynamic>? query}) async {
    try {
      return await _dio.get(path, queryParameters: query);
    } on DioException catch (e) {
      throw Exception('🐾 API error [${e.response?.statusCode}]: ${e.message}');
    } catch (e) {
      throw Exception('🐾 Unexpected error: $e');
    }
  }

  // 🐶 1. Get random dog images
  Future<List<dynamic>> getDogImages({int limit = 10, int page = 0}) async {
    final response = await _safeGet(
      ApiPath.imagesSearch,
      query: {'limit': limit, 'page': page},
    );
    return response.data;
  }

  // 📘 3. Get breed details by ID
  Future<Map<String, dynamic>> getBreedById(int breedId) async {
    final response = await _safeGet('${ApiPath.breedById}$breedId');
    return response.data;
  }

  Future<List<dynamic>> getBreeds({int limit = 10, int page = 0}) async {
    final response = await _dio.get(
      ApiPath.breeds,
      queryParameters: {'limit': limit, 'page': page},
    );
    return response.data;
  }

  // 🔍 Search breeds by name
  Future<List<dynamic>> searchBreeds({
    required String query,
    int limit = 10,
    int page = 0,
  }) async {
    final response = await _safeGet(
      ApiPath.breedsSearch,
      query: {
        'q': query,
        'limit': limit,
        'page': page,
      },
    );
    return response.data;
  }

  // 🖼️ 4. Get single image by ID (Cat API)
  Future<Map<String, dynamic>> getImageById(String imageId) async {
    try {
      final response = await _catApiDio.get('${ApiPath.imageById}$imageId');
      return response.data;
    } on DioException catch (e) {
      throw Exception('🐾 API error [${e.response?.statusCode}]: ${e.message}');
    } catch (e) {
      throw Exception('🐾 Unexpected error: $e');
    }
  }

  // ❤️ 5. Add to favorites (Cat API)
  Future<Map<String, dynamic>> addToFavorites(String imageId) async {
    try {
      final response = await _catApiDio.post(
        ApiPath.favourites,
        data: {
          'image_id': imageId,
          'sub_id': ApiConstants.subId,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('🐾 Failed to add favorite: ${e.message}');
    } catch (e) {
      throw Exception('🐾 Unexpected error: $e');
    }
  }

  // 💖 6. Get all favorites (Cat API)
  Future<List<dynamic>> getFavorites() async {
    try {
      final response = await _catApiDio.get(
        ApiPath.favourites,
        queryParameters: {
          'sub_id': ApiConstants.subId,
          'include_breeds': 1, // Request detailed breed information
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('🐾 Failed to get favorites: ${e.message}');
    } catch (e) {
      throw Exception('🐾 Unexpected error: $e');
    }
  }

  // 💔 7. Delete favorite (Cat API)
  Future<void> deleteFavorite(int favouriteId) async {
    try {
      await _catApiDio.delete('${ApiPath.favouriteById}$favouriteId');
    } on DioException catch (e) {
      throw Exception('🐾 Failed to delete favorite: ${e.message}');
    } catch (e) {
      throw Exception('🐾 Unexpected error: $e');
    }
  }

  // 👍 8. Vote for a dog
  Future<void> voteDog(String imageId, int value) async {
    try {
      await _dio.post(ApiPath.votes, data: {'image_id': imageId, 'value': value});
    } on DioException catch (e) {
      throw Exception('🐾 Failed to vote: ${e.message}');
    }
  }

  // 🗳️ 9. Get votes
  Future<List<dynamic>> getVotes() async {
    final response = await _safeGet(ApiPath.votes);
    return response.data;
  }

  // 🏷️ 10. Get categories (from Cat API)
  Future<List<dynamic>> getCategories() async {
    try {
      final response = await _catApiDio.get(ApiPath.categories);
      return response.data;
    } on DioException catch (e) {
      throw Exception('🐾 API error [${e.response?.statusCode}]: ${e.message}');
    } catch (e) {
      throw Exception('🐾 Unexpected error: $e');
    }
  }

  // 🐱 11. Get cat images by category
  Future<List<dynamic>> getCatImagesByCategory(int categoryId, {int limit = 10}) async {
    try {
      final response = await _catApiDio.get(
        'images/search',
        queryParameters: {
          'limit': limit,
          'category_ids': categoryId,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('🐾 API error [${e.response?.statusCode}]: ${e.message}');
    } catch (e) {
      throw Exception('🐾 Unexpected error: $e');
    }
  }
}
