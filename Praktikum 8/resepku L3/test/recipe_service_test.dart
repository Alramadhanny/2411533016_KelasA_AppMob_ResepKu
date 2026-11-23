import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:resepku/models/recipe.dart';
import 'package:resepku/services/recipe_service.dart';

void main() {
  group('Recipe.fromJson', () {
    test('membaca rating int sebagai double dan memberi nilai bawaan', () {
      final json = <String, dynamic>{
        'id': 1,
        'name': 'Nasi Goreng',
        'rating': 5, // int, bukan double
      };

      final recipe = Recipe.fromJson(json);

      expect(recipe.id, 1);
      expect(recipe.name, 'Nasi Goreng');
      expect(recipe.rating, 5.0);
      expect(recipe.rating, isA<double>());
      expect(recipe.cuisine, '-');
      expect(recipe.difficulty, '-');
      expect(recipe.prepTimeMinutes, 0);
      expect(recipe.cookTimeMinutes, 0);
      expect(recipe.servings, 1);
      expect(recipe.caloriesPerServing, 0);
      expect(recipe.image, '');
      expect(recipe.ingredients, isEmpty);
      expect(recipe.instructions, isEmpty);
    });
  });

  group('RecipeService.fetchRecipes', () {
    test('mengembalikan List<Recipe> dari respons palsu (status 200)', () async {
      final mockClient = MockClient((request) async {
        final fakeResponse = {
          'recipes': [
            {
              'id': 10,
              'name': 'Rendang',
              'cuisine': 'Indonesian',
              'difficulty': 'Hard',
              'prepTimeMinutes': 30,
              'cookTimeMinutes': 180,
              'servings': 4,
              'caloriesPerServing': 450,
              'rating': 4.9,
              'image': 'https://example.com/rendang.jpg',
              'ingredients': ['Daging sapi', 'Santan'],
              'instructions': ['Masak daging dengan santan hingga kering.'],
            },
          ],
          'total': 1,
          'skip': 0,
          'limit': 50,
        };
        return http.Response(jsonEncode(fakeResponse), 200);
      });

      final service = RecipeService(client: mockClient);
      final recipes = await service.fetchRecipes();

      expect(recipes, hasLength(1));
      expect(recipes.first.id, 10);
      expect(recipes.first.name, 'Rendang');
      expect(recipes.first.rating, 4.9);
      service.close();
    });

    test('melempar RecipeServiceException jika status 404', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final service = RecipeService(client: mockClient);

      expect(
        () => service.fetchRecipes(),
        throwsA(isA<RecipeServiceException>()),
      );
      service.close();
    });
  });
}