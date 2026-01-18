import 'package:flutter/material.dart';
import '../../common/constants/app_strings.dart';
import '../../common/constants/app_dimensions.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const SectionTitle({super.key, required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.padding,
        vertical: AppDimensions.paddingSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: const Text(AppStrings.seeAll),
            ),
        ],
      ),
    );
  }
}
