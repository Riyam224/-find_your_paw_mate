import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:animals_tasks/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class DogDetailsRepository {
  Future<Either<Failure, DogEntity>> getDogDetails(String dogId);
}
