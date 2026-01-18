import 'package:flutter/material.dart';
import '../constants/app_dimensions.dart';

enum AppButtonType { primary, secondary, outlined, text }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final double height = _getHeight();
    final EdgeInsets padding = _getPadding();

    Widget button;

    switch (type) {
      case AppButtonType.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            padding: padding,
            minimumSize: Size(fullWidth ? double.infinity : 0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
          ),
          child: _buildChild(context, Colors.white),
        );
        break;

      case AppButtonType.secondary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            padding: padding,
            minimumSize: Size(fullWidth ? double.infinity : 0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
          ),
          child: _buildChild(context, Colors.white),
        );
        break;

      case AppButtonType.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            padding: padding,
            minimumSize: Size(fullWidth ? double.infinity : 0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
          child: _buildChild(context, Theme.of(context).primaryColor),
        );
        break;

      case AppButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            padding: padding,
            minimumSize: Size(fullWidth ? double.infinity : 0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
          ),
          child: _buildChild(context, Theme.of(context).primaryColor),
        );
        break;
    }

    return button;
  }

  Widget _buildChild(BuildContext context, Color textColor) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _getIconSize(), color: textColor),
          const SizedBox(width: AppDimensions.spaceSm),
          Text(text, style: TextStyle(color: textColor)),
        ],
      );
    }

    return Text(text, style: TextStyle(color: textColor));
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return AppDimensions.buttonHeightSm;
      case AppButtonSize.medium:
        return AppDimensions.buttonHeight;
      case AppButtonSize.large:
        return AppDimensions.buttonHeightLg;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.padding,
          vertical: AppDimensions.paddingSm,
        );
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingXl,
          vertical: AppDimensions.paddingMd,
        );
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingXxl,
          vertical: AppDimensions.padding,
        );
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return AppDimensions.iconSm;
      case AppButtonSize.medium:
        return AppDimensions.icon;
      case AppButtonSize.large:
        return AppDimensions.iconLg;
    }
  }
}
