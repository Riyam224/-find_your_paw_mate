<<<<<<< HEAD
import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:dartz/dartz.dart';

abstract class DogDetailsRepository {
  /// Fetches detailed information about a specific dog by its ID
=======
import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:animals_tasks/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class DogDetailsRepository {
>>>>>>> develop
  Future<Either<Failure, DogEntity>> getDogDetails(String dogId);
}
