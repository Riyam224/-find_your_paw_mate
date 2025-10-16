import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animals_tasks/features/home/domain/usecases/get_dogs_usecase.dart';
import 'package:animals_tasks/features/home/domain/repositories/dog_repo.dart';
import 'package:animals_tasks/features/home/presentation/cubit/get_dogs_state.dart';

/// 🐶 Handles fetching dogs for the Home Screen.
/// Applies Clean Architecture + SOLID + functional error handling (Either)
class GetDogsCubit extends Cubit<GetDogsState> {
  final GetDogsUseCase _getDogsUseCase;
  final DogRepository _dogRepository;

  GetDogsCubit(this._getDogsUseCase, this._dogRepository) : super(GetDogsInitial());

  /// 🐾 Fetch list of dogs
  Future<void> fetchDogs({int limit = 10, int page = 0}) async {
    emit(GetDogsLoading());
    final result = await _getDogsUseCase(limit: limit, page: page);

    result.fold(
      (failure) => emit(GetDogsError(failure.message)),
      (dogs) => emit(GetDogsLoaded(dogs)),
    );
  }

  /// 🐱 Fetch cat images by category
  Future<void> fetchCatsByCategory(int categoryId, {int limit = 10}) async {
    emit(GetDogsLoading());
    final result = await _dogRepository.getCatsByCategory(categoryId, limit: limit);

    result.fold(
      (failure) => emit(GetDogsError(failure.message)),
      (cats) => emit(GetDogsLoaded(cats)),
    );
  }
}
