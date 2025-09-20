import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';

/// Custom button widget with consistent styling
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final Widget? child;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.child,
  });

  const AppButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.child,
  }) : type = AppButtonType.primary;

  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.child,
  }) : type = AppButtonType.secondary;

  const AppButton.outline({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.child,
  }) : type = AppButtonType.outline;

  const AppButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.child,
  }) : type = AppButtonType.text;

  const AppButton.destructive({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.child,
  }) : type = AppButtonType.destructive;

  @override
  Widget build(BuildContext context) {
    final buttonSize = _getButtonSize();
    final textStyle = _getTextStyle();
    final isEnabled = onPressed != null && !isLoading;

    Widget buttonChild = child ?? _buildButtonContent();

    if (isLoading) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getLoadingColor(context),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(text, style: textStyle),
        ],
      );
    }

    switch (type) {
      case AppButtonType.primary:
        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          height: buttonSize.height,
          child: ElevatedButton(
            onPressed: isEnabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.lightOutline,
              disabledForegroundColor: AppColors.lightOnSurfaceVariant,
              padding: buttonSize.padding,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              ),
              elevation: 2,
              textStyle: textStyle,
            ),
            child: buttonChild,
          ),
        );

      case AppButtonType.secondary:
        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          height: buttonSize.height,
          child: ElevatedButton(
            onPressed: isEnabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
              disabledBackgroundColor: AppColors.lightOutline,
              disabledForegroundColor: AppColors.lightOnSurfaceVariant,
              padding: buttonSize.padding,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              ),
              elevation: 1,
              textStyle: textStyle,
            ),
            child: buttonChild,
          ),
        );

      case AppButtonType.outline:
        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          height: buttonSize.height,
          child: OutlinedButton(
            onPressed: isEnabled ? onPressed : null,
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              disabledForegroundColor: AppColors.lightOnSurfaceVariant,
              padding: buttonSize.padding,
              side: BorderSide(
                color: isEnabled
                    ? Theme.of(context).colorScheme.primary
                    : AppColors.lightOutline,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              ),
              textStyle: textStyle,
            ),
            child: buttonChild,
          ),
        );

      case AppButtonType.text:
        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          height: buttonSize.height,
          child: TextButton(
            onPressed: isEnabled ? onPressed : null,
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              disabledForegroundColor: AppColors.lightOnSurfaceVariant,
              padding: buttonSize.padding,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              ),
              textStyle: textStyle,
            ),
            child: buttonChild,
          ),
        );

      case AppButtonType.destructive:
        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          height: buttonSize.height,
          child: ElevatedButton(
            onPressed: isEnabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.lightOutline,
              disabledForegroundColor: AppColors.lightOnSurfaceVariant,
              padding: buttonSize.padding,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              ),
              elevation: 2,
              textStyle: textStyle,
            ),
            child: buttonChild,
          ),
        );
    }
  }

  Widget _buildButtonContent() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _getIconSize()),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }
    return Text(text);
  }

  ButtonSize _getButtonSize() {
    switch (size) {
      case AppButtonSize.small:
        return const ButtonSize(
          height: 32,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        );
      case AppButtonSize.medium:
        return const ButtonSize(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        );
      case AppButtonSize.large:
        return const ButtonSize(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        );
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppButtonSize.small:
        return AppTypography.buttonSmall;
      case AppButtonSize.medium:
        return AppTypography.button;
      case AppButtonSize.large:
        return AppTypography.buttonLarge;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 18;
      case AppButtonSize.large:
        return 20;
    }
  }

  Color _getLoadingColor(BuildContext context) {
    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.destructive:
        return Colors.white;
      case AppButtonType.secondary:
      case AppButtonType.outline:
      case AppButtonType.text:
        return Theme.of(context).colorScheme.primary;
    }
  }
}

enum AppButtonType {
  primary,
  secondary,
  outline,
  text,
  destructive,
}

enum AppButtonSize {
  small,
  medium,
  large,
}

class ButtonSize {
  final double height;
  final EdgeInsetsGeometry padding;

  const ButtonSize({
    required this.height,
    required this.padding,
  });
}

