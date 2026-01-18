import 'package:equatable/equatable.dart';

class MealModel extends Equatable {
  final String id;
  final String name;
  final String? category;
  final String? area;
  final String? instructions;
  final String thumbnail;
  final String? tags;
  final String? youtube;
  final Map<String, String> ingredients;
  final Map<String, String> measures;

  const MealModel({
    required this.id,
    required this.name,
    this.category,
    this.area,
    this.instructions,
    required this.thumbnail,
    this.tags,
    this.youtube,
    this.ingredients = const {},
    this.measures = const {},
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    final Map<String, String> ingredients = {};
    final Map<String, String> measures = {};

    // Parse ingredients and measures
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null &&
          ingredient.toString().trim().isNotEmpty &&
          ingredient.toString().trim() != 'null') {
        ingredients['ingredient$i'] = ingredient.toString().trim();
        measures['measure$i'] = measure?.toString().trim() ?? '';
      }
    }

    return MealModel(
      id: json['idMeal']?.toString() ?? '',
      name: json['strMeal']?.toString() ?? '',
      category: json['strCategory']?.toString(),
      area: json['strArea']?.toString(),
      instructions: json['strInstructions']?.toString(),
      thumbnail: json['strMealThumb']?.toString() ?? '',
      tags: json['strTags']?.toString(),
      youtube: json['strYoutube']?.toString(),
      ingredients: ingredients,
      measures: measures,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': name,
      'strCategory': category,
      'strArea': area,
      'strInstructions': instructions,
      'strMealThumb': thumbnail,
      'strTags': tags,
      'strYoutube': youtube,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    area,
    instructions,
    thumbnail,
    tags,
    youtube,
    ingredients,
    measures,
  ];
}
