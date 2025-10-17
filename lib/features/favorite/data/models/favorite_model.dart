import '../../domain/entities/favorite_entity.dart';

/// Data model for favorite - handles JSON serialization
/// Does NOT depend on entity - converts TO entity
class FavoriteModel {
  final int id;
  final String imageId;
  final String imageUrl;
  final String? subId;
  final String createdAt;

  const FavoriteModel({
    required this.id,
    required this.imageId,
    required this.imageUrl,
    this.subId,
    required this.createdAt,
  });

  /// Creates model from API JSON response
  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] ?? 0,
      imageId: json['image_id'] ?? '',
      imageUrl: json['image']?['url'] ?? '',
      subId: json['sub_id'],
      createdAt: json['created_at'] ?? '',
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
    );
  }
}
