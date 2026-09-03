import 'package:flutter/material.dart';
import 'package:mobatech_app/core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

enum AppButtonVariant { primary, secondary, danger, ghost, outline }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final Widget? icon;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color bgColor;
    Color fgColor;
    Color borderColor = AppColors.TRANSPARENT;

    switch (variant) {
      case AppButtonVariant.primary:
        bgColor = AppColors.PRIMARY_GREEN;
        fgColor = AppColors.BACKGROUND_WHITE;
        break;
      case AppButtonVariant.secondary:
        bgColor = isDark
            ? AppColors.BACKGROUND_WHITE.withValues(alpha: 0.1)
            : AppColors.BACKGROUND_WHITE.withValues(alpha: 0.5);
        fgColor = AppColors.getTextPrimary(isDark);
        borderColor = AppColors.getGlassBorder(isDark);
        break;
      case AppButtonVariant.danger:
        bgColor = AppColors.ERROR_RED.withValues(alpha: 0.1);
        fgColor = AppColors.ERROR_RED;
        borderColor = AppColors.ERROR_RED.withValues(alpha: 0.2);
        break;
      case AppButtonVariant.ghost:
        bgColor = AppColors.TRANSPARENT;
        fgColor = AppColors.getTextPrimary(isDark).withValues(alpha: 0.8);
        break;
      case AppButtonVariant.outline:
        bgColor = AppColors.TRANSPARENT;
        fgColor = AppColors.PRIMARY_GREEN;
        borderColor = AppColors.PRIMARY_GREEN.withValues(alpha: 0.5);
        break;
    }

    double height;
    TextStyle textStyle;
    EdgeInsets padding;

    switch (size) {
      case AppButtonSize.small:
        height = 32;
        textStyle = theme.textTheme.labelSmall ?? const TextStyle(fontSize: 12);
        padding = const EdgeInsets.symmetric(horizontal: AppSpacing.sm12);
        break;
      case AppButtonSize.medium:
        height = 44;
        textStyle =
            theme.textTheme.labelMedium ?? const TextStyle(fontSize: 14);
        padding = const EdgeInsets.symmetric(horizontal: AppSpacing.md);
        break;
      case AppButtonSize.large:
        height = 56;
        textStyle = theme.textTheme.labelLarge ?? const TextStyle(fontSize: 16);
        padding = const EdgeInsets.symmetric(horizontal: AppSpacing.lg);
        break;
    }

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      elevation: variant == AppButtonVariant.primary ? 2 : 0,
      shadowColor: variant == AppButtonVariant.primary
          ? AppColors.PRIMARY_GREEN.withValues(alpha: 0.4)
          : AppColors.TRANSPARENT,
      padding: padding,
      minimumSize: Size(isFullWidth ? double.infinity : 0, height),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor),
      ),
    );

    final Widget content = isLoading
        ? SizedBox(
            width: textStyle.fontSize ?? 14,
            height: textStyle.fontSize ?? 14,
            child: CircularProgressIndicator(strokeWidth: 2, color: fgColor),
          )
        : Row(
            mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                IconTheme(
                  data: IconThemeData(
                    color: fgColor,
                    size: (textStyle.fontSize ?? 14) + 4,
                  ),
                  child: icon ?? const SizedBox(),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: textStyle.copyWith(
                  color: fgColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: content,
    );
  }
}
