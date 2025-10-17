import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

// 🌐 Core
import 'package:animals_tasks/core/networking/api_constants.dart';
import 'package:animals_tasks/core/services/dog_api_service.dart';

// 🐶 Features - Dogs
import 'package:animals_tasks/features/home/data/repositories/dog_repo_impl.dart';
import 'package:animals_tasks/features/home/domain/repositories/dog_repo.dart';
import 'package:animals_tasks/features/home/domain/usecases/get_dogs_usecase.dart';
import 'package:animals_tasks/features/home/domain/usecases/search_dogs_usecase.dart';
import 'package:animals_tasks/features/home/presentation/cubit/get_dogs/get_dogs_cubit.dart';
import 'package:animals_tasks/features/home/presentation/cubit/search_dogs/search_dogs_cubit.dart';

// 🏷️ Features - Categories
import 'package:animals_tasks/features/home/data/repositories/category_repo_impl.dart';
import 'package:animals_tasks/features/home/domain/repositories/category_repo.dart';
import 'package:animals_tasks/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:animals_tasks/features/home/presentation/cubit/get_categories/get_categories_cubit.dart';

// 🔍 Features - Dog Details
import 'package:animals_tasks/features/details/data/repositories/dog_details_repo_impl.dart';
import 'package:animals_tasks/features/details/domain/repositories/dog_details_repo.dart';
import 'package:animals_tasks/features/details/domain/usecases/get_dog_details_usecase.dart';
import 'package:animals_tasks/features/details/presentation/cubit/get_dog_details_cubit.dart';

// ❤️ Features - Favorites
import 'package:animals_tasks/features/favorite/data/repositories/favorite_repository_impl.dart';
import 'package:animals_tasks/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:animals_tasks/features/favorite/domain/usecases/get_favorites_usecase.dart';
import 'package:animals_tasks/features/favorite/domain/usecases/add_favorite_usecase.dart';
import 'package:animals_tasks/features/favorite/domain/usecases/remove_favorite_usecase.dart';
import 'package:animals_tasks/features/favorite/presentation/cubit/favorite_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // 🔹 Dio (shared globally)
  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: {
          'x-api-key': ApiConstants.apiKey,
          'Content-Type': 'application/json',
        },
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    ),
  );

  // 🔹 API Service
  getIt.registerLazySingleton<DogApiService>(() => DogApiService(getIt()));

  // 🐶 Dogs Feature
  // 🔹 Repository
  getIt.registerLazySingleton<DogRepository>(
    () => DogRepositoryImpl(getIt<DogApiService>()),
  );

  // 🔹 UseCase
  getIt.registerLazySingleton<GetDogsUseCase>(
    () => GetDogsUseCase(getIt<DogRepository>()),
  );

  // 🔹 Cubit
  getIt.registerFactory<GetDogsCubit>(
    () => GetDogsCubit(getIt<GetDogsUseCase>(), getIt<DogRepository>()),
  );

  // 🔍 Search Dogs Feature
  // 🔹 UseCase (reuses DogRepository)
  getIt.registerLazySingleton<SearchDogsUseCase>(
    () => SearchDogsUseCase(getIt<DogRepository>()),
  );

  // 🔹 Cubit
  getIt.registerFactory<SearchDogsCubit>(
    () => SearchDogsCubit(getIt<SearchDogsUseCase>()),
  );

  // 🏷️ Categories Feature
  // 🔹 Repository
  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(getIt<DogApiService>()),
  );

  // 🔹 UseCase
  getIt.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(getIt<CategoryRepository>()),
  );

  // 🔹 Cubit
  getIt.registerFactory<GetCategoriesCubit>(
    () => GetCategoriesCubit(getIt<GetCategoriesUseCase>()),
  );

  // 🔍 Dog Details Feature
  // 🔹 Repository
  getIt.registerLazySingleton<DogDetailsRepository>(
    () => DogDetailsRepositoryImpl(getIt<DogApiService>()),
  );

  // 🔹 UseCase
  getIt.registerLazySingleton<GetDogDetailsUseCase>(
    () => GetDogDetailsUseCase(getIt<DogDetailsRepository>()),
  );

  // 🔹 Cubit
  getIt.registerFactory<GetDogDetailsCubit>(
    () => GetDogDetailsCubit(getIt<GetDogDetailsUseCase>()),
  );

  // ❤️ Favorites Feature
  // 🔹 Repository
  getIt.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(getIt<DogApiService>()),
  );

  // 🔹 UseCases
  getIt.registerLazySingleton<GetFavoritesUseCase>(
    () => GetFavoritesUseCase(getIt<FavoriteRepository>()),
  );

  getIt.registerLazySingleton<AddFavoriteUseCase>(
    () => AddFavoriteUseCase(getIt<FavoriteRepository>()),
  );

  getIt.registerLazySingleton<RemoveFavoriteUseCase>(
    () => RemoveFavoriteUseCase(getIt<FavoriteRepository>()),
  );

  // 🔹 Cubit
  getIt.registerFactory<FavoriteCubit>(
    () => FavoriteCubit(
      getIt<GetFavoritesUseCase>(),
      getIt<AddFavoriteUseCase>(),
      getIt<RemoveFavoriteUseCase>(),
    ),
  );
}
