import 'package:equatable/equatable.dart';

abstract class MealDetailEvent extends Equatable {
  const MealDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadMealDetail extends MealDetailEvent {
  final String mealId;

  const LoadMealDetail(this.mealId);

  @override
  List<Object> get props => [mealId];
}
