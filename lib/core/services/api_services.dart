// // import 'package:dio/dio.dart';
// // import '../networking/api_constants.dart';

// // class ApiServices {
// //   final Dio _dio;
// //   late final Dio _catApiDio; // Separate Dio instance for Cat API

// //   /// 💉 Inject Dio instance through constructor (configured in DI)
// //   ApiServices(this._dio) {
// //     // Initialize Cat API Dio instance
// //     _catApiDio = Dio(
// //       BaseOptions(
// //         baseUrl: ApiConstants.catApiBaseUrl,
// //         connectTimeout: const Duration(seconds: 10),
// //         receiveTimeout: const Duration(seconds: 10),
// //         headers: {
// //           'Accept': 'application/json',
// //           'Content-Type': 'application/json',
// //           // todo
// //           'x-api-key': ApiConstants.CatApiKey,
// //         },
// //       ),
// //     );
// //   }

// //   // 🐾 Helper to safely handle requests
// //   Future<Response> _safeGet(String path, {Map<String, dynamic>? query}) async {
// //     try {
// //       return await _dio.get(path, queryParameters: query);
// //     } on DioException catch (e) {
// //       throw Exception('🐾 API error [${e.response?.statusCode}]: ${e.message}');
// //     } catch (e) {
// //       throw Exception('🐾 Unexpected error: $e');
// //     }
// //   }

// //   // 🐶 1. Get random dog images
// //   Future<List<dynamic>> getDogImages({int limit = 10, int page = 0}) async {
// //     final response = await _safeGet(
// //       ApiPath.imagesSearch,
// //       query: {'limit': limit, 'page': page},
// //     );
// //     return response.data;
// //   }

// //   // 📘 3. Get breed details by ID
// //   Future<Map<String, dynamic>> getBreedById(int breedId) async {
// //     final response = await _safeGet('${ApiPath.breedById}$breedId');
// //     return response.data;
// //   }

// //   Future<List<dynamic>> getBreeds({int limit = 10, int page = 0}) async {
// //     final response = await _dio.get(
// //       ApiPath.breeds,
// //       queryParameters: {'limit': limit, 'page': page},
// //     );
// //     return response.data;
// //   }

// //   // 🔍 Search breeds by name
// //   Future<List<dynamic>> searchBreeds({
// //     required String query,
// //     int limit = 10,
// //     int page = 0,
// //   }) async {
// //     final response = await _safeGet(
// //       ApiPath.breedsSearch,
// //       query: {'q': query, 'limit': limit, 'page': page},
// //     );
// //     return response.data;
// //   }

// //   // 🖼️ 4. Get single image by ID
// //   Future<Map<String, dynamic>> getImageById(String imageId) async {
// //     final response = await _safeGet('${ApiPath.imageById}$imageId');
// //     return response.data;
// //   }

// //   // ❤️ 5. Add to favorites
// //   Future<Map<String, dynamic>> addToFavorites(
// //     String imageId, {
// //     String subId = 'user_riyam', // ✅ default sub_id
// //   }) async {
// //     try {
// //       final response = await _dio.post(
// //         ApiPath.favourites,
// //         data: {'image_id': imageId, 'sub_id': subId},
// //       );

// //       print('✅ Added to favorites: ${response.data}');
// //       return response.data;
// //     } on DioException catch (e) {
// //       final status = e.response?.statusCode;
// //       final data = e.response?.data;
// //       throw Exception(
// //         '🐾 Failed to add favorite [$status]: ${data ?? e.message}',
// //       );
// //     } catch (e) {
// //       throw Exception('🐾 Unexpected addToFavorites error: $e');
// //     }
// //   }

// //   // 💖 6. Get all favorites
// //   Future<List<dynamic>> getFavorites({
// //     String subId = 'user_riyam', // ✅ required by TheApiService
// //     int limit = 10,
// //   }) async {
// //     try {
// //       final response = await _dio.get(
// //         ApiPath.favourites,
// //         queryParameters: {'sub_id': subId, 'limit': limit},
// //       );

// //       print('✅ Favorites fetched (${response.data.length})');
// //       return response.data;
// //     } on DioException catch (e) {
// //       final status = e.response?.statusCode;
// //       final data = e.response?.data;
// //       throw Exception(
// //         '🐾 Failed to fetch favorites [$status]: ${data ?? e.message}',
// //       );
// //     } catch (e) {
// //       throw Exception('🐾 Unexpected getFavorites error: $e');
// //     }
// //   }

