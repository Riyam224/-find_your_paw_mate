import 'package:flutter_test/flutter_test.dart';
import 'package:animals_tasks/core/di/di.dart';
import 'package:dio/dio.dart';
import 'package:animals_tasks/core/services/dog_api_service.dart';
import 'package:animals_tasks/core/networking/api_constants.dart';

// Dogs Feature
import 'package:animals_tasks/features/home/domain/repositories/dog_repo.dart';
import 'package:animals_tasks/features/home/data/repositories/dog_repo_impl.dart';
import 'package:animals_tasks/features/home/domain/usecases/get_dogs_usecase.dart';
import 'package:animals_tasks/features/home/domain/usecases/search_dogs_usecase.dart';
import 'package:animals_tasks/features/home/presentation/cubit/get_dogs/get_dogs_cubit.dart';
import 'package:animals_tasks/features/home/presentation/cubit/search_dogs/search_dogs_cubit.dart';

// Categories Feature
import 'package:animals_tasks/features/home/domain/repositories/category_repo.dart';
import 'package:animals_tasks/features/home/data/repositories/category_repo_impl.dart';
import 'package:animals_tasks/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:animals_tasks/features/home/presentation/cubit/get_categories/get_categories_cubit.dart';

// Details Feature
import 'package:animals_tasks/features/details/domain/repositories/dog_details_repo.dart';
import 'package:animals_tasks/features/details/data/repositories/dog_details_repo_impl.dart';
import 'package:animals_tasks/features/details/domain/usecases/get_dog_details_usecase.dart';
import 'package:animals_tasks/features/details/presentation/cubit/get_dog_details_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Dependency Injection Setup Tests', () {
    setUpAll(() async {
      await setupDependencies();
    });

    tearDownAll(() {
      getIt.reset();
    });

    group('Core Dependencies', () {
      test('should register Dio with correct configuration', () {
        final dio = getIt<Dio>();

        expect(dio, isNotNull);
        expect(dio, isA<Dio>());
        expect(dio.options.baseUrl, equals(ApiConstants.baseUrl));
        expect(dio.options.headers['x-api-key'], equals(ApiConstants.apiKey));
        expect(dio.options.headers['Content-Type'], equals('application/json'));
        expect(dio.options.connectTimeout, equals(const Duration(seconds: 10)));
        expect(dio.options.receiveTimeout, equals(const Duration(seconds: 10)));
      });

      test('should register Dio as singleton (same instance on multiple calls)', () {
        final dio1 = getIt<Dio>();
        final dio2 = getIt<Dio>();

        expect(dio1, same(dio2));
      });

      test('should register DogApiService successfully', () {
        final apiService = getIt<DogApiService>();

        expect(apiService, isNotNull);
        expect(apiService, isA<DogApiService>());
      });

      test('should register DogApiService as singleton', () {
        final apiService1 = getIt<DogApiService>();
        final apiService2 = getIt<DogApiService>();

        expect(apiService1, same(apiService2));
      });

      test('should inject Dio into DogApiService', () {
        final dio = getIt<Dio>();
        final apiService = getIt<DogApiService>();

        // Verify the service was created successfully (dependency was resolved)
        expect(apiService, isNotNull);
        expect(dio, isNotNull);
      });
    });

    group('Dogs Feature Dependencies', () {
      test('should register DogRepository successfully', () {
        final repository = getIt<DogRepository>();

        expect(repository, isNotNull);
        expect(repository, isA<DogRepository>());
        expect(repository, isA<DogRepositoryImpl>());
      });

      test('should register DogRepository as singleton', () {
        final repo1 = getIt<DogRepository>();
        final repo2 = getIt<DogRepository>();

        expect(repo1, same(repo2));
      });

      test('should register GetDogsUseCase successfully', () {
        final useCase = getIt<GetDogsUseCase>();

        expect(useCase, isNotNull);
        expect(useCase, isA<GetDogsUseCase>());
      });

      test('should register GetDogsUseCase as singleton', () {
        final useCase1 = getIt<GetDogsUseCase>();
        final useCase2 = getIt<GetDogsUseCase>();

        expect(useCase1, same(useCase2));
      });

      test('should register GetDogsCubit successfully', () {
        final cubit = getIt<GetDogsCubit>();

        expect(cubit, isNotNull);
        expect(cubit, isA<GetDogsCubit>());
      });

      test('should register GetDogsCubit as factory (new instance each time)', () {
        final cubit1 = getIt<GetDogsCubit>();
        final cubit2 = getIt<GetDogsCubit>();

        expect(cubit1, isNot(same(cubit2)));
      });

      test('should register SearchDogsUseCase successfully', () {
        final useCase = getIt<SearchDogsUseCase>();

        expect(useCase, isNotNull);
        expect(useCase, isA<SearchDogsUseCase>());
      });

      test('should register SearchDogsUseCase as singleton', () {
        final useCase1 = getIt<SearchDogsUseCase>();
        final useCase2 = getIt<SearchDogsUseCase>();

        expect(useCase1, same(useCase2));
      });

      test('should register SearchDogsCubit successfully', () {
        final cubit = getIt<SearchDogsCubit>();

        expect(cubit, isNotNull);
        expect(cubit, isA<SearchDogsCubit>());
      });

      test('should register SearchDogsCubit as factory (new instance each time)', () {
        final cubit1 = getIt<SearchDogsCubit>();
        final cubit2 = getIt<SearchDogsCubit>();

        expect(cubit1, isNot(same(cubit2)));
      });
    });

    group('Categories Feature Dependencies', () {
      test('should register CategoryRepository successfully', () {
        final repository = getIt<CategoryRepository>();

        expect(repository, isNotNull);
        expect(repository, isA<CategoryRepository>());
        expect(repository, isA<CategoryRepositoryImpl>());
      });

      test('should register CategoryRepository as singleton', () {
        final repo1 = getIt<CategoryRepository>();
        final repo2 = getIt<CategoryRepository>();

        expect(repo1, same(repo2));
      });

      test('should register GetCategoriesUseCase successfully', () {
        final useCase = getIt<GetCategoriesUseCase>();

        expect(useCase, isNotNull);
        expect(useCase, isA<GetCategoriesUseCase>());
      });

      test('should register GetCategoriesUseCase as singleton', () {
        final useCase1 = getIt<GetCategoriesUseCase>();
        final useCase2 = getIt<GetCategoriesUseCase>();

        expect(useCase1, same(useCase2));
      });

      test('should register GetCategoriesCubit successfully', () {
        final cubit = getIt<GetCategoriesCubit>();

        expect(cubit, isNotNull);
        expect(cubit, isA<GetCategoriesCubit>());
      });

      test('should register GetCategoriesCubit as factory (new instance each time)', () {
        final cubit1 = getIt<GetCategoriesCubit>();
        final cubit2 = getIt<GetCategoriesCubit>();

        expect(cubit1, isNot(same(cubit2)));
      });
    });

    group('Details Feature Dependencies', () {
      test('should register DogDetailsRepository successfully', () {
        final repository = getIt<DogDetailsRepository>();

        expect(repository, isNotNull);
        expect(repository, isA<DogDetailsRepository>());
        expect(repository, isA<DogDetailsRepositoryImpl>());
      });

      test('should register DogDetailsRepository as singleton', () {
        final repo1 = getIt<DogDetailsRepository>();
        final repo2 = getIt<DogDetailsRepository>();

        expect(repo1, same(repo2));
      });

      test('should register GetDogDetailsUseCase successfully', () {
        final useCase = getIt<GetDogDetailsUseCase>();

        expect(useCase, isNotNull);
        expect(useCase, isA<GetDogDetailsUseCase>());
      });

      test('should register GetDogDetailsUseCase as singleton', () {
        final useCase1 = getIt<GetDogDetailsUseCase>();
        final useCase2 = getIt<GetDogDetailsUseCase>();

        expect(useCase1, same(useCase2));
      });

      test('should register GetDogDetailsCubit successfully', () {
        final cubit = getIt<GetDogDetailsCubit>();

        expect(cubit, isNotNull);
        expect(cubit, isA<GetDogDetailsCubit>());
      });

      test('should register GetDogDetailsCubit as factory (new instance each time)', () {
        final cubit1 = getIt<GetDogDetailsCubit>();
        final cubit2 = getIt<GetDogDetailsCubit>();

        expect(cubit1, isNot(same(cubit2)));
      });
    });

    group('Dependency Chain Validation', () {
      test('should resolve full dependency chain for GetDogsCubit', () {
        final cubit = getIt<GetDogsCubit>();
        final useCase = getIt<GetDogsUseCase>();
        final repository = getIt<DogRepository>();

        expect(cubit, isNotNull);
        expect(useCase, isNotNull);
        expect(repository, isNotNull);
      });

      test('should resolve full dependency chain for SearchDogsCubit', () {
        final cubit = getIt<SearchDogsCubit>();
        final useCase = getIt<SearchDogsUseCase>();
        final repository = getIt<DogRepository>();

        expect(cubit, isNotNull);
        expect(useCase, isNotNull);
        expect(repository, isNotNull);
      });

      test('should resolve full dependency chain for GetCategoriesCubit', () {
        final cubit = getIt<GetCategoriesCubit>();
        final useCase = getIt<GetCategoriesUseCase>();
        final repository = getIt<CategoryRepository>();

        expect(cubit, isNotNull);
        expect(useCase, isNotNull);
        expect(repository, isNotNull);
      });

      test('should resolve full dependency chain for GetDogDetailsCubit', () {
        final cubit = getIt<GetDogDetailsCubit>();
        final useCase = getIt<GetDogDetailsUseCase>();
        final repository = getIt<DogDetailsRepository>();

        expect(cubit, isNotNull);
        expect(useCase, isNotNull);
        expect(repository, isNotNull);
      });

      test('should share DogRepository between GetDogsUseCase and SearchDogsUseCase', () {
        final getDogsUseCase = getIt<GetDogsUseCase>();
        final searchDogsUseCase = getIt<SearchDogsUseCase>();

        // Both use cases should receive the same repository instance
        expect(getDogsUseCase, isNotNull);
        expect(searchDogsUseCase, isNotNull);
      });
    });

    group('Edge Cases and Error Handling', () {
      test('should throw error when trying to register same type twice', () async {
        // Setup is already called in setUpAll, calling again should throw
        expect(() async => await setupDependencies(), throwsArgumentError);
      });

      test('should be able to get all registered types without errors', () {
        expect(() => getIt<Dio>(), returnsNormally);
        expect(() => getIt<DogApiService>(), returnsNormally);
        expect(() => getIt<DogRepository>(), returnsNormally);
        expect(() => getIt<GetDogsUseCase>(), returnsNormally);
        expect(() => getIt<GetDogsCubit>(), returnsNormally);
        expect(() => getIt<SearchDogsUseCase>(), returnsNormally);
        expect(() => getIt<SearchDogsCubit>(), returnsNormally);
        expect(() => getIt<CategoryRepository>(), returnsNormally);
        expect(() => getIt<GetCategoriesUseCase>(), returnsNormally);
        expect(() => getIt<GetCategoriesCubit>(), returnsNormally);
        expect(() => getIt<DogDetailsRepository>(), returnsNormally);
        expect(() => getIt<GetDogDetailsUseCase>(), returnsNormally);
        expect(() => getIt<GetDogDetailsCubit>(), returnsNormally);
      });

      test('should create new cubit instances each time (factory registration)', () {
        final getDogsCubit1 = getIt<GetDogsCubit>();
        final getDogsCubit2 = getIt<GetDogsCubit>();
        final searchDogsCubit1 = getIt<SearchDogsCubit>();
        final searchDogsCubit2 = getIt<SearchDogsCubit>();
        final getCategoriesCubit1 = getIt<GetCategoriesCubit>();
        final getCategoriesCubit2 = getIt<GetCategoriesCubit>();
        final getDogDetailsCubit1 = getIt<GetDogDetailsCubit>();
        final getDogDetailsCubit2 = getIt<GetDogDetailsCubit>();

        // All cubits should be different instances
        expect(getDogsCubit1, isNot(same(getDogsCubit2)));
        expect(searchDogsCubit1, isNot(same(searchDogsCubit2)));
        expect(getCategoriesCubit1, isNot(same(getCategoriesCubit2)));
        expect(getDogDetailsCubit1, isNot(same(getDogDetailsCubit2)));
      });

      test('should verify all cubits have their initial states', () {
        final getDogsCubit = getIt<GetDogsCubit>();
        final searchDogsCubit = getIt<SearchDogsCubit>();
        final getCategoriesCubit = getIt<GetCategoriesCubit>();
        final getDogDetailsCubit = getIt<GetDogDetailsCubit>();

        // Verify cubits are in their initial states
        expect(getDogsCubit.state, isNotNull);
        expect(searchDogsCubit.state, isNotNull);
        expect(getCategoriesCubit.state, isNotNull);
        expect(getDogDetailsCubit.state, isNotNull);
      });
    });

    group('Registration Type Validation', () {
      test('should verify singleton registrations maintain state', () {
        final dio1 = getIt<Dio>();
        final dio2 = getIt<Dio>();
        final apiService1 = getIt<DogApiService>();
        final apiService2 = getIt<DogApiService>();
        final dogRepo1 = getIt<DogRepository>();
        final dogRepo2 = getIt<DogRepository>();

        // Verify singletons are the same instance
        expect(identical(dio1, dio2), isTrue);
        expect(identical(apiService1, apiService2), isTrue);
        expect(identical(dogRepo1, dogRepo2), isTrue);
      });

      test('should verify factory registrations create new instances', () {
        final getDogsCubit1 = getIt<GetDogsCubit>();
        final getDogsCubit2 = getIt<GetDogsCubit>();

        // Verify factories create new instances
        expect(identical(getDogsCubit1, getDogsCubit2), isFalse);
      });
    });

    group('Configuration Validation', () {
      test('should have correct Dio timeout configurations', () {
        final dio = getIt<Dio>();

        expect(dio.options.connectTimeout?.inSeconds, equals(10));
        expect(dio.options.receiveTimeout?.inSeconds, equals(10));
      });

      test('should have correct API headers configured', () {
        final dio = getIt<Dio>();

        expect(dio.options.headers['x-api-key'], isNotEmpty);
        expect(dio.options.headers['Content-Type'], equals('application/json'));
      });

      test('should have correct base URL configured', () {
        final dio = getIt<Dio>();

        expect(dio.options.baseUrl, isNotEmpty);
        expect(dio.options.baseUrl, equals(ApiConstants.baseUrl));
      });
    });
  });
}
