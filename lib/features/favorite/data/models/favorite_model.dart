import '../../domain/entities/favorite_entity.dart';

/// Data model for favorite - handles JSON serialization
/// Does NOT depend on entity - converts TO entity
class FavoriteModel {
  final int id;
  final String imageId;
  final String imageUrl;
  final String? subId;
  final String createdAt;
  final String? petName;
  final String? breedName;
  final String? breedId;

  const FavoriteModel({
    required this.id,
    required this.imageId,
    required this.imageUrl,
    this.subId,
    required this.createdAt,
    this.petName,
    this.breedName,
    this.breedId,
  });

  /// Creates model from API JSON response
  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    final imageId = json['image_id'] ?? '';

    // Get image URL from API response (nested in 'image' object)
    String imageUrl = json['image']?['url'] ?? '';

    // Try to extract breed info from the image object if available
    String? petName;
    String? breedName;
    String? breedId;

    if (json['image'] != null) {
      final imageObj = json['image'];
      // Check for breed information in the image object
      final breeds = imageObj['breeds'] as List?;
      if (breeds != null && breeds.isNotEmpty) {
        final breed = breeds[0];
        petName = breed['name'];
        breedName = breed['name'];
        breedId = breed['id']?.toString();
      }
    }

    // If URL is empty, construct it from image_id
    // The Cat API favorites endpoint doesn't always return the full image object
    // when the image_id is from a different source (like Dog API)
    if (imageUrl.isEmpty && imageId.isNotEmpty) {
      // Check if it's a Dog API image (construct Dog CDN URL)
      imageUrl = 'https://cdn2.thedogapi.com/images/$imageId.jpg';
    }

    return FavoriteModel(
      id: json['id'] ?? 0,
      imageId: imageId,
      imageUrl: imageUrl,
      subId: json['sub_id'],
      createdAt: json['created_at'] ?? '',
      petName: petName,
      breedName: breedName,
      breedId: breedId,
    );
  }

  /// Converts model to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'image_id': imageId,
      if (subId != null) 'sub_id': subId,
    };
  }

  /// Converts data model to domain entity
  /// Model depends on Entity, but Entity does NOT depend on Model
  FavoriteEntity toEntity() {
    return FavoriteEntity(
      id: id.toString(),
      imageId: imageId,
      imageUrl: imageUrl,
      subId: subId,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      petName: petName,
      breedName: breedName,
      breedId: breedId,
    );
  }
}
