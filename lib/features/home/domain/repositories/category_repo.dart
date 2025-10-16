import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/features/home/domain/entities/category_entity.dart';
import 'package:dartz/dartz.dart';

/// 🏷️ Category Repository Contract
/// Defines what operations the repository must support
abstract class CategoryRepository {
  /// Get all available categories
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
}
