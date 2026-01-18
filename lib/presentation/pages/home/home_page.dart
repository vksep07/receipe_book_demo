import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../blocs/home/home_bloc.dart';
import '../../blocs/home/home_event.dart';
import '../../blocs/home/home_state.dart';
import '../../widgets/meal_card.dart';
import '../../widgets/category_card.dart';
import '../../widgets/section_title.dart';
import '../../widgets/loading_shimmer.dart';
import '../../widgets/error_view.dart';
import '../../widgets/animations.dart';
import '../../../core/utils/responsive_layout.dart';
import '../meal_detail/meal_detail_page.dart';
import '../category_meals/category_meals_page.dart';
import '../search/search_page.dart';
import '../../../common/constants/app_strings.dart';
import '../../../common/constants/app_dimensions.dart';
import '../../../common/widgets/app_spacing.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const int _categoryRows = 3;
  static const double _categoryGridHeight = 350.0;
  static const double _carouselHeight = 200.0;
  static const double _todaysChoiceHeight = 200.0;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadHomeData() {
    context.read<HomeBloc>().add(LoadHomeData());
  }

  void _refreshHomeData() {
    context.read<HomeBloc>().add(RefreshHomeData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) => _buildBody(state),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(AppStrings.appName),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _navigateToSearch,
        ),
      ],
    );
  }

  void _navigateToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SearchPage()),
    );
  }

  Widget _buildBody(HomeState state) {
    return switch (state) {
      HomeLoading() => _buildLoadingState(),
      HomeLoaded() => _buildLoadedState(state),
      HomeError() => _buildErrorState(state),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: _carouselHeight, child: MealCardShimmer()),
          const VSpace.base(),
          _buildCategoryLoadingShimmer(),
        ],
      ),
    );
  }

  Widget _buildCategoryLoadingShimmer() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder:
            (context, index) => const Padding(
              padding: EdgeInsets.all(AppDimensions.paddingSm),
              child: LoadingShimmer(width: 100, height: 120),
            ),
      ),
    );
  }

  Widget _buildErrorState(HomeError state) {
    return ErrorView(message: state.message, onRetry: _loadHomeData);
  }

  Widget _buildLoadedState(HomeLoaded state) {
    return RefreshIndicator(
      onRefresh: () async => _refreshHomeData(),
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFeaturedSection(state),
            const VSpace.xl(),
            _buildCategoriesSection(state),
            const VSpace.xl(),
            if (state.todaysChoice != null) ...[
              _buildTodaysChoiceSection(state),
              const VSpace.xl(),
            ],
            _buildCuisinesSection(state),
            const VSpace.xl(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedSection(HomeLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: AppStrings.featuredRecipes),
        _buildFeaturedCarousel(state.randomMeals),
      ],
    );
  }

  Widget _buildFeaturedCarousel(List meals) {
    return FadeInAnimation(
      child: CarouselSlider.builder(
        itemCount: meals.length,
        options: _getCarouselOptions(),
        itemBuilder: (context, index, _) => _buildCarouselItem(meals[index]),
      ),
    );
  }

  CarouselOptions _getCarouselOptions() {
    return CarouselOptions(
      height: _carouselHeight,
      viewportFraction: ResponsiveLayout.isMobile(context) ? 0.85 : 0.5,
      enlargeCenterPage: true,
      autoPlay: true,
      autoPlayInterval: const Duration(seconds: 5),
      autoPlayAnimationDuration: const Duration(milliseconds: 800),
      autoPlayCurve: Curves.fastOutSlowIn,
    );
  }

  Widget _buildCarouselItem(dynamic meal) {
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

  Widget _buildCategoriesSection(HomeLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: AppStrings.categories),
        _buildCategoriesGrid(state.categories),
      ],
    );
  }

  Widget _buildCategoriesGrid(List categories) {
    final isWeb =
        ResponsiveLayout.isDesktop(context) ||
        ResponsiveLayout.isTablet(context);

    if (isWeb) {
      final crossAxisCount = ResponsiveLayout.isDesktop(context) ? 6 : 4;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.padding),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppDimensions.spaceSm,
            mainAxisSpacing: AppDimensions.spaceSm,
            childAspectRatio: 0.9,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryCard(
              imageUrl: category.thumbnail,
              title: category.name,
              onTap: () => _navigateToCategory(category.name),
            );
          },
        ),
      );
    }

    // Mobile horizontal scrolling
    final itemsPerRow = (categories.length / _categoryRows).ceil();

    return SizedBox(
      height: _categoryGridHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMd,
        ),
        children: List.generate(
          itemsPerRow,
          (columnIndex) =>
              _buildCategoryColumn(categories, columnIndex, itemsPerRow),
        ),
      ),
    );
  }

  Widget _buildCategoryColumn(
    List categories,
    int columnIndex,
    int itemsPerRow,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        _categoryRows,
        (rowIndex) =>
            _buildCategoryItem(categories, columnIndex, rowIndex, itemsPerRow),
      ),
    );
  }

  Widget _buildCategoryItem(
    List categories,
    int columnIndex,
    int rowIndex,
    int itemsPerRow,
  ) {
    final index = columnIndex + (rowIndex * itemsPerRow);

    if (index >= categories.length) {
      return const SizedBox(height: 100);
    }

    final category = categories[index];
    return CategoryCard(
      imageUrl: category.thumbnail,
      title: category.name,
      onTap: () => _navigateToCategory(category.name),
    );
  }

  void _navigateToCategory(String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryMealsPage(category: categoryName),
      ),
    );
  }

  Widget _buildTodaysChoiceSection(HomeLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: AppStrings.todaysChoice),
        _buildTodaysChoiceCard(state.todaysChoice!),
      ],
    );
  }

  Widget _buildTodaysChoiceCard(dynamic meal) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.padding),
      child: GestureDetector(
        onTap: () => _navigateToMealDetail(meal.id),
        child: Container(
          height: _todaysChoiceHeight,
          decoration: _buildTodaysChoiceDecoration(),
          child: MealCard(
            imageUrl: meal.thumbnail,
            title: meal.name,
            subtitle: meal.area ?? meal.category,
            showOverlay: true,
            onTap: () => _navigateToMealDetail(meal.id),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildTodaysChoiceDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(AppDimensions.radius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildCuisinesSection(HomeLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: AppStrings.exploreCuisines),
        _buildCuisinesGrid(state.areas),
      ],
    );
  }

  Widget _buildCuisinesGrid(List areas) {
    return SlideInAnimation(
      delay: const Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.padding),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveLayout.getCrossAxisCount(context),
            crossAxisSpacing: AppDimensions.spaceMd,
            mainAxisSpacing: AppDimensions.spaceMd,
            childAspectRatio: 1.2,
          ),
          itemCount: areas.length,
          itemBuilder:
              (context, index) => _buildCuisineItem(areas[index], index),
        ),
      ),
    );
  }

  Widget _buildCuisineItem(dynamic area, int index) {
    return ScaleInAnimation(
      delay: Duration(milliseconds: 50 * index),
      child: GestureDetector(
        onTap: () => _navigateToArea(area.name),
        child: Container(
          decoration: _buildCuisineDecoration(),
          child: Center(
            child: Text(
              area.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildCuisineDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor.withOpacity(0.7),
        ],
      ),
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  void _navigateToArea(String areaName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CategoryMealsPage(area: areaName)),
    );
  }
}
