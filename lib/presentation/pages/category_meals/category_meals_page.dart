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
import '../../../common/constants/app_strings.dart';
import '../../../common/constants/app_dimensions.dart';

class CategoryMealsPage extends StatelessWidget {
  static const int _loadingItemCount = 6;

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
      create: (context) => _createBloc(context),
      child: Scaffold(
        appBar: AppBar(title: Text(_getTitle())),
        body: BlocBuilder<CategoryMealsBloc, CategoryMealsState>(
          builder: (context, state) => _buildBody(context, state),
        ),
      ),
    );
  }

  CategoryMealsBloc _createBloc(BuildContext context) {
    final bloc = CategoryMealsBloc(repository: context.read());
    _loadMeals(bloc);
    return bloc;
  }

  void _loadMeals(CategoryMealsBloc bloc) {
    if (category != null) {
      bloc.add(LoadCategoryMeals(category!));
    } else if (ingredient != null) {
      bloc.add(LoadMealsByIngredient(ingredient!));
    } else if (area != null) {
      bloc.add(LoadMealsByArea(area!));
    }
  }

  Widget _buildBody(BuildContext context, CategoryMealsState state) {
    return switch (state) {
      CategoryMealsLoading() => _buildLoadingState(context),
      CategoryMealsLoaded() => _buildLoadedState(context, state),
      CategoryMealsError() => _buildErrorState(context, state),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildLoadingState(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.padding),
      gridDelegate: _buildGridDelegate(context),
      itemCount: _loadingItemCount,
      itemBuilder: (_, __) => const MealCardShimmer(),
    );
  }

  Widget _buildLoadedState(BuildContext context, CategoryMealsLoaded state) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.padding),
      gridDelegate: _buildGridDelegate(context),
      itemCount: state.meals.length,
      itemBuilder:
          (context, index) => _buildMealCard(context, state.meals[index]),
    );
  }

  Widget _buildErrorState(BuildContext context, CategoryMealsError state) {
    return ErrorView(
      message: state.message,
      onRetry: () => _retryLoad(context),
    );
  }

  void _retryLoad(BuildContext context) {
    final bloc = context.read<CategoryMealsBloc>();
    if (category != null) {
      bloc.add(LoadCategoryMeals(category!));
    } else if (ingredient != null) {
      bloc.add(LoadMealsByIngredient(ingredient!));
    } else if (area != null) {
      bloc.add(LoadMealsByArea(area!));
    }
  }

  SliverGridDelegate _buildGridDelegate(BuildContext context) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: ResponsiveLayout.getCrossAxisCount(context),
      crossAxisSpacing: AppDimensions.spaceMd,
      mainAxisSpacing: AppDimensions.spaceMd,
      childAspectRatio: 0.75,
    );
  }

  Widget _buildMealCard(BuildContext context, dynamic meal) {
    return MealCard(
      imageUrl: meal.thumbnail,
      title: meal.name,
      subtitle: meal.category ?? meal.area,
      showOverlay: true,
      onTap: () => _navigateToMealDetail(context, meal.id),
    );
  }

  void _navigateToMealDetail(BuildContext context, String mealId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MealDetailPage(mealId: mealId)),
    );
  }

  String _getTitle() {
    if (category != null) return category!;
    if (ingredient != null) return ingredient!;
    if (area != null) return '$area ${AppStrings.cuisine}';
    return AppStrings.meals;
  }
}
