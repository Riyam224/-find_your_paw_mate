import 'package:animals_tasks/core/error/failure.dart';
import 'package:animals_tasks/features/favorite/domain/entities/favorite_entity.dart';
import 'package:animals_tasks/features/favorite/domain/usecases/add_favorite_usecase.dart';
import 'package:animals_tasks/features/favorite/domain/usecases/get_favorites_usecase.dart';
import 'package:animals_tasks/features/favorite/domain/usecases/remove_favorite_usecase.dart';
import 'package:animals_tasks/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:animals_tasks/features/favorite/presentation/cubit/favorite_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFavoritesUseCase extends Mock implements GetFavoritesUseCase {}

class MockAddFavoriteUseCase extends Mock implements AddFavoriteUseCase {}

class MockRemoveFavoriteUseCase extends Mock implements RemoveFavoriteUseCase {}

void main() {
  late FavoriteCubit cubit;
  late MockGetFavoritesUseCase getFavorites;
  late MockAddFavoriteUseCase addFavorite;
  late MockRemoveFavoriteUseCase removeFavorite;

  final favorites = [
    FavoriteEntity(
      id: '1',
      imageId: 'img_1',
      imageUrl: 'https://example.com/1.jpg',
      subId: 'user_riyam',
      createdAt: DateTime(2024, 1, 1),
    ),
  ];

  final fav = FavoriteEntity(
    id: '2',
    imageId: 'img_2',
    imageUrl: 'https://example.com/2.jpg',
    subId: 'user_riyam',
    createdAt: DateTime(2024, 1, 2),
  );

  setUp(() {
    getFavorites = MockGetFavoritesUseCase();
    addFavorite = MockAddFavoriteUseCase();
    removeFavorite = MockRemoveFavoriteUseCase();

    cubit = FavoriteCubit(getFavorites, addFavorite, removeFavorite);
  });

  tearDown(() => cubit.close());

  group('FavoriteCubit', () {
    test('initial state is FavoriteInitial', () {
      expect(cubit.state, isA<FavoriteInitial>());
    });

    // 📦 getFavorites
    blocTest<FavoriteCubit, FavoriteState>(
      'emits [Loading, Loaded] on successful getFavorites',
      build: () {
        when(
          () => getFavorites(
            subId: any(named: 'subId'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => Right(favorites));
        return cubit;
      },
      act: (c) => c.getFavorites(),
      expect: () => [
        isA<FavoriteLoading>(),
        isA<FavoriteLoaded>().having((s) => s.favorites.length, 'length', 1),
      ],
    );

    blocTest<FavoriteCubit, FavoriteState>(
      'emits [Loading, Error] when getFavorites fails',
      build: () {
        when(
          () => getFavorites(
            subId: any(named: 'subId'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => Left(ServerFailure('Server error')));
        return cubit;
      },
      act: (c) => c.getFavorites(),
      expect: () => [
        isA<FavoriteLoading>(),
        isA<FavoriteError>().having(
          (s) => s.message,
          'message',
          'Server error',
        ),
      ],
    );

    // ❤️ addFavorite
    blocTest<FavoriteCubit, FavoriteState>(
      'emits [Added, Loading, Loaded] on successful addFavorite',
      build: () {
        when(
          () => addFavorite(
            imageId: 'img_2',
            subId: any(named: 'subId'),
          ),
        ).thenAnswer((_) async => Right(fav));
        when(
          () => getFavorites(
            subId: any(named: 'subId'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => Right([...favorites, fav]));
        return cubit;
      },
      act: (c) => c.addFavorite(imageId: 'img_2'),
      expect: () => [
        isA<FavoriteAdded>().having((s) => s.favorite.id, 'id', '2'),
        isA<FavoriteLoading>(),
        isA<FavoriteLoaded>().having((s) => s.favorites.length, 'length', 2),
      ],
    );

    blocTest<FavoriteCubit, FavoriteState>(
      'emits [Error] when addFavorite fails',
      build: () {
        when(
          () => addFavorite(
            imageId: 'img_2',
            subId: any(named: 'subId'),
          ),
        ).thenAnswer((_) async => Left(ServerFailure('Failed to add')));
        return cubit;
      },
      act: (c) => c.addFavorite(imageId: 'img_2'),
      expect: () => [
        isA<FavoriteError>().having(
          (s) => s.message,
          'message',
          'Failed to add',
        ),
      ],
    );

    // 🗑️ removeFavorite
    blocTest<FavoriteCubit, FavoriteState>(
      'emits [Removed, Loading, Loaded] on successful removeFavorite',
      build: () {
        when(
          () => removeFavorite(favoriteId: '1'),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => getFavorites(
            subId: any(named: 'subId'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (c) => c.removeFavorite(favoriteId: '1'),
      expect: () => [
        isA<FavoriteRemoved>().having((s) => s.favoriteId, 'favoriteId', '1'),
        isA<FavoriteLoading>(),
        isA<FavoriteLoaded>().having((s) => s.favorites, 'favorites', isEmpty),
      ],
    );

    blocTest<FavoriteCubit, FavoriteState>(
      'emits [Error] when removeFavorite fails',
      build: () {
        when(
          () => removeFavorite(favoriteId: '1'),
        ).thenAnswer((_) async => Left(ServerFailure('Failed to remove')));
        return cubit;
      },
      act: (c) => c.removeFavorite(favoriteId: '1'),
      expect: () => [
        isA<FavoriteError>().having(
          (s) => s.message,
          'message',
          'Failed to remove',
        ),
      ],
    );
  });
}
