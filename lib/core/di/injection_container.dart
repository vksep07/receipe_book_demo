import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/meal_remote_datasource.dart';
import '../../data/repositories/meal_repository_impl.dart';
import '../../domain/repositories/meal_repository.dart';
import '../../presentation/blocs/home/home_bloc.dart';
import '../../presentation/blocs/search/search_bloc.dart';
import '../../presentation/blocs/meal_detail/meal_detail_bloc.dart';
import '../../presentation/blocs/category_meals/category_meals_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(() => HomeBloc(repository: sl()));
  sl.registerFactory(() => SearchBloc(repository: sl()));
  sl.registerFactory(() => MealDetailBloc(repository: sl()));
  sl.registerFactory(() => CategoryMealsBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<MealRepository>(
    () => MealRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<MealRemoteDataSource>(
    () => MealRemoteDataSourceImpl(client: sl()),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
}
