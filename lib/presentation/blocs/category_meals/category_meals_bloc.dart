import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/meal_repository.dart';
import 'category_meals_event.dart';
import 'category_meals_state.dart';

class CategoryMealsBloc extends Bloc<CategoryMealsEvent, CategoryMealsState> {
  final MealRepository repository;

  CategoryMealsBloc({required this.repository})
    : super(CategoryMealsInitial()) {
    on<LoadCategoryMeals>(_onLoadCategoryMeals);
    on<LoadMealsByIngredient>(_onLoadMealsByIngredient);
    on<LoadMealsByArea>(_onLoadMealsByArea);
  }

  Future<void> _onLoadCategoryMeals(
    LoadCategoryMeals event,
    Emitter<CategoryMealsState> emit,
  ) async {
    emit(CategoryMealsLoading());

    try {
      final result = await repository.filterByCategory(event.category);

      result.fold(
        (failure) => emit(CategoryMealsError(failure.message)),
        (meals) =>
            emit(CategoryMealsLoaded(meals: meals, title: event.category)),
      );
    } catch (e) {
      emit(CategoryMealsError(e.toString()));
    }
  }

  Future<void> _onLoadMealsByIngredient(
    LoadMealsByIngredient event,
    Emitter<CategoryMealsState> emit,
  ) async {
    emit(CategoryMealsLoading());

    try {
      final result = await repository.filterByIngredient(event.ingredient);

      result.fold(
        (failure) => emit(CategoryMealsError(failure.message)),
        (meals) =>
            emit(CategoryMealsLoaded(meals: meals, title: event.ingredient)),
      );
    } catch (e) {
      emit(CategoryMealsError(e.toString()));
    }
  }

  Future<void> _onLoadMealsByArea(
    LoadMealsByArea event,
    Emitter<CategoryMealsState> emit,
  ) async {
    emit(CategoryMealsLoading());

    try {
      final result = await repository.filterByArea(event.area);

      result.fold(
        (failure) => emit(CategoryMealsError(failure.message)),
        (meals) => emit(
          CategoryMealsLoaded(meals: meals, title: '${event.area} Cuisine'),
        ),
      );
    } catch (e) {
      emit(CategoryMealsError(e.toString()));
    }
  }
}
