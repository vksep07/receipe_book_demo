import 'package:equatable/equatable.dart';
import '../../../data/models/meal_model.dart';

abstract class CategoryMealsState extends Equatable {
  const CategoryMealsState();

  @override
  List<Object> get props => [];
}

class CategoryMealsInitial extends CategoryMealsState {}

class CategoryMealsLoading extends CategoryMealsState {}

class CategoryMealsLoaded extends CategoryMealsState {
  final List<MealModel> meals;
  final String title;

  const CategoryMealsLoaded({required this.meals, required this.title});

  @override
  List<Object> get props => [meals, title];
}

class CategoryMealsError extends CategoryMealsState {
  final String message;

  const CategoryMealsError(this.message);

  @override
  List<Object> get props => [message];
}
