import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';

sealed class GetDogsState {}

final class GetDogsInitial extends GetDogsState {}

final class GetDogsLoading extends GetDogsState {}

final class GetDogsLoaded extends GetDogsState {
  final List<DogEntity> dogs;
  GetDogsLoaded(this.dogs);
}

final class GetDogsError extends GetDogsState {
  final String message;
  GetDogsError(this.message);
}
