import '../../domain/entities/category_entity.dart';

class CategoryModel {
  final int id;
  final String name;

  const CategoryModel({
    required this.id,
    required this.name,
  });

  /// ✅ Parse from API JSON response
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
    );
  }

  /// ✅ Converts Model → Entity
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
    );
  }

  /// ✅ Converts Entity → Model (useful for caching/local storage)
  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
    );
  }

  /// ✅ Converts Model → JSON (useful for API requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
