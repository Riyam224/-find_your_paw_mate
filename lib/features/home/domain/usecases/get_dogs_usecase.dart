import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:animals_tasks/features/home/domain/repositories/dog_repo.dart';
import 'package:dartz/dartz.dart';

class GetDogsUseCase {
  final DogRepository repository;
  GetDogsUseCase(this.repository);

  Future<Either<Failure, List<DogEntity>>> call({
    int limit = 10,
    int page = 0,
  }) {
    return repository.getDogs(limit: limit, page: page);
  }
}