// //   // 💔 7. Delete favorite
// //   Future<void> deleteFavorite(
// //     int favouriteId, {
// //     String subId = 'user_riyam', // optional but useful
// //   }) async {
// //     try {
// //       final response = await _dio.delete(
// //         '${ApiPath.favouriteById}$favouriteId',
// //         queryParameters: {'sub_id': subId},
// //       );
// //       print('🗑️ Favorite deleted: ${response.statusCode}');
// //     } on DioException catch (e) {
// //       final status = e.response?.statusCode;
// //       final data = e.response?.data;
// //       throw Exception(
// //         '🐾 Failed to delete favorite [$status]: ${data ?? e.message}',
// //       );
// //     } catch (e) {
// //       throw Exception('🐾 Unexpected deleteFavorite error: $e');
// //     }
// //   }

// //   // 👍 8. Vote for a dog
// //   Future<void> voteDog(String imageId, int value) async {
// //     try {
// //       await _dio.post(
// //         ApiPath.votes,
// //         data: {'image_id': imageId, 'value': value},
// //       );
// //     } on DioException catch (e) {
// //       throw Exception('🐾 Failed to vote: ${e.message}');
// //     }
// //   }

// //   // 🗳️ 9. Get votes
// //   Future<List<dynamic>> getVotes() async {
// //     final response = await _safeGet(ApiPath.votes);
// //     return response.data;
// //   }

// //   // 🏷️ 10. Get categories (from Cat API)
// //   Future<List<dynamic>> getCategories() async {
// //     try {
// //       final response = await _catApiDio.get(ApiPath.categories);
// //       return response.data;
// //     } on DioException catch (e) {
// //       throw Exception('🐾 API error [${e.response?.statusCode}]: ${e.message}');
// //     } catch (e) {
// //       throw Exception('🐾 Unexpected error: $e');
// //     }
// //   }

// //   // 🐱 11. Get cat images by category
// //   Future<List<dynamic>> getCatImagesByCategory(
// //     int categoryId, {
// //     int limit = 10,
// //   }) async {
// //     try {
// //       final response = await _catApiDio.get(
// //         'images/search',
// //         queryParameters: {'limit': limit, 'category_ids': categoryId},
// //       );
// //       return response.data;
// //     } on DioException catch (e) {
// //       throw Exception('🐾 API error [${e.response?.statusCode}]: ${e.message}');
// //     } catch (e) {
// //       throw Exception('🐾 Unexpected error: $e');
// //     }
// //   }
// // }

// import 'package:dio/dio.dart';
// import '../networking/api_constants.dart';

// class ApiServices {
//   final Dio _ApiServiceDio; // 🐶 Dog API client
//   final Dio _catApiDio; // 🐱 Cat API client

//   /// 💉 Inject Dio instance through constructor (configured in DI)
//   ApiServices(this._ApiServiceDio)
//     : _catApiDio = Dio(
//         BaseOptions(
//           baseUrl: ApiConstants.catApiBaseUrl,
//           connectTimeout: const Duration(seconds: 10),
//           receiveTimeout: const Duration(seconds: 10),
//           headers: {
//             'Accept': 'application/json',
//             'Content-Type': 'application/json',
//             'x-api-key': ApiConstants.catApiKey, // ✅ fixed key name
//           },
//         ),
//       );

//   // 🐾 Helper to safely handle GET requests (for Dog API)
//   Future<Response> _safeGet(String path, {Map<String, dynamic>? query}) async {
//     try {
//       return await _ApiServiceDio.get(path, queryParameters: query);
//     } on DioException catch (e) {
//       throw Exception('🐾 API error [${e.response?.statusCode}]: ${e.message}');
//     } catch (e) {
//       throw Exception('🐾 Unexpected error: $e');
//     }
//   }

//   // 🐶 1. Get random dog images
//   Future<List<dynamic>> getDogImages({int limit = 10, int page = 0}) async {
//     final response = await _safeGet(
//       ApiPath.imagesSearch,
//       query: {'limit': limit, 'page': page},
//     );
//     return response.data;
//   }

//   // 🐶 2. Get breed list
//   Future<List<dynamic>> getBreeds({int limit = 10, int page = 0}) async {
//     final response = await _ApiServiceDio.get(
//       ApiPath.breeds,
//       queryParameters: {'limit': limit, 'page': page},
//     );
//     return response.data;
//   }

//   // 📘 3. Get breed details by ID
//   Future<Map<String, dynamic>> getBreedById(int breedId) async {
//     final response = await _safeGet('${ApiPath.breedById}$breedId');
//     return response.data;
//   }

