import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:equatable/equatable.dart';

abstract class GetDogDetailsState extends Equatable {
  const GetDogDetailsState();

  @override
  List<Object?> get props => [];
}

class GetDogDetailsInitial extends GetDogDetailsState {}

class GetDogDetailsLoading extends GetDogDetailsState {}

class GetDogDetailsLoaded extends GetDogDetailsState {
  final DogEntity dog;

  const GetDogDetailsLoaded(this.dog);

  @override
  List<Object?> get props => [dog];
}

class GetDogDetailsError extends GetDogDetailsState {
  final String message;

  const GetDogDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
