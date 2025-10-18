import 'package:animals_tasks/features/home/domain/entities/category_entity.dart';
import 'package:animals_tasks/features/home/presentation/cubit/get_categories/get_categories_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('🧠 GetCategoriesState', () {
    test('initial state has correct type', () {
      final state = GetCategoriesInitial();
      expect(state, isA<GetCategoriesInitial>());
    });

    test('loading state has correct type', () {
      final state = GetCategoriesLoading();
      expect(state, isA<GetCategoriesLoading>());
    });

    test('loaded state holds correct categories', () {
      final categories = [
        const CategoryEntity(id: 0, name: 'All'),
        const CategoryEntity(id: 1, name: 'Funny'),
      ];
      final state = GetCategoriesLoaded(categories);

      expect(state.categories.length, 2);
      expect(state.categories.first.name, 'All');
    });

    test('error state holds correct message', () {
      final state = GetCategoriesError('Something went wrong');
      expect(state.message, 'Something went wrong');
    });
  });
}
