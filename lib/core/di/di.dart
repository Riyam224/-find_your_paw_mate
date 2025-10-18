// import 'package:get_it/get_it.dart';
// import 'package:dio/dio.dart';

// // 🌐 Core
// import 'package:animals_tasks/core/networking/api_constants.dart';
// import 'package:animals_tasks/core/services/dog_api_service.dart';

// // 🐶 Features - Dogs
// import 'package:animals_tasks/features/home/data/repositories/dog_repo_impl.dart';
// import 'package:animals_tasks/features/home/domain/repositories/dog_repo.dart';
// import 'package:animals_tasks/features/home/domain/usecases/get_dogs_usecase.dart';
// import 'package:animals_tasks/features/home/domain/usecases/search_dogs_usecase.dart';
// import 'package:animals_tasks/features/home/presentation/cubit/get_dogs/get_dogs_cubit.dart';
// import 'package:animals_tasks/features/home/presentation/cubit/search_dogs/search_dogs_cubit.dart';

// // 🏷️ Features - Categories
// import 'package:animals_tasks/features/home/data/repositories/category_repo_impl.dart';
// import 'package:animals_tasks/features/home/domain/repositories/category_repo.dart';
// import 'package:animals_tasks/features/home/domain/usecases/get_categories_usecase.dart';
// import 'package:animals_tasks/features/home/presentation/cubit/get_categories/get_categories_cubit.dart';

// // 🔍 Features - Dog Details
// import 'package:animals_tasks/features/details/data/repositories/dog_details_repo_impl.dart';
// import 'package:animals_tasks/features/details/domain/repositories/dog_details_repo.dart';
// import 'package:animals_tasks/features/details/domain/usecases/get_dog_details_usecase.dart';
// import 'package:animals_tasks/features/details/presentation/cubit/get_dog_details_cubit.dart';

// // ❤️ Features - Favorites (Cats)
// import 'package:animals_tasks/features/favorite/data/repositories/favorite_repository_impl.dart';
// import 'package:animals_tasks/features/favorite/domain/repositories/favorite_repository.dart';
// import 'package:animals_tasks/features/favorite/domain/usecases/get_favorites_usecase.dart';
// import 'package:animals_tasks/features/favorite/domain/usecases/add_favorite_usecase.dart';
// import 'package:animals_tasks/features/favorite/domain/usecases/remove_favorite_usecase.dart';
// import 'package:animals_tasks/features/favorite/presentation/cubit/favorite_cubit.dart';

// final getIt = GetIt.instance;

// Future<void> setupDependencies() async {
//   // 🐶-------------------- DOG API --------------------
//   getIt.registerLazySingleton<Dio>(
//     () => Dio(
//       BaseOptions(
//         baseUrl: ApiConstants.baseUrl, // e.g. Dog API URL
//         headers: {
//           'x-api-key': ApiConstants.apiKey, // 👈 Use dog API key here
//           'Content-Type': 'application/json',
//         },
//         connectTimeout: const Duration(seconds: 10),
//         receiveTimeout: const Duration(seconds: 10),
//       ),
//     ),
//   );

//   getIt.registerLazySingleton<DogApiService>(() => DogApiService(getIt<Dio>()));

//   // 🐱-------------------- CAT API --------------------
//   getIt.registerLazySingleton<Dio>(
//     () => Dio(
//       BaseOptions(
//         baseUrl: ApiConstants.catApiBaseUrl, // e.g. Cat API URL
//         headers: {
//           'x-api-key': ApiConstants.catApiKey, // 👈 Use cat API key here
//           'Content-Type': 'application/json',
//         },
//         connectTimeout: const Duration(seconds: 10),
//         receiveTimeout: const Duration(seconds: 10),
//       ),
//     ),
//     instanceName: 'catDio', // 👈 named instance
//   );

//   getIt.registerLazySingleton<DogApiService>(
//     () => DogApiService(getIt<Dio>(instanceName: 'catDio')),
//     instanceName: 'catApiService', // 👈 named instance
//   );

//   // 🐶-------------------- DOG FEATURES --------------------
//   getIt.registerLazySingleton<DogRepository>(
//     () => DogRepositoryImpl(getIt<DogApiService>()),
//   );

