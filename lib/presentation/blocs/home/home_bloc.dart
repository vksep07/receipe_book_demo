import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/meal_repository.dart';
import '../../../data/models/meal_model.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MealRepository repository;

  HomeBloc({required this.repository}) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      // Fetch all data in parallel
      final results = await Future.wait([
        repository.getRandomMeals(count: 6),
        repository.getCategories(),
        repository.getRandomMeals(count: 1),
        repository.getAreas(),
      ]);

      List<MealModel> randomMeals = [];
      List<dynamic> categories = [];
      MealModel? todaysChoice;
      List<dynamic> areas = [];

      // Process random meals
      results[0].fold(
        (failure) => throw Exception(failure.message),
        (meals) => randomMeals = meals as List<MealModel>,
      );

      // Process categories
      results[1].fold(
        (failure) => throw Exception(failure.message),
        (cats) => categories = cats,
      );

      // Process today's choice
      results[2].fold((failure) => throw Exception(failure.message), (meals) {
        final mealsList = meals as List<MealModel>;
        todaysChoice = mealsList.isNotEmpty ? mealsList[0] : null;
      });

      // Process areas
      results[3].fold(
        (failure) => throw Exception(failure.message),
        (ar) => areas = ar,
      );

      emit(
        HomeLoaded(
          randomMeals: randomMeals,
          categories: categories.cast(),
          todaysChoice: todaysChoice,
          areas: areas.cast(),
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    add(LoadHomeData());
  }
}
