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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadHomeData());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Book'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchPage()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return _buildLoadingState();
          } else if (state is HomeLoaded) {
            return _buildLoadedState(state);
          } else if (state is HomeError) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                context.read<HomeBloc>().add(LoadHomeData());
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 200, child: MealCardShimmer()),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder:
                  (context, index) => const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: LoadingShimmer(width: 100, height: 120),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(HomeLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(RefreshHomeData());
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Random Meals Carousel
            const SectionTitle(title: 'Featured Recipes'),
            _buildFeaturedCarousel(state),
            const SizedBox(height: 24),

            // Categories Section
            const SectionTitle(title: 'Categories'),
            _buildCategoriesSection(state),
            const SizedBox(height: 24),

            // Today's Choice
            if (state.todaysChoice != null) ...[
              const SectionTitle(title: "Today's Choice"),
              _buildTodaysChoice(state),
              const SizedBox(height: 24),
            ],

            // Cuisines Section
            const SectionTitle(title: 'Explore Cuisines'),
            _buildCuisinesSection(state),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCarousel(HomeLoaded state) {
    return FadeInAnimation(
      child: CarouselSlider.builder(
        itemCount: state.randomMeals.length,
        options: CarouselOptions(
          height: 200,
          viewportFraction: ResponsiveLayout.isMobile(context) ? 0.85 : 0.5,
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
        ),
        itemBuilder: (context, index, realIndex) {
          final meal = state.randomMeals[index];
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
      ),
    );
  }

  Widget _buildCategoriesSection(HomeLoaded state) {
    // Split categories into 3 rows
    final categories = state.categories;
    final itemsPerRow = (categories.length / 3).ceil();

    return SizedBox(
      height: 350,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: List.generate(itemsPerRow, (columnIndex) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (rowIndex) {
              final index = columnIndex + (rowIndex * itemsPerRow);
              if (index >= categories.length) {
                return const SizedBox(height: 100);
              }
              final category = categories[index];
              return CategoryCard(
                imageUrl: category.thumbnail,
                title: category.name,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => CategoryMealsPage(category: category.name),
                    ),
                  );
                },
              );
            }),
          );
        }),
      ),
    );
  }

  Widget _buildTodaysChoice(HomeLoaded state) {
    final meal = state.todaysChoice!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MealDetailPage(mealId: meal.id)),
          );
        },
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: MealCard(
            imageUrl: meal.thumbnail,
            title: meal.name,
            subtitle: meal.area ?? meal.category,
            showOverlay: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MealDetailPage(mealId: meal.id),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCuisinesSection(HomeLoaded state) {
    return SlideInAnimation(
      delay: const Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveLayout.getCrossAxisCount(context),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: state.areas.length,
          itemBuilder: (context, index) {
            final area = state.areas[index];
            return ScaleInAnimation(
              delay: Duration(milliseconds: 50 * index),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryMealsPage(area: area.name),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
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
          },
        ),
      ),
    );
  }
}
