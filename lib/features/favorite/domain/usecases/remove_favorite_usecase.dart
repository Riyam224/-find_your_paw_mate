import 'package:dartz/dartz.dart';
import 'package:animals_tasks/core/error/failure.dart';
import '../repositories/favorite_repository.dart';

/// Use case for removing a pet from favorites
/// Follows Single Responsibility Principle
class RemoveFavoriteUseCase {
  final FavoriteRepository _repository;

  RemoveFavoriteUseCase(this._repository);

  /// Execute the use case
  /// Returns Either<Failure, void>
  Future<Either<Failure, void>> call({
    required String favoriteId,
  }) async {
    return await _repository.removeFavorite(favoriteId: favoriteId);
  }
}
