import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:animals_tasks/features/home/presentation/cubit/get_dogs/get_dogs_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('🐾 GetDogsState', () {
    test('initial state has correct type', () {
      final state = GetDogsInitial();
      expect(state, isA<GetDogsInitial>());
    });

    test('loading state has correct type', () {
      final state = GetDogsLoading();
      expect(state, isA<GetDogsLoading>());
    });

    test('loaded state holds correct dogs', () {
      final dogs = [
        const DogEntity(id: '1', name: 'Bulldog', imageUrl: 'url1'),
        const DogEntity(id: '2', name: 'Beagle', imageUrl: 'url2'),
      ];
      final state = GetDogsLoaded(dogs);

      expect(state.dogs.length, 2);
      expect(state.dogs.first.name, 'Bulldog');
    });

    test('error state holds correct message', () {
      final state = GetDogsError('Network error');
      expect(state.message, 'Network error');
    });

    test('two different errors are not equal (runtime type check)', () {
      final a = GetDogsError('Error A');
      final b = GetDogsError('Error B');
      expect(a.runtimeType, equals(b.runtimeType));
      expect(a.message, isNot(equals(b.message)));
    });
  });
}
