import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:animals_tasks/features/home/domain/repositories/dog_repo.dart';
import 'package:dartz/dartz.dart';

/// 🔍 Use Case: Search dogs by breed name
/// Follows single responsibility - only searches dogs
class SearchDogsUseCase {
  final DogRepository repository;

  SearchDogsUseCase(this.repository);

  /// Call the use case
  Future<Either<Failure, List<DogEntity>>> call({
    required String query,
    int limit = 10,
    int page = 0,
  }) {
    return repository.searchDogs(query: query, limit: limit, page: page);
  }
}