//   // 🔍 4. Search breeds by name
//   Future<List<dynamic>> searchBreeds({
//     required String query,
//     int limit = 10,
//     int page = 0,
//   }) async {
//     final response = await _safeGet(
//       ApiPath.breedsSearch,
//       query: {'q': query, 'limit': limit, 'page': page},
//     );
//     return response.data;
//   }

//   // 🖼️ 5. Get single dog image by ID
//   Future<Map<String, dynamic>> getImageById(String imageId) async {
//     final response = await _safeGet('${ApiPath.imageById}$imageId');
//     return response.data;
//   }

//   // ❤️ 6. Add to favorites (Cat API)
//   Future<Map<String, dynamic>> addToFavorites(
//     String imageId, {
//     String subId = 'user_riyam',
//   }) async {
//     try {
//       final response = await _catApiDio.post(
//         ApiPath.favourites,
//         data: {'image_id': imageId, 'sub_id': subId},
//       );

//       print('✅ Added to favorites: ${response.data}');
//       return response.data;
//     } on DioException catch (e) {
//       final status = e.response?.statusCode;
//       final data = e.response?.data;
//       throw Exception(
//         '🐾 Failed to add favorite [$status]: ${data ?? e.message}',
//       );
//     } catch (e) {
//       throw Exception('🐾 Unexpected addToFavorites error: $e');
//     }
//   }

//   // 💖 7. Get all favorites (Cat API)
//   Future<List<dynamic>> getFavorites({
//     String subId = 'user_riyam',
//     int limit = 10,
//   }) async {
//     try {
//       final response = await _catApiDio.get(
//         ApiPath.favourites,
//         queryParameters: {'sub_id': subId, 'limit': limit},
//       );

//       print('✅ Favorites fetched (${response.data.length})');
//       return response.data;
//     } on DioException catch (e) {
//       final status = e.response?.statusCode;
//       final data = e.response?.data;
//       throw Exception(
//         '🐾 Failed to fetch favorites [$status]: ${data ?? e.message}',
//       );
//     } catch (e) {
//       throw Exception('🐾 Unexpected getFavorites error: $e');
//     }
//   }

//   // 💔 8. Delete favorite (Cat API)
//   Future<void> deleteFavorite(
//     int favouriteId, {
//     String subId = 'user_riyam',
//   }) async {
//     try {
//       final response = await _catApiDio.delete(
//         '${ApiPath.favouriteById}$favouriteId',
//         queryParameters: {'sub_id': subId},
//       );
//       print('🗑️ Favorite deleted: ${response.statusCode}');
//     } on DioException catch (e) {
//       final status = e.response?.statusCode;
//       final data = e.response?.data;
//       throw Exception(
//         '🐾 Failed to delete favorite [$status]: ${data ?? e.message}',
//       );
//     } catch (e) {
//       throw Exception('🐾 Unexpected deleteFavorite error: $e');
//     }
//   }

//   // 👍 9. Vote for a dog
//   Future<void> voteDog(String imageId, int value) async {
//     try {
//       await _ApiServiceDio.post(
//         ApiPath.votes,
//         data: {'image_id': imageId, 'value': value},
//       );
//     } on DioException catch (e) {
//       throw Exception('🐾 Failed to vote: ${e.message}');
//     }
//   }

//   // 🗳️ 10. Get votes (Dog API)
//   Future<List<dynamic>> getVotes() async {
//     final response = await _safeGet(ApiPath.votes);
//     return response.data;
//   }

//   // 🏷️ 11. Get categories (Cat API)
//   Future<List<dynamic>> getCategories() async {
//     try {
//       final response = await _catApiDio.get(ApiPath.categories);
//       return response.data;
//     } on DioException catch (e) {
//       throw Exception('🐾 API error [${e.response?.statusCode}]: ${e.message}');
//     } catch (e) {
//       throw Exception('🐾 Unexpected error: $e');
//     }
//   }

//   // 🐱 12. Get cat images by category (Cat API)
//   Future<List<dynamic>> getCatImagesByCategory(
//     int categoryId, {
//     int limit = 10,
//   }) async {
//     try {
//       final response = await _catApiDio.get(
//         'images/search',
//         queryParameters: {'limit': limit, 'category_ids': categoryId},
//       );
//       return response.data;
//     } on DioException catch (e) {
//       throw Exception('🐾 API error [${e.response?.statusCode}]: ${e.message}');
//     } catch (e) {
//       throw Exception('🐾 Unexpected error: $e');
//     }
//   }
// }

import 'package:dio/dio.dart';
import '../networking/api_constants.dart';

