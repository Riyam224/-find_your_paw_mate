import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animals_tasks/features/home/domain/usecases/search_dogs_usecase.dart';
import 'package:animals_tasks/features/home/presentation/cubit/search_dogs/search_dogs_state.dart';

/// 🔍 Handles searching for dogs by breed name
/// Applies Clean Architecture + SOLID + functional error handling (Either)
class SearchDogsCubit extends Cubit<SearchDogsState> {
  final SearchDogsUseCase _searchDogsUseCase;

  SearchDogsCubit(this._searchDogsUseCase) : super(SearchDogsInitial());

  /// 🔍 Search for dogs by breed name
  Future<void> searchDogs(String query, {int limit = 20, int page = 0}) async {
    // Don't search if query is empty
    if (query.trim().isEmpty) {
      emit(SearchDogsInitial());
      return;
    }

    emit(SearchDogsLoading());
    final result = await _searchDogsUseCase(
      query: query,
      limit: limit,
      page: page,
    );

    result.fold(
      (failure) => emit(SearchDogsError(failure.message)),
      (dogs) {
        if (dogs.isEmpty) {
          emit(SearchDogsEmpty(query));
        } else {
          emit(SearchDogsLoaded(dogs, query));
        }
      },
    );
  }

  /// Clear search results and return to initial state
  void clearSearch() {
    emit(SearchDogsInitial());
  }
}
