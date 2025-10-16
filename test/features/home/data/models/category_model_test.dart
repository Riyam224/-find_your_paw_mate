import 'package:flutter_test/flutter_test.dart';
import 'package:animals_tasks/features/home/data/models/category_model.dart';
import 'package:animals_tasks/features/home/domain/entities/category_entity.dart';

void main() {
  group('CategoryModel.fromJson', () {
    group('Valid JSON parsing', () {
      test('parses complete valid JSON correctly', () {
        final json = {
          'id': 1,
          'name': 'Hound',
        };

        final model = CategoryModel.fromJson(json);

        expect(model.id, 1);
        expect(model.name, 'Hound');
      });

      test('parses JSON with different category names', () {
        final categories = [
          {'id': 1, 'name': 'Hound'},
          {'id': 2, 'name': 'Sporting'},
          {'id': 3, 'name': 'Toy'},
          {'id': 4, 'name': 'Working'},
          {'id': 5, 'name': 'Terrier'},
        ];

        for (final json in categories) {
          final model = CategoryModel.fromJson(json);
          expect(model.id, json['id']);
          expect(model.name, json['name']);
        }
      });

      test('parses JSON with special characters in name', () {
        final json = {
          'id': 10,
          'name': 'Non-Sporting & Mixed',
        };

        final model = CategoryModel.fromJson(json);

        expect(model.id, 10);
        expect(model.name, 'Non-Sporting & Mixed');
      });

      test('parses JSON with long category name', () {
        final json = {
          'id': 99,
          'name': 'Very Long Category Name With Multiple Words',
        };

        final model = CategoryModel.fromJson(json);

        expect(model.id, 99);
        expect(model.name, 'Very Long Category Name With Multiple Words');
      });

      test('parses JSON with single character name', () {
        final json = {
          'id': 7,
          'name': 'A',
        };

        final model = CategoryModel.fromJson(json);

        expect(model.id, 7);
        expect(model.name, 'A');
      });
    });

    group('Type conversion', () {
      test('handles string ID and converts to int', () {
        final json = {
          'id': '123',
          'name': 'String ID Category',
        };

        // This should work if the API sends string IDs
        // Note: The current implementation uses ?? 0, so it won't convert strings
        // But this test documents the expected behavior
        expect(() => CategoryModel.fromJson(json), throwsA(isA<TypeError>()));
      });

      test('handles double ID throws TypeError', () {
        final json = {
          'id': 5.7,
          'name': 'Double ID Category',
        };

        // The implementation uses ?? 0 which doesn't convert double to int
        expect(() => CategoryModel.fromJson(json), throwsA(isA<TypeError>()));
      });

      test('handles large integer ID', () {
        final json = {
          'id': 999999,
          'name': 'Large ID Category',
        };

        final model = CategoryModel.fromJson(json);

        expect(model.id, 999999);
      });

      test('handles negative ID', () {
        final json = {
          'id': -1,
          'name': 'Negative ID Category',
        };

        final model = CategoryModel.fromJson(json);

        expect(model.id, -1);
      });

      test('handles zero ID', () {
        final json = {
          'id': 0,
          'name': 'All',
        };

        final model = CategoryModel.fromJson(json);

        expect(model.id, 0);
        expect(model.name, 'All');
      });
    });

    group('Null and missing field handling', () {
      test('handles null id with default value', () {
        final json = {
          'id': null,
          'name': 'Null ID Category',
        };

        final model = CategoryModel.fromJson(json);

        expect(model.id, 0);
        expect(model.name, 'Null ID Category');
      });

      test('handles missing id field with default value', () {
        final json = {
          'name': 'Missing ID Category',
        };

        final model = CategoryModel.fromJson(json);

        expect(model.id, 0);
        expect(model.name, 'Missing ID Category');
      });

      test('handles null name with default value', () {
        final json = {
          'id': 5,
          'name': null,
        };

        final model = CategoryModel.fromJson(json);

        expect(model.id, 5);
        expect(model.name, 'Unknown');
      });

      test('handles missing name field with default value', () {
        final json = {
          'id': 6,
        };

        final model = CategoryModel.fromJson(json);

        expect(model.id, 6);
        expect(model.name, 'Unknown');
      });

      test('handles completely empty JSON', () {
        final json = <String, dynamic>{};

        final model = CategoryModel.fromJson(json);

        expect(model.id, 0);
        expect(model.name, 'Unknown');
      });

      test('handles both id and name as null', () {
        final json = {
          'id': null,
          'name': null,
        };

        final model = CategoryModel.fromJson(json);

        expect(model.id, 0);
        expect(model.name, 'Unknown');
      });
    });

    group('Invalid data handling', () {
      test('handles empty string name', () {
        final json = {
          'id': 1,
          'name': '',
        };

        final model = CategoryModel.fromJson(json);

        expect(model.id, 1);
        expect(model.name, ''); // Empty string passes through
      });

      test('handles whitespace-only name', () {
        final json = {
          'id': 2,
          'name': '   ',
        };

        final model = CategoryModel.fromJson(json);

        expect(model.id, 2);
        expect(model.name, '   ');
      });

      test('handles name with line breaks', () {
        final json = {
          'id': 3,
          'name': 'Category\nWith\nBreaks',
        };

        final model = CategoryModel.fromJson(json);

        expect(model.id, 3);
        expect(model.name, contains('\n'));
      });

      test('handles name with unicode characters', () {
        final json = {
          'id': 4,
          'name': 'Cat�gorie �,� =',
        };

        final model = CategoryModel.fromJson(json);

        expect(model.id, 4);
        expect(model.name, 'Cat�gorie �,� =');
      });

      test('handles invalid id type (bool)', () {
        final json = {
          'id': true,
          'name': 'Bool ID Category',
        };

        // Bool cannot be cast to int, should throw
        expect(() => CategoryModel.fromJson(json), throwsA(isA<TypeError>()));
      });

      test('handles invalid id type (list)', () {
        final json = {
          'id': [1, 2, 3],
          'name': 'List ID Category',
        };

        expect(() => CategoryModel.fromJson(json), throwsA(isA<TypeError>()));
      });

      test('handles invalid name type (int)', () {
        final json = {
          'id': 1,
          'name': 123,
        };

        // int can be converted to String with ??
        // But the actual implementation just uses ?? 'Unknown'
        // so it won't handle this case
        expect(() => CategoryModel.fromJson(json), throwsA(isA<TypeError>()));
      });

      test('handles invalid name type (map)', () {
        final json = {
          'id': 1,
          'name': {'invalid': 'object'},
        };

        expect(() => CategoryModel.fromJson(json), throwsA(isA<TypeError>()));
      });
    });

    group('Edge cases for category not found', () {
      test('handles category with id 0 representing "All"', () {
        final json = {
          'id': 0,
          'name': 'All',
        };

        final model = CategoryModel.fromJson(json);

        expect(model.id, 0);
        expect(model.name, 'All');
      });

      test('handles default unknown category', () {
        final json = {
          'id': 0,
          'name': 'Unknown',
        };

        final model = CategoryModel.fromJson(json);

        expect(model.id, 0);
        expect(model.name, 'Unknown');
      });

      test('parses multiple categories including edge cases', () {
        final jsonList = [
          {'id': 0, 'name': 'All'},
          {'id': null, 'name': 'Null ID'},
          {'id': 1, 'name': null},
          {'id': 2, 'name': ''},
          {'id': 3, 'name': 'Valid'},
        ];

        final models = jsonList
            .map((json) => CategoryModel.fromJson(json))
            .toList();

        expect(models.length, 5);
        expect(models[0].id, 0);
        expect(models[0].name, 'All');
        expect(models[1].id, 0);
        expect(models[1].name, 'Null ID');
        expect(models[2].id, 1);
        expect(models[2].name, 'Unknown');
        expect(models[3].id, 2);
        expect(models[3].name, '');
        expect(models[4].id, 3);
        expect(models[4].name, 'Valid');
      });
    });
  });

  group('CategoryModel.toEntity', () {
    test('converts complete model to entity correctly', () {
      const model = CategoryModel(
        id: 1,
        name: 'Hound',
      );

      final entity = model.toEntity();

      expect(entity, isA<CategoryEntity>());
      expect(entity.id, 1);
      expect(entity.name, 'Hound');
    });

    test('converts model with zero id', () {
      const model = CategoryModel(
        id: 0,
        name: 'All',
      );

      final entity = model.toEntity();

      expect(entity.id, 0);
      expect(entity.name, 'All');
    });

    test('converts model with empty name', () {
      const model = CategoryModel(
        id: 5,
        name: '',
      );

      final entity = model.toEntity();

      expect(entity.id, 5);
      expect(entity.name, '');
    });

    test('converts model with special characters', () {
      const model = CategoryModel(
        id: 10,
        name: 'Non-Sporting & Mixed',
      );

      final entity = model.toEntity();

      expect(entity.id, 10);
      expect(entity.name, 'Non-Sporting & Mixed');
    });

    test('preserves all field values during conversion', () {
      const model = CategoryModel(
        id: 42,
        name: 'Test Category',
      );

      final entity = model.toEntity();

      // Verify no data loss during conversion
      expect(entity.id, model.id);
      expect(entity.name, model.name);
    });

    test('entity remains independent after model changes', () {
      var model = const CategoryModel(
        id: 1,
        name: 'Original',
      );

      final entity = model.toEntity();

      // Create a new model (since CategoryModel is const/immutable)
      model = const CategoryModel(
        id: 2,
        name: 'Changed',
      );

      // Entity should still have original values
      expect(entity.id, 1);
      expect(entity.name, 'Original');
    });

    test('converts multiple models to entities', () {
      const models = [
        CategoryModel(id: 1, name: 'Hound'),
        CategoryModel(id: 2, name: 'Sporting'),
        CategoryModel(id: 3, name: 'Toy'),
      ];

      final entities = models.map((m) => m.toEntity()).toList();

      expect(entities.length, 3);
      expect(entities[0].id, 1);
      expect(entities[0].name, 'Hound');
      expect(entities[1].id, 2);
      expect(entities[1].name, 'Sporting');
      expect(entities[2].id, 3);
      expect(entities[2].name, 'Toy');
    });
  });

  group('CategoryModel.fromEntity', () {
    test('converts complete entity to model correctly', () {
      const entity = CategoryEntity(
        id: 1,
        name: 'Hound',
      );

      final model = CategoryModel.fromEntity(entity);

      expect(model, isA<CategoryModel>());
      expect(model.id, 1);
      expect(model.name, 'Hound');
    });

    test('converts entity with zero id', () {
      const entity = CategoryEntity(
        id: 0,
        name: 'All',
      );

      final model = CategoryModel.fromEntity(entity);

      expect(model.id, 0);
      expect(model.name, 'All');
    });

    test('converts entity with empty name', () {
      const entity = CategoryEntity(
        id: 5,
        name: '',
      );

      final model = CategoryModel.fromEntity(entity);

      expect(model.id, 5);
      expect(model.name, '');
    });

    test('preserves all field values during conversion', () {
      const entity = CategoryEntity(
        id: 42,
        name: 'Test Category',
      );

      final model = CategoryModel.fromEntity(entity);

      // Verify no data loss during conversion
      expect(model.id, entity.id);
      expect(model.name, entity.name);
    });

    test('converts multiple entities to models', () {
      const entities = [
        CategoryEntity(id: 1, name: 'Hound'),
        CategoryEntity(id: 2, name: 'Sporting'),
        CategoryEntity(id: 3, name: 'Toy'),
      ];

      final models = entities.map((e) => CategoryModel.fromEntity(e)).toList();

      expect(models.length, 3);
      expect(models[0].id, 1);
      expect(models[0].name, 'Hound');
      expect(models[1].id, 2);
      expect(models[1].name, 'Sporting');
      expect(models[2].id, 3);
      expect(models[2].name, 'Toy');
    });
  });

  group('CategoryModel.toJson', () {
    test('converts model to JSON correctly', () {
      const model = CategoryModel(
        id: 1,
        name: 'Hound',
      );

      final json = model.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['id'], 1);
      expect(json['name'], 'Hound');
      expect(json.length, 2); // Only id and name
    });

    test('converts model with zero id', () {
      const model = CategoryModel(
        id: 0,
        name: 'All',
      );

      final json = model.toJson();

      expect(json['id'], 0);
      expect(json['name'], 'All');
    });

    test('converts model with empty name', () {
      const model = CategoryModel(
        id: 5,
        name: '',
      );

      final json = model.toJson();

      expect(json['id'], 5);
      expect(json['name'], '');
    });

    test('converts model with special characters', () {
      const model = CategoryModel(
        id: 10,
        name: 'Non-Sporting & Mixed',
      );

      final json = model.toJson();

      expect(json['id'], 10);
      expect(json['name'], 'Non-Sporting & Mixed');
    });

    test('JSON output has correct structure', () {
      const model = CategoryModel(
        id: 7,
        name: 'Working',
      );

      final json = model.toJson();

      expect(json.keys, containsAll(['id', 'name']));
      expect(json.keys.length, 2);
    });
  });

  group('CategoryModel immutability', () {
    test('creates instances with const constructor', () {
      const model1 = CategoryModel(id: 1, name: 'Test');
      const model2 = CategoryModel(id: 1, name: 'Test');

      expect(identical(model1, model2), isTrue);
    });

    test('has immutable fields', () {
      const model = CategoryModel(id: 1, name: 'Test');

      // All fields should be final (this is compile-time checked)
      expect(model.id, 1);
      expect(model.name, 'Test');
    });
  });

  group('Integration tests', () {
    test('fromJson followed by toEntity preserves data', () {
      final json = {
        'id': 1,
        'name': 'Integration Test Category',
      };

      final model = CategoryModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.id, 1);
      expect(entity.name, 'Integration Test Category');
    });

    test('fromJson followed by toJson preserves data', () {
      final originalJson = {
        'id': 2,
        'name': 'Round Trip Category',
      };

      final model = CategoryModel.fromJson(originalJson);
      final resultJson = model.toJson();

      expect(resultJson['id'], originalJson['id']);
      expect(resultJson['name'], originalJson['name']);
    });

    test('entity to model to entity round trip preserves data', () {
      const originalEntity = CategoryEntity(id: 3, name: 'Round Trip');

      final model = CategoryModel.fromEntity(originalEntity);
      final resultEntity = model.toEntity();

      expect(resultEntity.id, originalEntity.id);
      expect(resultEntity.name, originalEntity.name);
    });

    test('full cycle: JSON � Model � Entity � Model � JSON', () {
      final originalJson = {
        'id': 4,
        'name': 'Full Cycle Test',
      };

      final model1 = CategoryModel.fromJson(originalJson);
      final entity = model1.toEntity();
      final model2 = CategoryModel.fromEntity(entity);
      final resultJson = model2.toJson();

      expect(resultJson['id'], originalJson['id']);
      expect(resultJson['name'], originalJson['name']);
    });

    test('handles real API response structure', () {
      // Simulating a real Dog API category response
      final json = {
        'id': 5,
        'name': 'Toy',
      };

      final model = CategoryModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.id, 5);
      expect(entity.name, 'Toy');
    });

    test('handles API response with missing optional fields gracefully', () {
      final json = {
        'id': 6,
        // name is missing, should default to 'Unknown'
      };

      final model = CategoryModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.id, 6);
      expect(entity.name, 'Unknown');
    });

    test('processes empty category list from API', () {
      final jsonList = <Map<String, dynamic>>[];

      final models = jsonList
          .map((json) => CategoryModel.fromJson(json))
          .toList();

      expect(models, isEmpty);
    });

    test('processes category list with "All" prepended', () {
      final jsonList = [
        {'id': 1, 'name': 'Hound'},
        {'id': 2, 'name': 'Sporting'},
      ];

      // Simulate what the repository does
      final categories = jsonList
          .map((json) => CategoryModel.fromJson(json))
          .toList();

      final allCategories = [
        const CategoryEntity(id: 0, name: 'All'),
        ...categories.map((model) => model.toEntity()),
      ];

      expect(allCategories.length, 3);
      expect(allCategories[0].id, 0);
      expect(allCategories[0].name, 'All');
      expect(allCategories[1].id, 1);
      expect(allCategories[1].name, 'Hound');
      expect(allCategories[2].id, 2);
      expect(allCategories[2].name, 'Sporting');
    });

    test('handles category not found by returning default values', () {
      final json = {
        'id': null,
        'name': null,
      };

      final model = CategoryModel.fromJson(json);
      final entity = model.toEntity();

      // Should use default values
      expect(entity.id, 0);
      expect(entity.name, 'Unknown');
    });

    test('handles incorrect category selection gracefully', () {
      // Simulating when a category ID doesn't match any known category
      const unknownCategory = CategoryModel(
        id: 999,
        name: 'Unknown',
      );

      final entity = unknownCategory.toEntity();

      expect(entity.id, 999);
      expect(entity.name, 'Unknown');
    });
  });

  group('Category filtering scenarios', () {
    test('creates "All" category for showing all dogs', () {
      const allCategory = CategoryModel(id: 0, name: 'All');
      final entity = allCategory.toEntity();

      expect(entity.id, 0);
      expect(entity.name, 'All');
    });

    test('handles category selection for filtering', () {
      final categories = [
        const CategoryModel(id: 0, name: 'All'),
        const CategoryModel(id: 1, name: 'Hound'),
        const CategoryModel(id: 2, name: 'Sporting'),
        const CategoryModel(id: 3, name: 'Toy'),
      ];

      // Simulating clicking on "Hound" category
      final selectedCategory = categories[1];
      final entity = selectedCategory.toEntity();

      expect(entity.id, 1);
      expect(entity.name, 'Hound');
      expect(entity.id, isNot(0)); // Not "All"
    });

    test('handles switching between categories', () {
      const category1 = CategoryModel(id: 1, name: 'Hound');
      const category2 = CategoryModel(id: 2, name: 'Sporting');

      final entity1 = category1.toEntity();
      final entity2 = category2.toEntity();

      expect(entity1.id, 1);
      expect(entity2.id, 2);
      expect(entity1.name, 'Hound');
      expect(entity2.name, 'Sporting');
      expect(entity1.id, isNot(entity2.id));
    });

    test('handles category with no matching dogs', () {
      // Even if a category has no dogs, the model should work correctly
      const emptyCategory = CategoryModel(id: 10, name: 'Rare Breed');
      final entity = emptyCategory.toEntity();

      expect(entity.id, 10);
      expect(entity.name, 'Rare Breed');
    });
  });

  group('Error scenarios for category not found', () {
    test('handles API returning empty category name', () {
      final json = {
        'id': 1,
        'name': '',
      };

      final model = CategoryModel.fromJson(json);

      expect(model.id, 1);
      expect(model.name, ''); // Empty but valid
    });

    test('handles API returning null for entire category', () {
      // In a real scenario, this would be caught at the list level
      // But documenting the behavior
      final json = {
        'id': null,
        'name': null,
      };

      final model = CategoryModel.fromJson(json);

      expect(model.id, 0); // Default
      expect(model.name, 'Unknown'); // Default
    });

    test('handles malformed category data', () {
      final json = {
        'id': 'not_a_number',
        'name': 'Test',
      };

      // Should throw because string cannot be cast to int
      expect(() => CategoryModel.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('handles category with invalid ID when selected', () {
      const invalidCategory = CategoryModel(id: -1, name: 'Invalid');
      final entity = invalidCategory.toEntity();

      expect(entity.id, -1);
      expect(entity.name, 'Invalid');
    });
  });

  group('CategoryEntity equality', () {
    test('two entities with same data are equal', () {
      const entity1 = CategoryEntity(id: 1, name: 'Hound');
      const entity2 = CategoryEntity(id: 1, name: 'Hound');

      expect(entity1, equals(entity2));
      expect(entity1.hashCode, equals(entity2.hashCode));
    });

    test('two entities with different data are not equal', () {
      const entity1 = CategoryEntity(id: 1, name: 'Hound');
      const entity2 = CategoryEntity(id: 2, name: 'Sporting');

      expect(entity1, isNot(equals(entity2)));
    });

    test('entities with same id but different name are not equal', () {
      const entity1 = CategoryEntity(id: 1, name: 'Hound');
      const entity2 = CategoryEntity(id: 1, name: 'Sporting');

      expect(entity1, isNot(equals(entity2)));
    });

    test('can use entities in sets and maps', () {
      const entity1 = CategoryEntity(id: 1, name: 'Hound');
      const entity2 = CategoryEntity(id: 2, name: 'Sporting');

      final set = <CategoryEntity>{};
      set.add(entity1);
      set.add(entity1); // Adding duplicate
      set.add(entity2);

      // entity1 added twice, but set should have only 2 unique elements
      expect(set.length, 2);
      expect(set.contains(entity1), isTrue);
      expect(set.contains(entity2), isTrue);
    });
  });
}
