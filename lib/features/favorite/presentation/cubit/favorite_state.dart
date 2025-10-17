import 'package:equatable/equatable.dart';
import '../../domain/entities/favorite_entity.dart';

/// States for Favorite feature using Equatable for value comparison
sealed class FavoriteState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state when the cubit is first created
final class FavoriteInitial extends FavoriteState {}

/// Loading state when fetching favorites
final class FavoriteLoading extends FavoriteState {}

/// Success state when favorites are loaded
final class FavoriteLoaded extends FavoriteState {
  final List<FavoriteEntity> favorites;

  FavoriteLoaded(this.favorites);

  @override
  List<Object?> get props => [favorites];
}

/// Error state when an operation fails
final class FavoriteError extends FavoriteState {
  final String message;

  FavoriteError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Success state after adding a favorite
final class FavoriteAdded extends FavoriteState {
  final FavoriteEntity favorite;

  FavoriteAdded(this.favorite);

  @override
  List<Object?> get props => [favorite];
}

/// Success state after removing a favorite
final class FavoriteRemoved extends FavoriteState {
  final String favoriteId;

  FavoriteRemoved(this.favoriteId);

  @override
  List<Object?> get props => [favoriteId];
}
