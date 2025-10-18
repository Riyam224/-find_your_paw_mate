import 'package:animals_tasks/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../entities/dog_entity.dart';

abstract class DogRepository {
  Future<Either<Failure, List<DogEntity>>> getDogs({
    int limit = 10,
    int page = 0,
  });

  Future<Either<Failure, List<DogEntity>>> searchDogs({
    required String query,
    int limit = 10,
    int page = 0,
  });

  Future<Either<Failure, List<DogEntity>>> getCatsByCategory(int categoryId, {int limit = 10});

  // Future<Either<Failure, DogEntity>> getDogById(String id);
  // Future<Either<Failure, List<DogEntity>>> getFavorites();
  // Future<Either<Failure, void>> addToFavorites(String imageId);
  // Future<Either<Failure, void>> removeFromFavorites(int favoriteId);
  // Future<Either<Failure, List<String>>> getCategories();
}
