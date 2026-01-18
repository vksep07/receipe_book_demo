import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../../blocs/search/search_bloc.dart';
import '../../blocs/search/search_event.dart';
import '../../blocs/search/search_state.dart';
import '../../widgets/meal_card.dart';
import '../../widgets/loading_shimmer.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_view.dart';
import '../../../core/utils/responsive_layout.dart';
import '../meal_detail/meal_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<SearchBloc>().add(SearchMeals(query));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Recipes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search for recipes (min 3 characters)...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            context.read<SearchBloc>().add(ClearSearch());
                          },
                        )
                        : null,
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchInitial) {
                  return const EmptyState(
                    message: 'Start typing to search for recipes',
                    icon: Icons.restaurant_menu,
                  );
                } else if (state is SearchLoading) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveLayout.getCrossAxisCount(
                        context,
                      ),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) => const MealCardShimmer(),
                  );
                } else if (state is SearchLoaded) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveLayout.getCrossAxisCount(
                        context,
                      ),
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
                        subtitle: meal.category,
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
                } else if (state is SearchEmpty) {
                  return const EmptyState(
                    message: 'No recipes found. Try a different search term.',
                  );
                } else if (state is SearchError) {
                  return ErrorView(
                    message: state.message,
                    onRetry: () {
                      if (_searchController.text.isNotEmpty) {
                        context.read<SearchBloc>().add(
                          SearchMeals(_searchController.text),
                        );
                      }
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
