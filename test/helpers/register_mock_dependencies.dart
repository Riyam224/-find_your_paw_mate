import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

// 🧩 Import Cubits
import 'package:animals_tasks/features/home/presentation/cubit/get_dogs/get_dogs_cubit.dart';
import 'package:animals_tasks/features/home/presentation/cubit/search_dogs/search_dogs_cubit.dart';
import 'package:animals_tasks/features/home/presentation/cubit/get_categories/get_categories_cubit.dart';
import 'package:animals_tasks/features/details/presentation/cubit/get_dog_details_cubit.dart';
import 'package:animals_tasks/features/favorite/presentation/cubit/favorite_cubit.dart';

// 🧩 Import States
import 'package:animals_tasks/features/home/presentation/cubit/get_dogs/get_dogs_state.dart';
import 'package:animals_tasks/features/home/presentation/cubit/search_dogs/search_dogs_state.dart';
import 'package:animals_tasks/features/home/presentation/cubit/get_categories/get_categories_state.dart';
import 'package:animals_tasks/features/details/presentation/cubit/get_dog_details_state.dart';
import 'package:animals_tasks/features/favorite/presentation/cubit/favorite_state.dart';

/// ------------------------------------------------------
/// 🧪 Mock Classes
/// ------------------------------------------------------
class MockGetDogsCubit extends Mock implements GetDogsCubit {}

class MockSearchDogsCubit extends Mock implements SearchDogsCubit {}

class MockGetCategoriesCubit extends Mock implements GetCategoriesCubit {}

class MockGetDogDetailsCubit extends Mock implements GetDogDetailsCubit {}

class MockFavoriteCubit extends Mock implements FavoriteCubit {}

/// ------------------------------------------------------
/// 🧩 Register All Mock Dependencies
/// ------------------------------------------------------
void registerMockDependencies(GetIt sl) {
  // Reset GetIt for a clean test environment
  sl.reset(dispose: false);

  // 🐶 GetDogsCubit
  final mockDogsCubit = MockGetDogsCubit();
  when(() => mockDogsCubit.stream).thenAnswer((_) => const Stream.empty());
  when(() => mockDogsCubit.state).thenReturn(GetDogsInitial());
  when(() => mockDogsCubit.fetchDogs()).thenAnswer((_) async {});
  when(() => mockDogsCubit.fetchCatsByCategory(any())).thenAnswer((_) async {});
  when(() => mockDogsCubit.close()).thenAnswer((_) async {}); // ✅ important

  // 🔍 SearchDogsCubit
  final mockSearchCubit = MockSearchDogsCubit();
  when(() => mockSearchCubit.stream).thenAnswer((_) => const Stream.empty());
  when(() => mockSearchCubit.state).thenReturn(SearchDogsInitial());
  when(() => mockSearchCubit.close()).thenAnswer((_) async {}); // ✅

  // 🏷️ GetCategoriesCubit
  final mockCategoriesCubit = MockGetCategoriesCubit();
  when(
    () => mockCategoriesCubit.stream,
  ).thenAnswer((_) => const Stream.empty());
  when(() => mockCategoriesCubit.state).thenReturn(GetCategoriesInitial());
  when(() => mockCategoriesCubit.fetchCategories()).thenAnswer((_) async {});
  when(() => mockCategoriesCubit.close()).thenAnswer((_) async {}); // ✅

  // 🐕 GetDogDetailsCubit
  final mockDogDetailsCubit = MockGetDogDetailsCubit();
  when(
    () => mockDogDetailsCubit.stream,
  ).thenAnswer((_) => const Stream.empty());
  when(() => mockDogDetailsCubit.state).thenReturn(GetDogDetailsInitial());
  when(
    () => mockDogDetailsCubit.fetchDogDetails(any()),
  ).thenAnswer((_) async {});
  when(() => mockDogDetailsCubit.close()).thenAnswer((_) async {}); // ✅

  // 💖 FavoriteCubit
  final mockFavoriteCubit = MockFavoriteCubit();
  when(() => mockFavoriteCubit.stream).thenAnswer((_) => const Stream.empty());
  when(() => mockFavoriteCubit.state).thenReturn(FavoriteInitial());
  when(() => mockFavoriteCubit.getFavorites()).thenAnswer((_) async {});
  when(
    () => mockFavoriteCubit.addFavorite(
      imageId: any(named: 'imageId'),
      subId: any(named: 'subId'),
    ),
  ).thenAnswer((_) async {});
  when(
    () =>
        mockFavoriteCubit.removeFavorite(favoriteId: any(named: 'favoriteId')),
  ).thenAnswer((_) async {});
  when(() => mockFavoriteCubit.close()).thenAnswer((_) async {}); // ✅

  // Register mocks in GetIt
  sl
    ..registerLazySingleton<GetDogsCubit>(() => mockDogsCubit)
    ..registerLazySingleton<SearchDogsCubit>(() => mockSearchCubit)
    ..registerLazySingleton<GetCategoriesCubit>(() => mockCategoriesCubit)
    ..registerLazySingleton<GetDogDetailsCubit>(() => mockDogDetailsCubit)
    ..registerLazySingleton<FavoriteCubit>(() => mockFavoriteCubit);
}
