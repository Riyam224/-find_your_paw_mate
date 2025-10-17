import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/core/services/api_services.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../models/favorite_model.dart';

/// Implementation of FavoriteRepository
/// Handles API calls and converts responses to Entities
class FavoriteRepositoryImpl implements FavoriteRepository {
  final ApiServices _apiService;

  FavoriteRepositoryImpl(this._apiService);

  @override
  Future<Either<Failure, List<FavoriteEntity>>> getFavorites({
    String? subId,
    int limit = 10,
  }) async {
    try {
      final response = await _apiService.getFavorites(
        subId: subId ?? 'user_riyam',
        limit: limit,
      );

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
      // 🩷 Add favorite using ApiServiceService
      final response = await _apiService.addToFavorites(
        imageId,
        subId: subId ?? 'user_riyam',
      );

      // Convert API response to Entity
      final favorite = FavoriteModel.fromJson(response).toEntity();
      return Right(favorite);
    } on DioException catch (e) {
      final status = e.response?.statusCode ?? 0;
      final msg = e.response?.data?['message'] ?? e.message ?? 'Unknown error';
      return Left(ServerFailure('Failed to add favorite [$status]: $msg'));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
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
