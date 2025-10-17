import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_favorites_usecase.dart';
import '../../domain/usecases/add_favorite_usecase.dart';
import '../../domain/usecases/remove_favorite_usecase.dart';
import 'favorite_state.dart';

/// Cubit for managing favorite pets
/// Handles fetching, adding, and removing favorites
/// Follows Clean Architecture and uses Dartz for error handling
class FavoriteCubit extends Cubit<FavoriteState> {
  final GetFavoritesUseCase _getFavoritesUseCase;
  final AddFavoriteUseCase _addFavoriteUseCase;
  final RemoveFavoriteUseCase _removeFavoriteUseCase;

  FavoriteCubit(
    this._getFavoritesUseCase,
    this._addFavoriteUseCase,
    this._removeFavoriteUseCase,
  ) : super(FavoriteInitial());

  /// Fetch all favorites from the repository
  Future<void> getFavorites({String? subId, int limit = 10}) async {
    emit(FavoriteLoading());

    final result = await _getFavoritesUseCase(subId: subId, limit: limit);

    result.fold(
      (failure) => emit(FavoriteError(failure.message)),
      (favorites) => emit(FavoriteLoaded(favorites)),
    );
  }

  /// Add a pet to favorites
  Future<void> addFavorite({
    required String imageId,
    String? subId,
  }) async {
    final result = await _addFavoriteUseCase(imageId: imageId, subId: subId);

    result.fold(
      (failure) => emit(FavoriteError(failure.message)),
      (favorite) {
        emit(FavoriteAdded(favorite));
        // Refresh the favorites list after adding
        getFavorites();
      },
    );
  }

  /// Remove a pet from favorites
  Future<void> removeFavorite({required String favoriteId}) async {
    final result = await _removeFavoriteUseCase(favoriteId: favoriteId);

    result.fold(
      (failure) => emit(FavoriteError(failure.message)),
      (_) {
        emit(FavoriteRemoved(favoriteId));
        // Refresh the favorites list after removing
        getFavorites();
      },
    );
  }
}
