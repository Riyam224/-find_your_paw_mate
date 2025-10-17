import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/core/services/dog_api_service.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../models/favorite_model.dart';

/// Implementation of FavoriteRepository
/// Handles API calls and converts responses to Entities
class FavoriteRepositoryImpl implements FavoriteRepository {
  final DogApiService _apiService;

  FavoriteRepositoryImpl(this._apiService);

  @override
  Future<Either<Failure, List<FavoriteEntity>>> getFavorites({
    String? subId,
    int limit = 10,
  }) async {
    try {
      // API service already uses the configured subId from ApiConstants
      final response = await _apiService.getFavorites();

      final favorites = response
          .map<FavoriteEntity>(
            (json) => FavoriteModel.fromJson(json).toEntity(),
          )
          .toList();

      return Right(favorites);
    } on DioException catch (e) {
      final status = e.response?.statusCode ?? 0;
      final msg = e.response?.data?['message'] ?? e.message ?? 'Unknown error';
      return Left(ServerFailure('Failed to fetch favorites [$status]: $msg'));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, FavoriteEntity>> addFavorite({
    required String imageId,
    String? subId,
  }) async {
    try {
      // API service already uses the configured subId from ApiConstants
      final response = await _apiService.addToFavorites(imageId);

      // The addToFavorites API returns: {id: 123, message: "SUCCESS"}
      // It does NOT return the full favorite object
      // We need to construct a minimal FavoriteEntity from the response
      final favoriteId = response['id'] ?? 0;

      // Create a minimal FavoriteEntity with the data we have
      final favorite = FavoriteEntity(
        id: favoriteId.toString(),
        imageId: imageId,
        imageUrl: _constructImageUrl(imageId),
        createdAt: DateTime.now(),
        subId: subId,
      );

      return Right(favorite);
    } on DioException catch (e) {
      final status = e.response?.statusCode ?? 0;
      final msg = e.response?.data?['message'] ?? e.message ?? 'Unknown error';
      return Left(ServerFailure('Failed to add favorite [$status]: $msg'));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  /// Helper method to construct image URL from imageId
  /// Tries Dog API CDN first as this app primarily uses dog images
  String _constructImageUrl(String imageId) {
    // Since this app uses Dog API for images, construct Dog CDN URL
    return 'https://cdn2.thedogapi.com/images/$imageId.jpg';
  }

  @override
  Future<Either<Failure, void>> removeFavorite({
    required String favoriteId,
  }) async {
    try {
      final id = int.tryParse(favoriteId);
      if (id == null) {
        return Left(UnknownFailure('Invalid favorite ID: $favoriteId'));
      }

      await _apiService.deleteFavorite(id);
      return const Right(null);
    } on DioException catch (e) {
      final status = e.response?.statusCode ?? 0;
      final msg = e.response?.data?['message'] ?? e.message ?? 'Unknown error';
      return Left(ServerFailure('Failed to remove favorite [$status]: $msg'));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }
}
