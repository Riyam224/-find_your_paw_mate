import 'package:dartz/dartz.dart';
import 'package:animals_tasks/core/error/failure.dart';
import '../entities/favorite_entity.dart';
import '../repositories/favorite_repository.dart';

/// Use case for getting all favorites
/// Follows Single Responsibility Principle
class GetFavoritesUseCase {
  final FavoriteRepository _repository;

  GetFavoritesUseCase(this._repository);

  /// Execute the use case
  /// Returns Either<Failure, List<FavoriteEntity>>
  Future<Either<Failure, List<FavoriteEntity>>> call({
    String? subId,
    int limit = 10,
  }) async {
    return await _repository.getFavorites(subId: subId, limit: limit);
  }
}
