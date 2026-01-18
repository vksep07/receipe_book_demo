import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../blocs/meal_detail/meal_detail_bloc.dart';
import '../../blocs/meal_detail/meal_detail_event.dart';
import '../../blocs/meal_detail/meal_detail_state.dart';
import '../../widgets/loading_shimmer.dart';
import '../../widgets/error_view.dart';
import '../category_meals/category_meals_page.dart';

class MealDetailPage extends StatelessWidget {
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
          builder: (context, state) {
            if (state is MealDetailLoading) {
              return _buildLoadingState();
            } else if (state is MealDetailLoaded) {
              return _buildLoadedState(context, state);
            } else if (state is MealDetailError) {
              return ErrorView(
                message: state.message,
                onRetry: () {
                  context.read<MealDetailBloc>().add(LoadMealDetail(mealId));
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const CustomScrollView(
      slivers: [
        SliverAppBar(expandedHeight: 300, pinned: true),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                LoadingShimmer(height: 30, width: 200),
                SizedBox(height: 16),
                LoadingShimmer(height: 200),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadedState(BuildContext context, MealDetailLoaded state) {
    final meal = state.meal;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
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
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: 'meal_${meal.name}',
                  child: CachedNetworkImage(
                    imageUrl: meal.thumbnail,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category and Area Tags
                Wrap(
                  spacing: 8,
                  children: [
                    if (meal.category != null)
                      Chip(
                        label: Text(meal.category!),
                        avatar: const Icon(Icons.category, size: 16),
                      ),
                    if (meal.area != null)
                      Chip(
                        label: Text(meal.area!),
                        avatar: const Icon(Icons.public, size: 16),
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                // Ingredients Section
                Text(
                  'Ingredients',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                ...meal.ingredients.entries.map((entry) {
                  final ingredient = entry.value;
                  final measure = meal.measures[entry.key] ?? '';
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) =>
                                    CategoryMealsPage(ingredient: ingredient),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_outline, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                ingredient,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            Text(
                              measure,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 24),

                // Instructions Section
                Text(
                  'Instructions',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                if (meal.instructions != null)
                  ..._buildInstructions(context, meal.instructions!),
                const SizedBox(height: 24),

                // YouTube Link
                if (meal.youtube != null)
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Open YouTube video
                        // You can use url_launcher package here
                      },
                      icon: const Icon(Icons.play_circle_outline),
                      label: const Text('Watch Video Tutorial'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildInstructions(BuildContext context, String instructions) {
    final steps =
        instructions.split('\n').where((s) => s.trim().isNotEmpty).toList();
    return steps.asMap().entries.map((entry) {
      final index = entry.key;
      final step = entry.value;
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                step.trim(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
