import 'package:equatable/equatable.dart';

class DogEntity extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final String? gender;
  final String? age;
  final String? weight;
  final String? distance;
  final String? lifeSpan;
  final String? breedGroup;
  final String? description;
  final bool isFavorite;
  const DogEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.gender,
    this.age,
    this.weight,
    this.distance,
    this.lifeSpan,
    this.breedGroup,
    this.description,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    imageUrl,
    gender,
    age,
    weight,
    distance,
    lifeSpan,
    breedGroup,
    description,
    isFavorite,
  ];
}
