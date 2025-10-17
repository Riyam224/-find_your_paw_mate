import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/core/services/dog_api_service.dart';
import 'package:animals_tasks/core/utils/mock_data_generator.dart';
import 'package:animals_tasks/features/details/domain/repositories/dog_details_repo.dart';
import 'package:animals_tasks/features/home/data/models/dog_model.dart';
import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class DogDetailsRepositoryImpl implements DogDetailsRepository {
  final DogApiService apiService;

  DogDetailsRepositoryImpl(this.apiService);

  @override
  Future<Either<Failure, DogEntity>> getDogDetails(String dogId) async {
    try {
      // Check if it's a numeric ID (dog breed) or string ID (cat)
      final isNumericId = int.tryParse(dogId) != null;

      if (isNumericId) {
        // Fetch dog breed details by ID
        final response = await apiService.getBreedById(int.parse(dogId));

        // Create dog model (fromJson will extract imageId from reference_image_id and build imageUrl)
        final dogModel = DogModel.fromJson(response);

        return Right(dogModel.toEntity());
      } else {
        // Fetch cat image details by ID
        final response = await apiService.getImageById(dogId);

        final imageUrl = response['url'];
        final catBreeds = response['breeds'] as List?;
        final catId = response['id'] ?? dogId;

        String name = 'Cat';
        String? breedGroup;
        String? weight;
        String? lifeSpan;
        String? description;

        if (catBreeds != null && catBreeds.isNotEmpty) {
          final breed = catBreeds[0];
          name = breed['name'] ?? 'Cat';
          breedGroup = breed['temperament'];
          weight = breed['weight']?['metric'] != null
              ? '${breed['weight']['metric']} kg'
              : null;
          lifeSpan = breed['life_span'] != null
              ? '${breed['life_span']} years'
              : null;
          description = breed['description'];
        }

        final catEntity = DogEntity(
          id: catId,
          name: name,
          imageUrl: imageUrl ?? '',
          imageId: catId, // For cats, the image ID is the same as the catId
          gender: MockDataGenerator.randomGender(catId),
          age: MockDataGenerator.randomAge(catId),
          weight: weight,
          distance: MockDataGenerator.randomDistance(catId),
          lifeSpan: lifeSpan,
          breedGroup: breedGroup,
          description: description,
        );

        return Right(catEntity);
      }
    } on DioException catch (e) {
      return Left(ServerFailure('API Error: ${e.message}'));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }
}
