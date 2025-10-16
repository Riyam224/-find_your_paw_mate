import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/features/home/domain/entities/category_entity.dart';
import 'package:animals_tasks/features/home/domain/repositories/category_repo.dart';
import 'package:dartz/dartz.dart';

/// 🏷️ Use Case: Get all available categories
/// Follows single responsibility - only fetches categories
class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  /// Call the use case
  Future<Either<Failure, List<CategoryEntity>>> call() {
    return repository.getCategories();
  }
}
