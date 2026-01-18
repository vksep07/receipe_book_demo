import '../../core/error/failures.dart';
import '../../core/utils/either.dart';
import '../../domain/repositories/meal_repository.dart';
import '../datasources/meal_remote_datasource.dart';
import '../models/meal_model.dart';
import '../models/category_model.dart';
import '../models/area_model.dart';

class MealRepositoryImpl implements MealRepository {
  final MealRemoteDataSource remoteDataSource;

  MealRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MealModel>>> getRandomMeals({
    int count = 6,
  }) async {
    try {
      final meals = await remoteDataSource.getRandomMeals(count: count);
      return Either.right(meals);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Either.right(categories);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MealModel>> getMealById(String id) async {
    try {
      final meal = await remoteDataSource.getMealById(id);
      return Either.right(meal);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MealModel>>> filterByCategory(
    String category,
  ) async {
    try {
      final meals = await remoteDataSource.filterByCategory(category);
      return Either.right(meals);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MealModel>>> filterByIngredient(
    String ingredient,
  ) async {
    try {
      final meals = await remoteDataSource.filterByIngredient(ingredient);
      return Either.right(meals);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MealModel>>> searchByName(String name) async {
    try {
      final meals = await remoteDataSource.searchByName(name);
      return Either.right(meals);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AreaModel>>> getAreas() async {
    try {
      final areas = await remoteDataSource.getAreas();
      return Either.right(areas);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MealModel>>> filterByArea(String area) async {
    try {
      final meals = await remoteDataSource.filterByArea(area);
      return Either.right(meals);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }
}
