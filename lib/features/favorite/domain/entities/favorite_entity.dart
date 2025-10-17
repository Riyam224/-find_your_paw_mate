import 'package:equatable/equatable.dart';

/// Domain entity representing a favorite pet
/// Uses Equatable for value comparison
class FavoriteEntity extends Equatable {
  final String id;
  final String imageId;
  final String imageUrl;
  final String? subId;
  final DateTime createdAt;
  final String? petName; // Optional: fetched from image details
  final String? breedName; // Optional: breed information
  final String? breedId; // Optional: breed ID for navigation to details

  const FavoriteEntity({
    required this.id,
    required this.imageId,
    required this.imageUrl,
    this.subId,
    required this.createdAt,
    this.petName,
    this.breedName,
    this.breedId,
  });

  /// Create a copy with updated fields
  FavoriteEntity copyWith({
    String? id,
    String? imageId,
    String? imageUrl,
    String? subId,
    DateTime? createdAt,
    String? petName,
    String? breedName,
    String? breedId,
  }) {
    return FavoriteEntity(
      id: id ?? this.id,
      imageId: imageId ?? this.imageId,
      imageUrl: imageUrl ?? this.imageUrl,
      subId: subId ?? this.subId,
      createdAt: createdAt ?? this.createdAt,
      petName: petName ?? this.petName,
      breedName: breedName ?? this.breedName,
      breedId: breedId ?? this.breedId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        imageId,
        imageUrl,
        subId,
        createdAt,
        petName,
        breedName,
        breedId,
      ];
}
