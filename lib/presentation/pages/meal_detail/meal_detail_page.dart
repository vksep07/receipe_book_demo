import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../blocs/meal_detail/meal_detail_bloc.dart';
import '../../blocs/meal_detail/meal_detail_event.dart';
import '../../blocs/meal_detail/meal_detail_state.dart';
import '../../widgets/loading_shimmer.dart';
import '../../widgets/error_view.dart';
import '../category_meals/category_meals_page.dart';
import '../../../common/constants/app_strings.dart';
import '../../../common/constants/app_dimensions.dart';
import '../../../common/widgets/app_text.dart';
import '../../../common/widgets/app_spacing.dart';

class MealDetailPage extends StatelessWidget {
  static const double _appBarExpandedHeight = 300.0;
  static const double _stepNumberSize = 32.0;
  static const double _iconSize = 20.0;

  final String mealId;

  const MealDetailPage({super.key, required this.mealId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              MealDetailBloc(repository: context.read())
                ..add(LoadMealDetail(mealId)),
      child: Scaffold(
        body: BlocBuilder<MealDetailBloc, MealDetailState>(
          builder: (context, state) => _buildBody(context, state),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, MealDetailState state) {
    return switch (state) {
      MealDetailLoading() => _buildLoadingState(),
      MealDetailLoaded() => _buildLoadedState(context, state),
      MealDetailError() => _buildErrorState(context, state),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildLoadingState() {
    return const CustomScrollView(
      slivers: [
        SliverAppBar(expandedHeight: _appBarExpandedHeight, pinned: true),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.padding),
            child: Column(
              children: [
                LoadingShimmer(height: 30, width: 200),
                VSpace.base(),
                LoadingShimmer(height: 200),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, MealDetailError state) {
    return ErrorView(
      message: state.message,
      onRetry: () => _retryLoadMeal(context),
    );
  }

  void _retryLoadMeal(BuildContext context) {
    context.read<MealDetailBloc>().add(LoadMealDetail(mealId));
  }

  Widget _buildLoadedState(BuildContext context, MealDetailLoaded state) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(state.meal),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMealTags(context, state.meal),
                const VSpace.xl(),
                _buildIngredientsSection(context, state.meal),
                const VSpace.xl(),
                _buildInstructionsSection(context, state.meal),
                const VSpace.xl(),
                if (state.meal.youtube != null) _buildYouTubeButton(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(dynamic meal) {
    return SliverAppBar(
      expandedHeight: _appBarExpandedHeight,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          meal.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 3.0,
                color: Colors.black,
              ),
            ],
          ),
        ),
        background: _buildHeroImage(meal),
      ),
    );
  }

  Widget _buildHeroImage(dynamic meal) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: 'meal_${meal.name}',
          child: CachedNetworkImage(
            imageUrl: meal.thumbnail,
            fit: BoxFit.cover,
          ),
        ),
        _buildImageGradient(),
      ],
    );
  }

  Widget _buildImageGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
        ),
      ),
    );
  }

  Widget _buildMealTags(BuildContext context, dynamic meal) {
    return Wrap(
      spacing: AppDimensions.spaceSm,
      children: [
        if (meal.category != null) _buildCategoryChip(meal.category!),
        if (meal.area != null) _buildAreaChip(meal.area!),
      ],
    );
  }

  Widget _buildCategoryChip(String category) {
    return Chip(
      label: Text(category),
      avatar: const Icon(Icons.category, size: AppDimensions.iconSm),
    );
  }

  Widget _buildAreaChip(String area) {
    return Chip(
      label: Text(area),
      avatar: const Icon(Icons.public, size: AppDimensions.iconSm),
    );
  }

  Widget _buildIngredientsSection(BuildContext context, dynamic meal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextHeading(AppStrings.ingredients),
        const VSpace.md(),
        ...meal.ingredients.entries.map(
          (entry) => _buildIngredientItem(
            context,
            entry.value,
            meal.measures[entry.key] ?? '',
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientItem(
    BuildContext context,
    String ingredient,
    String measure,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
      child: InkWell(
        onTap: () => _navigateToIngredientMeals(context, ingredient),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          decoration: _buildIngredientDecoration(context),
          child: Row(
            children: [
              const Icon(Icons.check_circle_outline, size: _iconSize),
              const HSpace.md(),
              Expanded(
                child: Text(
                  ingredient,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Text(measure, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildIngredientDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      border: Border.all(color: Theme.of(context).dividerColor),
    );
  }

  void _navigateToIngredientMeals(BuildContext context, String ingredient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryMealsPage(ingredient: ingredient),
      ),
    );
  }

  Widget _buildInstructionsSection(BuildContext context, dynamic meal) {
    if (meal.instructions == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextHeading(AppStrings.instructions),
        const VSpace.md(),
        ..._parseInstructions(meal.instructions!).asMap().entries.map(
          (entry) => _buildInstructionStep(context, entry.key + 1, entry.value),
        ),
      ],
    );
  }

  List<String> _parseInstructions(String instructions) {
    return instructions
        .split('\n')
        .where((step) => step.trim().isNotEmpty)
        .toList();
  }

  Widget _buildInstructionStep(
    BuildContext context,
    int stepNumber,
    String stepText,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.padding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepNumber(context, stepNumber),
          const HSpace.md(),
          Expanded(
            child: Text(
              stepText.trim(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepNumber(BuildContext context, int number) {
    return Container(
      width: _stepNumberSize,
      height: _stepNumberSize,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$number',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildYouTubeButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: Implement YouTube video opening using url_launcher
        },
        icon: const Icon(Icons.play_circle_outline),
        label: const Text(AppStrings.watchVideo),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXl,
            vertical: AppDimensions.paddingMd,
          ),
        ),
      ),
    );
  }
}
