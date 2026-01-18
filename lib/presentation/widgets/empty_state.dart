import 'package:flutter/material.dart';
import '../../common/constants/app_dimensions.dart';
import '../../common/widgets/app_text.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyState({
    super.key,
    required this.message,
    this.icon = Icons.search_off,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[400]),
          const SizedBox(height: AppDimensions.padding),
          AppTextSubtitle(
            message,
            textAlign: TextAlign.center,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }
}
