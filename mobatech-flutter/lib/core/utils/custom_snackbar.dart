import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class CustomSnackbar {
  static void showSuccess(BuildContext context, String message) {
    _showSnackbar(context, message, AppColors.SUCCESS_GREEN);
  }

  static void showError(BuildContext context, String message) {
    _showSnackbar(context, message, AppColors.ERROR_RED);
  }

  static void showInfo(BuildContext context, String message) {
    _showSnackbar(context, message, AppColors.TEXT_DARK);
  }

  static void showWarning(BuildContext context, String message) {
    _showSnackbar(context, message, AppColors.WARNING_ORANGE);
  }

  static void _showSnackbar(
    BuildContext context,
    String message,
    Color backgroundColor,
  ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: AppColors.TEXT_WHITE,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(AppSpacing.md),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
