import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/meal_model.dart';
import '../models/category_model.dart';
import '../models/area_model.dart';

abstract class MealRemoteDataSource {
  Future<List<MealModel>> getRandomMeals({int count = 6});
  Future<List<CategoryModel>> getCategories();
  Future<MealModel> getMealById(String id);
  Future<List<MealModel>> filterByCategory(String category);
  Future<List<MealModel>> filterByIngredient(String ingredient);
  Future<List<MealModel>> searchByName(String name);
  Future<List<AreaModel>> getAreas();
  Future<List<MealModel>> filterByArea(String area);
}

class MealRemoteDataSourceImpl implements MealRemoteDataSource {
  final http.Client client;

  MealRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MealModel>> getRandomMeals({int count = 6}) async {
    final List<MealModel> meals = [];

    for (int i = 0; i < count; i++) {
      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.randomMeal}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null && data['meals'].isNotEmpty) {
          meals.add(MealModel.fromJson(data['meals'][0]));
        }
      } else {
        throw Exception('Failed to load random meal');
      }
    }

    return meals;
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.categories}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['categories'] != null) {
        return (data['categories'] as List)
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      }
      return [];
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Future<MealModel> getMealById(String id) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.mealById}?i=$id'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] != null && data['meals'].isNotEmpty) {
        return MealModel.fromJson(data['meals'][0]);
      }
      throw Exception('Meal not found');
    } else {
      throw Exception('Failed to load meal');
    }
  }

  @override
  Future<List<MealModel>> filterByCategory(String category) async {
    final response = await client.get(
      Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.filterByCategory}?c=$category',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] != null) {
        return (data['meals'] as List)
            .map((json) => MealModel.fromJson(json))
            .toList();
      }
      return [];
    } else {
      throw Exception('Failed to filter meals by category');
    }
  }

  @override
  Future<List<MealModel>> filterByIngredient(String ingredient) async {
    final response = await client.get(
      Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.filterByIngredient}?i=$ingredient',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] != null) {
        return (data['meals'] as List)
            .map((json) => MealModel.fromJson(json))
            .toList();
      }
      return [];
    } else {
      throw Exception('Failed to filter meals by ingredient');
    }
  }

  @override
  Future<List<MealModel>> searchByName(String name) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.searchByName}?s=$name'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] != null) {
        return (data['meals'] as List)
            .map((json) => MealModel.fromJson(json))
            .toList();
      }
      return [];
    } else {
      throw Exception('Failed to search meals');
    }
  }

  @override
  Future<List<AreaModel>> getAreas() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.listAreas}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] != null) {
        return (data['meals'] as List)
            .map((json) => AreaModel.fromJson(json))
            .toList();
      }
      return [];
    } else {
      throw Exception('Failed to load areas');
    }
  }

  @override
  Future<List<MealModel>> filterByArea(String area) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.filterByArea}?a=$area'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] != null) {
        return (data['meals'] as List)
            .map((json) => MealModel.fromJson(json))
            .toList();
      }
      return [];
    } else {
      throw Exception('Failed to filter meals by area');
    }
  }
}
