import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/core/networking/api_constants.dart';
import 'package:animals_tasks/core/services/dog_api_service.dart';
import 'package:animals_tasks/features/home/data/models/dog_model.dart';
import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:animals_tasks/features/details/domain/repositories/dog_details_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class DogDetailsRepositoryImpl implements DogDetailsRepository {
  final DogApiService apiService;

  DogDetailsRepositoryImpl(this.apiService);

  @override
  Future<Either<Failure, DogEntity>> getDogDetails(String dogId) async {
    try {
      // 🖼️ Get image by ID (which contains breed info)
      final response = await apiService.getImageById(dogId);

      // Extract breed information from the image response
      final breeds = response['breeds'] as List?;

      if (breeds == null || breeds.isEmpty) {
        return Left(ServerFailure('No breed information found for this dog'));
      }

      final breed = breeds[0];
      final imageUrl = response['url'] ?? '';
      final referenceId = response['id'];

      // Build DogModel from the breed data
      final dogModel = DogModel.fromJson({
        ...breed,
        'image_url': imageUrl.isNotEmpty
            ? imageUrl
            : (referenceId != null ? '${ApiPath.dogImageCdn}$referenceId.jpg' : null),
        'id': dogId,
      });

      return Right(dogModel.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure('API Error: ${e.message}'));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }
}