//   getIt.registerLazySingleton<GetDogsUseCase>(
//     () => GetDogsUseCase(getIt<DogRepository>()),
//   );

//   getIt.registerFactory<GetDogsCubit>(
//     () => GetDogsCubit(getIt<GetDogsUseCase>(), getIt<DogRepository>()),
//   );

//   getIt.registerLazySingleton<SearchDogsUseCase>(
//     () => SearchDogsUseCase(getIt<DogRepository>()),
//   );

//   getIt.registerFactory<SearchDogsCubit>(
//     () => SearchDogsCubit(getIt<SearchDogsUseCase>()),
//   );

//   // 🏷️-------------------- CATEGORIES --------------------
//   getIt.registerLazySingleton<CategoryRepository>(
//     () => CategoryRepositoryImpl(getIt<DogApiService>()),
//   );

//   getIt.registerLazySingleton<GetCategoriesUseCase>(
//     () => GetCategoriesUseCase(getIt<CategoryRepository>()),
//   );

//   getIt.registerFactory<GetCategoriesCubit>(
//     () => GetCategoriesCubit(getIt<GetCategoriesUseCase>()),
//   );

//   // 🔍-------------------- DOG DETAILS --------------------
//   getIt.registerLazySingleton<DogDetailsRepository>(
//     () => DogDetailsRepositoryImpl(getIt<DogApiService>()),
//   );

//   getIt.registerLazySingleton<GetDogDetailsUseCase>(
//     () => GetDogDetailsUseCase(getIt<DogDetailsRepository>()),
//   );

//   getIt.registerFactory<GetDogDetailsCubit>(
//     () => GetDogDetailsCubit(getIt<GetDogDetailsUseCase>()),
//   );

//   // ❤️-------------------- FAVORITES (CATS) --------------------
//   getIt.registerLazySingleton<FavoriteRepository>(
//     () => FavoriteRepositoryImpl(
//       getIt<DogApiService>(instanceName: 'catApiService'),
//     ),
//   );

//   getIt.registerLazySingleton<GetFavoritesUseCase>(
//     () => GetFavoritesUseCase(getIt<FavoriteRepository>()),
//   );

//   getIt.registerLazySingleton<AddFavoriteUseCase>(
//     () => AddFavoriteUseCase(getIt<FavoriteRepository>()),
//   );

//   getIt.registerLazySingleton<RemoveFavoriteUseCase>(
//     () => RemoveFavoriteUseCase(getIt<FavoriteRepository>()),
//   );

//   getIt.registerFactory<FavoriteCubit>(
//     () => FavoriteCubit(
//       getIt<GetFavoritesUseCase>(),
//       getIt<AddFavoriteUseCase>(),
//       getIt<RemoveFavoriteUseCase>(),
//     ),
//   );
// }

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

// ❤️ Features - Favorites (Cats)
import 'package:animals_tasks/features/favorite/data/repositories/favorite_repository_impl.dart';
import 'package:animals_tasks/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:animals_tasks/features/favorite/domain/usecases/get_favorites_usecase.dart';
import 'package:animals_tasks/features/favorite/domain/usecases/add_favorite_usecase.dart';
import 'package:animals_tasks/features/favorite/domain/usecases/remove_favorite_usecase.dart';
import 'package:animals_tasks/features/favorite/presentation/cubit/favorite_cubit.dart';

final getIt = GetIt.instance;
bool _isDependenciesSetup = false; // ✅ prevents re-registering after hot reload

