import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/meal_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MealRepository repository;

  SearchBloc({required this.repository}) : super(SearchInitial()) {
    on<SearchMeals>(_onSearchMeals);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onSearchMeals(
    SearchMeals event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.length < 3) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    try {
      final result = await repository.searchByName(event.query);

      result.fold((failure) => emit(SearchError(failure.message)), (meals) {
        if (meals.isEmpty) {
          emit(SearchEmpty());
        } else {
          emit(SearchLoaded(meals));
        }
      });
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchInitial());
  }
}
