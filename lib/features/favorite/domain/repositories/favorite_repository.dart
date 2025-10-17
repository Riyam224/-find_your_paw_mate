import 'package:dartz/dartz.dart';
import 'package:animals_tasks/core/error/failure.dart';
import '../entities/favorite_entity.dart';

/// Abstract repository interface for favorites
/// Defines contract for favorite operations with Either for error handling
abstract class FavoriteRepository {
  /// Get all favorites for a user
  Future<Either<Failure, List<FavoriteEntity>>> getFavorites({
    String? subId,
    int limit = 10,
  });

  /// Add a pet to favorites
  /// Returns the created favorite
  Future<Either<Failure, FavoriteEntity>> addFavorite({
    required String imageId,
    String? subId,
  });

  /// Remove a pet from favorites
  /// Returns void on success
  Future<Either<Failure, void>> removeFavorite({
    required String favoriteId,
  });
}
