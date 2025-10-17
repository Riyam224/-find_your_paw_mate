import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/core/networking/api_constants.dart';
import 'package:animals_tasks/core/services/dog_api_service.dart';
import 'package:animals_tasks/features/details/domain/repositories/dog_details_repo.dart';
import 'package:animals_tasks/features/home/data/models/dog_model.dart';
import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class DogDetailsRepositoryImpl implements DogDetailsRepository {
  final DogApiService apiService;

  DogDetailsRepositoryImpl(this.apiService);

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
  Future<Either<Failure, DogEntity>> getDogDetails(String dogId) async {
    try {
      // Check if it's a numeric ID (dog breed) or string ID (cat)
      final isNumericId = int.tryParse(dogId) != null;

      if (isNumericId) {
        // Fetch dog breed details by ID
        final response = await apiService.getBreedById(int.parse(dogId));

        // Get image URL from reference_image_id
        final referenceId = response['reference_image_id'];
        final imageUrl = referenceId != null
            ? '${ApiPath.dogImageCdn}$referenceId.jpg'
            : null;

        // Create dog model with image URL
        final dogModel =
            DogModel.fromJson({...response, 'image_url': imageUrl});

        return Right(dogModel.toEntity());
      } else {
        // Fetch cat image details by ID
        final response = await apiService.getImageById(dogId);

        final imageUrl = response['url'];
        final catBreeds = response['breeds'] as List?;

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
          id: response['id'] ?? '',
          name: name,
          imageUrl: imageUrl ?? '',
          gender: _randomGender(),
          age: _randomAge(),
          weight: weight,
          distance: _randomDistance(),
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
