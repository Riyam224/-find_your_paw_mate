import 'package:flutter_test/flutter_test.dart';
import 'package:animals_tasks/core/di/di.dart';
import 'package:dio/dio.dart';
import 'package:animals_tasks/core/services/dog_api_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await setupDependencies();
  });

  test('should register Dio and DogApiService successfully', () {
    final dio = getIt<Dio>();
    final apiService = getIt<DogApiService>();

    expect(dio, isNotNull);
    expect(apiService, isNotNull);
    expect(apiService, isA<DogApiService>());
  });
}
