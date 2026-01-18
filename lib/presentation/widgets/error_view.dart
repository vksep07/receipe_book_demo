import 'package:flutter/material.dart';
import '../../common/constants/app_strings.dart';
import '../../common/constants/app_dimensions.dart';
import '../../common/widgets/app_text.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorView({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppDimensions.padding),
            AppTextTitle(AppStrings.errorOccurred, textAlign: TextAlign.center),
            const SizedBox(height: AppDimensions.paddingSm),
            AppTextBody(message, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: AppDimensions.spaceXl),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text(AppStrings.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
