import 'package:animals_tasks/features/details/presentation/cubit/get_dog_details_state.dart';
import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GetDogDetailsState', () {
    const testDog = DogEntity(
      id: '1',
      name: 'Golden Retriever',
      imageUrl: 'https://example.com/image.jpg',
    );

    test('GetDogDetailsInitial should have correct props', () {
      // Arrange
      final state = GetDogDetailsInitial();

      // Assert
      expect(state.props, []);
    });

    test('GetDogDetailsLoading should have correct props', () {
      // Arrange
      final state = GetDogDetailsLoading();

      // Assert
      expect(state.props, []);
    });

    test('GetDogDetailsLoaded should have correct props', () {
      // Arrange
      const state = GetDogDetailsLoaded(testDog);

      // Assert
      expect(state.props, [testDog]);
      expect(state.dog, testDog);
    });

    test('GetDogDetailsError should have correct props', () {
      // Arrange
      const state = GetDogDetailsError('Error message');

      // Assert
      expect(state.props, ['Error message']);
      expect(state.message, 'Error message');
    });

    test('GetDogDetailsLoaded should support equality', () {
      // Arrange
      const state1 = GetDogDetailsLoaded(testDog);
      const state2 = GetDogDetailsLoaded(testDog);

      // Assert
      expect(state1, state2);
    });

    test('GetDogDetailsError should support equality', () {
      // Arrange
      const state1 = GetDogDetailsError('Error');
      const state2 = GetDogDetailsError('Error');

      // Assert
      expect(state1, state2);
    });
  });
}
