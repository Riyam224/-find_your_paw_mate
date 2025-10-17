import 'package:dartz/dartz.dart';
import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/features/favorite/domain/entities/favorite_entity.dart';
import 'package:animals_tasks/features/favorite/domain/repositories/favorite_repository.dart';

/// Use case for adding a pet to favorites from the home feature
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
