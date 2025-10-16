import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/core/networking/api_constants.dart';
import 'package:animals_tasks/core/services/dog_api_service.dart';
import 'package:animals_tasks/features/home/data/models/dog_model.dart';
import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:animals_tasks/features/home/domain/repositories/dog_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class DogRepositoryImpl implements DogRepository {
  final DogApiService apiService;

  DogRepositoryImpl(this.apiService);

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

  @override
  Future<Either<Failure, List<DogEntity>>> getDogs({
    int limit = 10,
    int page = 0,
  }) async {
    try {
      // 🐾 Get breeds (each has reference_image_id)
      final response = await apiService.getBreeds(limit: limit, page: page);

      final List<DogEntity> dogs = response.map<DogEntity>((json) {
        final referenceId = json['reference_image_id'];
        // ✅ Directly build CDN image URL using Dog API CDN (no extra API call)
        final imageUrl = referenceId != null
            ? '${ApiPath.dogImageCdn}$referenceId.jpg'
            : null;

        return DogModel.fromJson({...json, 'image_url': imageUrl}).toEntity();
      }).toList();

      return Right(dogs);
    } on DioException catch (e) {
      return Left(ServerFailure('API Error: ${e.message}'));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<DogEntity>>> searchDogs({
    required String query,
    int limit = 10,
    int page = 0,
  }) async {
    try {
      // 🔍 Search breeds by query
      final response = await apiService.searchBreeds(
        query: query,
        limit: limit,
        page: page,
      );

      final List<DogEntity> dogs = response.map<DogEntity>((json) {
        final referenceId = json['reference_image_id'];
        // ✅ Directly build CDN image URL using Dog API CDN (no extra API call)
        final imageUrl = referenceId != null
            ? '${ApiPath.dogImageCdn}$referenceId.jpg'
            : null;

        return DogModel.fromJson({...json, 'image_url': imageUrl}).toEntity();
      }).toList();

      return Right(dogs);
    } on DioException catch (e) {
      return Left(ServerFailure('API Error: ${e.message}'));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<DogEntity>>> getCatsByCategory(int categoryId, {int limit = 10}) async {
    try {
      // 🐱 Get cat images by category from Cat API
      final response = await apiService.getCatImagesByCategory(categoryId, limit: limit);

      final List<DogEntity> cats = response.map<DogEntity>((json) {
        // Convert cat data to DogEntity structure
        final imageUrl = json['url'];
        final catBreeds = json['breeds'] as List?;

        String name = 'Cat';
        String? breedGroup;
        String? weight;
        String? lifeSpan;

        if (catBreeds != null && catBreeds.isNotEmpty) {
          final breed = catBreeds[0];
          name = breed['name'] ?? 'Cat';
          breedGroup = breed['temperament'];
          weight = breed['weight']?['metric'] != null ? '${breed['weight']['metric']} kg' : null;
          lifeSpan = breed['life_span'] != null ? '${breed['life_span']} years' : null;
        }

        return DogEntity(
          id: json['id'] ?? '',
          name: name,
          imageUrl: imageUrl ?? '',
          gender: _randomGender(),
          age: _randomAge(),
          weight: weight,
          distance: _randomDistance(),
          lifeSpan: lifeSpan,
          breedGroup: breedGroup,
        );
      }).toList();

      return Right(cats);
    } on DioException catch (e) {
      return Left(ServerFailure('API Error: ${e.message}'));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }
}
