import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/meal_repository.dart';
import 'meal_detail_event.dart';
import 'meal_detail_state.dart';

class MealDetailBloc extends Bloc<MealDetailEvent, MealDetailState> {
  final MealRepository repository;

  MealDetailBloc({required this.repository}) : super(MealDetailInitial()) {
    on<LoadMealDetail>(_onLoadMealDetail);
  }

  Future<void> _onLoadMealDetail(
    LoadMealDetail event,
    Emitter<MealDetailState> emit,
  ) async {
    emit(MealDetailLoading());

    try {
      final result = await repository.getMealById(event.mealId);

      result.fold(
        (failure) => emit(MealDetailError(failure.message)),
        (meal) => emit(MealDetailLoaded(meal)),
      );
    } catch (e) {
      emit(MealDetailError(e.toString()));
    }
  }
}
