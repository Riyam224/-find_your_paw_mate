import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';

sealed class SearchDogsState {}

final class SearchDogsInitial extends SearchDogsState {}

final class SearchDogsLoading extends SearchDogsState {}

final class SearchDogsLoaded extends SearchDogsState {
  final List<DogEntity> dogs;
  final String query;

  SearchDogsLoaded(this.dogs, this.query);
}

final class SearchDogsEmpty extends SearchDogsState {
  final String query;

  SearchDogsEmpty(this.query);
}

final class SearchDogsError extends SearchDogsState {
  final String message;

  SearchDogsError(this.message);
}
