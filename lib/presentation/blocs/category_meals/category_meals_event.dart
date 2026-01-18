import 'package:equatable/equatable.dart';

abstract class CategoryMealsEvent extends Equatable {
  const CategoryMealsEvent();

  @override
  List<Object> get props => [];
}

class LoadCategoryMeals extends CategoryMealsEvent {
  final String category;

  const LoadCategoryMeals(this.category);

  @override
  List<Object> get props => [category];
}

class LoadMealsByIngredient extends CategoryMealsEvent {
  final String ingredient;

  const LoadMealsByIngredient(this.ingredient);

  @override
  List<Object> get props => [ingredient];
}

class LoadMealsByArea extends CategoryMealsEvent {
  final String area;

  const LoadMealsByArea(this.area);

  @override
  List<Object> get props => [area];
}
