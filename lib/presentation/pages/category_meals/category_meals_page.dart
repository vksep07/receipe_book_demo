import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/category_meals/category_meals_bloc.dart';
import '../../blocs/category_meals/category_meals_event.dart';
import '../../blocs/category_meals/category_meals_state.dart';
import '../../widgets/meal_card.dart';
import '../../widgets/loading_shimmer.dart';
import '../../widgets/error_view.dart';
import '../../../core/utils/responsive_layout.dart';
import '../meal_detail/meal_detail_page.dart';

class CategoryMealsPage extends StatelessWidget {
  final String? category;
  final String? ingredient;
  final String? area;

  const CategoryMealsPage({
    super.key,
    this.category,
    this.ingredient,
    this.area,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = CategoryMealsBloc(repository: context.read());
        if (category != null) {
          bloc.add(LoadCategoryMeals(category!));
        } else if (ingredient != null) {
          bloc.add(LoadMealsByIngredient(ingredient!));
        } else if (area != null) {
          bloc.add(LoadMealsByArea(area!));
        }
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(title: Text(_getTitle())),
        body: BlocBuilder<CategoryMealsBloc, CategoryMealsState>(
          builder: (context, state) {
            if (state is CategoryMealsLoading) {
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveLayout.getCrossAxisCount(context),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: 6,
                itemBuilder: (context, index) => const MealCardShimmer(),
              );
            } else if (state is CategoryMealsLoaded) {
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveLayout.getCrossAxisCount(context),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: state.meals.length,
                itemBuilder: (context, index) {
                  final meal = state.meals[index];
                  return MealCard(
                    imageUrl: meal.thumbnail,
                    title: meal.name,
                    subtitle: meal.category ?? meal.area,
                    showOverlay: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MealDetailPage(mealId: meal.id),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is CategoryMealsError) {
              return ErrorView(
                message: state.message,
                onRetry: () {
                  if (category != null) {
                    context.read<CategoryMealsBloc>().add(
                      LoadCategoryMeals(category!),
                    );
                  } else if (ingredient != null) {
                    context.read<CategoryMealsBloc>().add(
                      LoadMealsByIngredient(ingredient!),
                    );
                  } else if (area != null) {
                    context.read<CategoryMealsBloc>().add(
                      LoadMealsByArea(area!),
                    );
                  }
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  String _getTitle() {
    if (category != null) return category!;
    if (ingredient != null) return ingredient!;
    if (area != null) return '$area Cuisine';
    return 'Meals';
  }
}
