import '../../core/error/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/meal_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/area_model.dart';

abstract class MealRepository {
  Future<Either<Failure, List<MealModel>>> getRandomMeals({int count = 6});
  Future<Either<Failure, List<CategoryModel>>> getCategories();
  Future<Either<Failure, MealModel>> getMealById(String id);
  Future<Either<Failure, List<MealModel>>> filterByCategory(String category);
  Future<Either<Failure, List<MealModel>>> filterByIngredient(
    String ingredient,
  );
  Future<Either<Failure, List<MealModel>>> searchByName(String name);
  Future<Either<Failure, List<AreaModel>>> getAreas();
  Future<Either<Failure, List<MealModel>>> filterByArea(String area);
}
