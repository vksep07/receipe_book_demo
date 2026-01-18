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
import '../../../common/widgets/app_text_field.dart';
import '../../../common/constants/app_strings.dart';
import '../../../common/constants/app_dimensions.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const Duration _debounceDelay = Duration(milliseconds: 500);
  static const int _loadingItemCount = 6;

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _cancelPreviousDebounce();
    _debounce = Timer(_debounceDelay, () => _searchMeals(query));
  }

  void _cancelPreviousDebounce() {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
  }

  void _searchMeals(String query) {
    context.read<SearchBloc>().add(SearchMeals(query));
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<SearchBloc>().add(ClearSearch());
  }

  void _retrySearch() {
    if (_searchController.text.isNotEmpty) {
      _searchMeals(_searchController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.searchTitle)),
      body: Column(
        children: [
          _buildSearchField(),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) => _buildSearchResults(state),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.padding),
      child: AppTextField(
        controller: _searchController,
        hintText: AppStrings.searchHint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon:
            _searchController.text.isNotEmpty
                ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                )
                : null,
        onChanged: _onSearchChanged,
      ),
    );
  }

  Widget _buildSearchResults(SearchState state) {
    return switch (state) {
      SearchInitial() => _buildInitialState(),
      SearchLoading() => _buildLoadingState(),
      SearchLoaded() => _buildLoadedState(state),
      SearchEmpty() => _buildEmptyState(),
      SearchError() => _buildErrorState(state),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildInitialState() {
    return const EmptyState(
      message: AppStrings.searchPlaceholder,
      icon: Icons.restaurant_menu,
    );
  }

  Widget _buildLoadingState() {
    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.padding),
      gridDelegate: _buildGridDelegate(),
      itemCount: _loadingItemCount,
      itemBuilder: (_, __) => const MealCardShimmer(),
    );
  }

  Widget _buildLoadedState(SearchLoaded state) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.padding),
      gridDelegate: _buildGridDelegate(),
      itemCount: state.meals.length,
      itemBuilder: (context, index) => _buildMealCard(state.meals[index]),
    );
  }

  Widget _buildEmptyState() {
    return const EmptyState(message: AppStrings.noResultsFound);
  }

  Widget _buildErrorState(SearchError state) {
    return ErrorView(message: state.message, onRetry: _retrySearch);
  }

  SliverGridDelegate _buildGridDelegate() {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: ResponsiveLayout.getCrossAxisCount(context),
      crossAxisSpacing: AppDimensions.spaceMd,
      mainAxisSpacing: AppDimensions.spaceMd,
      childAspectRatio: 0.75,
    );
  }

  Widget _buildMealCard(dynamic meal) {
    return MealCard(
      imageUrl: meal.thumbnail,
      title: meal.name,
      subtitle: meal.category,
      showOverlay: true,
      onTap: () => _navigateToMealDetail(meal.id),
    );
  }

  void _navigateToMealDetail(String mealId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MealDetailPage(mealId: mealId)),
    );
  }
}