Future<void> setupDependencies() async {
  if (_isDependenciesSetup) return;
  _isDependenciesSetup = true;

  // 🐶-------------------- DOG API --------------------
  if (!getIt.isRegistered<Dio>()) {
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
  }

  if (!getIt.isRegistered<DogApiService>()) {
    getIt.registerLazySingleton<DogApiService>(
      () => DogApiService(getIt<Dio>()),
    );
  }

  // 🐱-------------------- CAT API --------------------
  if (!getIt.isRegistered<Dio>(instanceName: 'catDio')) {
    getIt.registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: ApiConstants.catApiBaseUrl,
          headers: {
            'x-api-key': ApiConstants.catApiKey,
            'Content-Type': 'application/json',
          },
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      ),
      instanceName: 'catDio',
    );
  }

  if (!getIt.isRegistered<DogApiService>(instanceName: 'catApiService')) {
    getIt.registerLazySingleton<DogApiService>(
      () => DogApiService(getIt<Dio>(instanceName: 'catDio')),
      instanceName: 'catApiService',
    );
  }

  // 🐶-------------------- DOG FEATURES --------------------
  if (!getIt.isRegistered<DogRepository>()) {
    getIt.registerLazySingleton<DogRepository>(
      () => DogRepositoryImpl(getIt<DogApiService>()),
    );
  }

  if (!getIt.isRegistered<GetDogsUseCase>()) {
    getIt.registerLazySingleton<GetDogsUseCase>(
      () => GetDogsUseCase(getIt<DogRepository>()),
    );
  }

  if (!getIt.isRegistered<GetDogsCubit>()) {
    getIt.registerFactory<GetDogsCubit>(
      () => GetDogsCubit(getIt<GetDogsUseCase>(), getIt<DogRepository>()),
    );
  }

  if (!getIt.isRegistered<SearchDogsUseCase>()) {
    getIt.registerLazySingleton<SearchDogsUseCase>(
      () => SearchDogsUseCase(getIt<DogRepository>()),
    );
  }

  if (!getIt.isRegistered<SearchDogsCubit>()) {
    getIt.registerFactory<SearchDogsCubit>(
      () => SearchDogsCubit(getIt<SearchDogsUseCase>()),
    );
  }

  // 🏷️-------------------- CATEGORIES --------------------
  if (!getIt.isRegistered<CategoryRepository>()) {
    getIt.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(getIt<DogApiService>()),
    );
  }

  if (!getIt.isRegistered<GetCategoriesUseCase>()) {
    getIt.registerLazySingleton<GetCategoriesUseCase>(
      () => GetCategoriesUseCase(getIt<CategoryRepository>()),
    );
  }

  if (!getIt.isRegistered<GetCategoriesCubit>()) {
    getIt.registerFactory<GetCategoriesCubit>(
      () => GetCategoriesCubit(getIt<GetCategoriesUseCase>()),
    );
  }

  // 🔍-------------------- DOG DETAILS --------------------
  if (!getIt.isRegistered<DogDetailsRepository>()) {
    getIt.registerLazySingleton<DogDetailsRepository>(
      () => DogDetailsRepositoryImpl(getIt<DogApiService>()),
    );
  }

  if (!getIt.isRegistered<GetDogDetailsUseCase>()) {
    getIt.registerLazySingleton<GetDogDetailsUseCase>(
      () => GetDogDetailsUseCase(getIt<DogDetailsRepository>()),
    );
  }

  if (!getIt.isRegistered<GetDogDetailsCubit>()) {
    getIt.registerFactory<GetDogDetailsCubit>(
      () => GetDogDetailsCubit(getIt<GetDogDetailsUseCase>()),
    );
  }

  // ❤️-------------------- FAVORITES (CATS) --------------------
  if (!getIt.isRegistered<FavoriteRepository>()) {
    getIt.registerLazySingleton<FavoriteRepository>(
      () => FavoriteRepositoryImpl(
        getIt<DogApiService>(instanceName: 'catApiService'),
      ),
    );
  }

  if (!getIt.isRegistered<GetFavoritesUseCase>()) {
    getIt.registerLazySingleton<GetFavoritesUseCase>(
      () => GetFavoritesUseCase(getIt<FavoriteRepository>()),
    );
  }

  if (!getIt.isRegistered<AddFavoriteUseCase>()) {
    getIt.registerLazySingleton<AddFavoriteUseCase>(
      () => AddFavoriteUseCase(getIt<FavoriteRepository>()),
    );
  }

  if (!getIt.isRegistered<RemoveFavoriteUseCase>()) {
    getIt.registerLazySingleton<RemoveFavoriteUseCase>(
      () => RemoveFavoriteUseCase(getIt<FavoriteRepository>()),
    );
  }

  if (!getIt.isRegistered<FavoriteCubit>()) {
    getIt.registerFactory<FavoriteCubit>(
      () => FavoriteCubit(
        getIt<GetFavoritesUseCase>(),
        getIt<AddFavoriteUseCase>(),
        getIt<RemoveFavoriteUseCase>(),
      ),
    );
  }
}
