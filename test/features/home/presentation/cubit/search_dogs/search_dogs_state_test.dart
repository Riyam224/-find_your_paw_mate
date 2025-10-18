import 'package:animals_tasks/features/home/domain/entities/dog_entity.dart';
import 'package:animals_tasks/features/home/presentation/cubit/search_dogs/search_dogs_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('🔍 SearchDogsState', () {
    test('initial state has correct type', () {
      final state = SearchDogsInitial();
      expect(state, isA<SearchDogsInitial>());
    });

    test('loading state has correct type', () {
      final state = SearchDogsLoading();
      expect(state, isA<SearchDogsLoading>());
    });

    test('loaded state holds correct dogs and query', () {
      final dogs = [
        const DogEntity(id: '1', name: 'Bulldog', imageUrl: 'url1'),
        const DogEntity(id: '2', name: 'Poodle', imageUrl: 'url2'),
      ];
      final state = SearchDogsLoaded(dogs, 'Bulldog');

      expect(state.dogs.length, 2);
      expect(state.query, 'Bulldog');
      expect(state.dogs.first.name, 'Bulldog');
    });

    test('empty state holds the search query', () {
      final state = SearchDogsEmpty('UnknownBreed');
      expect(state.query, 'UnknownBreed');
    });

    test('error state holds the correct message', () {
      final state = SearchDogsError('Server error');
      expect(state.message, 'Server error');
    });
  });
}
