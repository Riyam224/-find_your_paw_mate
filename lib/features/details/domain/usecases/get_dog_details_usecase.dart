<<<<<<< HEAD
import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/features/details/domain/repositories/dog_details_repo.dart';
import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
=======
import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/features/details/domain/repositories/dog_details_repo.dart';
>>>>>>> develop
import 'package:dartz/dartz.dart';

class GetDogDetailsUseCase {
  final DogDetailsRepository repository;

  GetDogDetailsUseCase(this.repository);

<<<<<<< HEAD
  /// Execute the use case to get dog details by ID
  Future<Either<Failure, DogEntity>> call(String dogId) async {
    return await repository.getDogDetails(dogId);
=======
  Future<Either<Failure, DogEntity>> call(String dogId) {
    return repository.getDogDetails(dogId);
>>>>>>> develop
  }
}