class ApiServices {
  final Dio _ApiServiceDio; // 🐶 Dog API client
  final Dio _catApiDio; // 🐱 Cat API client

  /// 💉 Inject Dio instance through constructor (configured in DI)
  ApiServices(this._ApiServiceDio)
    : _catApiDio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.catApiBaseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'x-api-key': ApiConstants.CatApiKey, // ✅ fixed key name
          },
        ),
      );

  // 🐾 Helper to safely handle GET requests (for Dog API)
  Future<Response> _safeGet(String path, {Map<String, dynamic>? query}) async {
    try {
      return await _ApiServiceDio.get(path, queryParameters: query);
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

  // 🐶 2. Get breed list
  Future<List<dynamic>> getBreeds({int limit = 10, int page = 0}) async {
    final response = await _ApiServiceDio.get(
      ApiPath.breeds,
      queryParameters: {'limit': limit, 'page': page},
    );
    return response.data;
  }

  // 📘 3. Get breed details by ID
  Future<Map<String, dynamic>> getBreedById(int breedId) async {
    final response = await _safeGet('${ApiPath.breedById}$breedId');
    return response.data;
  }

  // 🔍 4. Search breeds by name
  Future<List<dynamic>> searchBreeds({
    required String query,
    int limit = 10,
    int page = 0,
  }) async {
    final response = await _safeGet(
      ApiPath.breedsSearch,
      query: {'q': query, 'limit': limit, 'page': page},
    );
    return response.data;
  }

  // 🖼️ 5. Get single dog image by ID
  Future<Map<String, dynamic>> getImageById(String imageId) async {
    final response = await _safeGet('${ApiPath.imageById}$imageId');
    return response.data;
  }

  // ❤️ 6. Add to favorites (Cat API)
  Future<Map<String, dynamic>> addToFavorites(
    String imageId, {
    String subId = 'user_riyam',
  }) async {
    try {
      final response = await _catApiDio.post(
        ApiPath.favourites,
        data: {'image_id': imageId, 'sub_id': subId},
      );

      print('✅ Added to favorites: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      throw Exception(
        '🐾 Failed to add favorite [$status]: ${data ?? e.message}',
      );
    } catch (e) {
      throw Exception('🐾 Unexpected addToFavorites error: $e');
    }
  }

  // 💖 7. Get all favorites (Cat API)
  Future<List<dynamic>> getFavorites({
    String subId = 'user_riyam',
    int limit = 10,
  }) async {
    try {
      final response = await _catApiDio.get(
        ApiPath.favourites,
        queryParameters: {'sub_id': subId, 'limit': limit},
      );

      print('✅ Favorites fetched (${response.data.length})');
      return response.data;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      throw Exception(
        '🐾 Failed to fetch favorites [$status]: ${data ?? e.message}',
      );
    } catch (e) {
      throw Exception('🐾 Unexpected getFavorites error: $e');
    }
  }

  // 💔 8. Delete favorite (Cat API)
  Future<void> deleteFavorite(
    int favouriteId, {
    String subId = 'user_riyam',
  }) async {
    try {
      final response = await _catApiDio.delete(
        '${ApiPath.favouriteById}$favouriteId',
        queryParameters: {'sub_id': subId},
      );
      print('🗑️ Favorite deleted: ${response.statusCode}');
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      throw Exception(
        '🐾 Failed to delete favorite [$status]: ${data ?? e.message}',
      );
    } catch (e) {
      throw Exception('🐾 Unexpected deleteFavorite error: $e');
    }
  }

  // 👍 9. Vote for a dog
  Future<void> voteDog(String imageId, int value) async {
    try {
      await _ApiServiceDio.post(
        ApiPath.votes,
        data: {'image_id': imageId, 'value': value},
      );
    } on DioException catch (e) {
      throw Exception('🐾 Failed to vote: ${e.message}');
    }
  }

  // 🗳️ 10. Get votes (Dog API)
  Future<List<dynamic>> getVotes() async {
    final response = await _safeGet(ApiPath.votes);
    return response.data;
  }

  // 🏷️ 11. Get categories (Cat API)
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

  // 🐱 12. Get cat images by category (Cat API)
  Future<List<dynamic>> getCatImagesByCategory(
    int categoryId, {
    int limit = 10,
  }) async {
    try {
      final response = await _catApiDio.get(
        'images/search',
        queryParameters: {'limit': limit, 'category_ids': categoryId},
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('🐾 API error [${e.response?.statusCode}]: ${e.message}');
    } catch (e) {
      throw Exception('🐾 Unexpected error: $e');
    }
  }
}
