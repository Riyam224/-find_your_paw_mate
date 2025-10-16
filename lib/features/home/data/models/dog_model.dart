import '../../../../core/networking/api_constants.dart';
import '../../domain/entities/dog_entity.dart';

class DogModel {
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

  const DogModel({
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
  factory DogModel.fromJson(Map<String, dynamic> json) {
    final imageId = json['reference_image_id'];
    final imageUrl = imageId != null
        ? '${ApiPath.dogImageCdn}$imageId.jpg'
        : ''; // ✅ construct URL manually using Dog API CDN

    return DogModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown Breed',
      imageUrl: imageUrl,
      gender: _randomGender(),
      age: _randomAge(),
      weight: json['weight']?['metric'] ?? '',
      distance: _randomDistance(),
      lifeSpan: json['life_span'] ?? '',
      breedGroup: json['breed_group'] ?? '',
      description: json['temperament'] ?? '',
    );
  }

  /// ✅ Converts Model → Entity
  DogEntity toEntity() {
    return DogEntity(
      id: id,
      name: name,
      imageUrl: imageUrl,
      gender: gender,
      age: age,
      weight: weight,
      distance: distance,
      lifeSpan: lifeSpan,
      breedGroup: breedGroup,
      description: description,
      isFavorite: isFavorite,
    );
  }

  // Mock helpers for UI filler data
  static String _randomGender() =>
      ['Male', 'Female'][DateTime.now().millisecond % 2];

  static String _randomAge() => [
    '3 Months Old',
    '1 Year',
    '2 Years',
    '5 Months Old',
  ][DateTime.now().millisecond % 4];

  static String _randomDistance() => [
    '1.6 km away',
    '2.7 km away',
    '3 km away',
  ][DateTime.now().millisecond % 3];
}
