import 'package:equatable/equatable.dart';
import '../../../data/models/meal_model.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/area_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<MealModel> randomMeals;
  final List<CategoryModel> categories;
  final MealModel? todaysChoice;
  final List<AreaModel> areas;

  const HomeLoaded({
    required this.randomMeals,
    required this.categories,
    this.todaysChoice,
    required this.areas,
  });

  @override
  List<Object> get props => [randomMeals, categories, areas];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
