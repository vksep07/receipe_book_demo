import 'package:flutter/material.dart';
import '../../common/constants/app_strings.dart';
import '../../common/constants/app_dimensions.dart';
import '../../common/widgets/app_text.dart';
import '../../common/widgets/app_spacing.dart';
import '../pages/category_meals/category_meals_page.dart';

class ExpandableIngredients extends StatefulWidget {
  final Map<String, String> ingredients;
  final Map<String, String> measures;
  final int initialCount;

  const ExpandableIngredients({
    super.key,
    required this.ingredients,
    required this.measures,
    this.initialCount = 5,
  });

  @override
  State<ExpandableIngredients> createState() => _ExpandableIngredientsState();
}

class _ExpandableIngredientsState extends State<ExpandableIngredients> {
  static const double _measureFontSize = 11.0;
  static const double _measureVerticalPadding = 2.0;
  static const double _chipOpacity = 0.15;
  static const double _badgeOpacity = 0.1;

  bool _isExpanded = false;

  List<MapEntry<String, String>> get _ingredientsList =>
      widget.ingredients.entries.toList();

  int get _totalCount => _ingredientsList.length;

  bool get _shouldShowToggle => _totalCount > widget.initialCount;

  int get _displayCount => _isExpanded ? _totalCount : widget.initialCount;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const VSpace.md(),
        _buildChipsGrid(context),
        if (_shouldShowToggle) ...[
          const VSpace.sm(),
          _buildToggleButton(context),
        ],
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppTextHeading(AppStrings.ingredients),
        if (_shouldShowToggle) _buildIngredientBadge(context),
      ],
    );
  }

  Widget _buildIngredientBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSm,
        vertical: AppDimensions.paddingXs,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(_badgeOpacity),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
      ),
      child: Text(
        '$_totalCount Ingredients',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildChipsGrid(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.spaceSm,
      runSpacing: AppDimensions.spaceSm,
      children:
          _getVisibleIngredients().map((entry) {
            final measure = widget.measures[entry.key] ?? '';
            return _buildIngredientChip(context, entry.value, measure);
          }).toList(),
    );
  }

  List<MapEntry<String, String>> _getVisibleIngredients() {
    return _ingredientsList.take(_displayCount).toList();
  }

  Widget _buildIngredientChip(
    BuildContext context,
    String ingredient,
    String measure,
  ) {
    return ActionChip(
      avatar: _buildChipIcon(context),
      label: _buildChipLabel(context, ingredient, measure),
      onPressed: () => _navigateToIngredientMeals(context, ingredient),
      backgroundColor: Theme.of(context).cardColor,
      side: BorderSide(color: Theme.of(context).dividerColor),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSm,
        vertical: AppDimensions.paddingXs,
      ),
    );
  }

  Widget _buildChipIcon(BuildContext context) {
    return Icon(
      Icons.check_circle,
      size: AppDimensions.iconSm,
      color: Theme.of(context).primaryColor,
    );
  }

  Widget _buildChipLabel(
    BuildContext context,
    String ingredient,
    String measure,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIngredientText(context, ingredient),
        if (measure.isNotEmpty) ...[
          const SizedBox(width: AppDimensions.spaceXs),
          _buildMeasureBadge(context, measure),
        ],
      ],
    );
  }

  Widget _buildIngredientText(BuildContext context, String ingredient) {
    return Text(
      ingredient,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
    );
  }

  Widget _buildMeasureBadge(BuildContext context, String measure) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXs,
        vertical: _measureVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(_chipOpacity),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
      ),
      child: Text(
        measure,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: _measureFontSize,
        ),
      ),
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

  Widget _buildToggleButton(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: _toggleExpansion,
        icon: _buildToggleIcon(),
        label: Text(
          _getToggleButtonText(),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLg,
            vertical: AppDimensions.paddingMd,
          ),
        ),
      ),
    );
  }

  Widget _buildToggleIcon() {
    return Icon(
      _isExpanded ? Icons.expand_less : Icons.expand_more,
      size: AppDimensions.icon,
    );
  }

  String _getToggleButtonText() {
    if (_isExpanded) {
      return AppStrings.showLess;
    }
    final remainingCount = _totalCount - widget.initialCount;
    return '${AppStrings.showMore} ($remainingCount more)';
  }
}
