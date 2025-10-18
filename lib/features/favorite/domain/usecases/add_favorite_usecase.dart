import 'package:dartz/dartz.dart';
import 'package:animals_tasks/core/error/failure.dart';
import '../entities/favorite_entity.dart';
import '../repositories/favorite_repository.dart';

/// Use case for adding a pet to favorites
/// Follows Single Responsibility Principle
class AddFavoriteUseCase {
  final FavoriteRepository _repository;

  AddFavoriteUseCase(this._repository);

  /// Execute the use case
  /// Returns Either<Failure, FavoriteEntity>
  Future<Either<Failure, FavoriteEntity>> call({
    required String imageId,
    String? subId,
  }) async {
    return await _repository.addFavorite(imageId: imageId, subId: subId);
  }
}
