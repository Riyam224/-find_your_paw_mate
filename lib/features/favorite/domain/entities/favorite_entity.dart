import 'package:equatable/equatable.dart';

/// Domain entity representing a favorite pet
/// Uses Equatable for value comparison
class FavoriteEntity extends Equatable {
  final String id;
  final String imageId;
  final String imageUrl;
  final String? subId;
  final DateTime createdAt;

  const FavoriteEntity({
    required this.id,
    required this.imageId,
    required this.imageUrl,
    this.subId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        imageId,
        imageUrl,
        subId,
        createdAt,
      ];
}
