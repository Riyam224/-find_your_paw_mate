import '../../../../core/networking/api_constants.dart';
import '../../../../core/utils/mock_data_generator.dart';
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

    final id = json['id']?.toString() ?? '';

    return DogModel(
      id: id,
      name: json['name'] ?? 'Unknown Breed',
      imageUrl: imageUrl,
      gender: MockDataGenerator.randomGender(id),
      age: MockDataGenerator.randomAge(id),
      weight: json['weight']?['metric'] ?? '',
      distance: MockDataGenerator.randomDistance(id),
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
}
