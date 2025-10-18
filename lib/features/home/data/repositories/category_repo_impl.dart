import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/core/services/dog_api_service.dart';
import 'package:animals_tasks/features/home/data/models/category_model.dart';
import 'package:animals_tasks/features/home/domain/entities/category_entity.dart';
import 'package:animals_tasks/features/home/domain/repositories/category_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final DogApiService apiService;

  CategoryRepositoryImpl(this.apiService);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      // Call the API to get categories
      final response = await apiService.getCategories();

      // Parse the response into CategoryModel objects
      final categories = response
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();

      // Add "All" category at the beginning
      final allCategories = [
        const CategoryEntity(id: 0, name: 'All'),
        ...categories.map((model) => model.toEntity()),
      ];

      return Right(allCategories);
    } on DioException catch (e) {
      final message = (e.response?.data is Map)
          ? e.response?.data['message'] ?? 'Failed to load categories'
          : 'Failed to load categories';
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }
}
