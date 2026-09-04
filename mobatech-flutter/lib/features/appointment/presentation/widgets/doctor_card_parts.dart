import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class DoctorStatusBadge extends StatelessWidget {
  final bool isActive;

  const DoctorStatusBadge({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.PRIMARY.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
        ),
        child: const Text(
          'Available',
          style: TextStyle(
            fontSize: AppTypography.xs,
            color: AppColors.PRIMARY,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.ERROR_RED.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
        ),
        child: const Text(
          'Unavailable',
          style: TextStyle(
            fontSize: AppTypography.xs,
            color: AppColors.ERROR_RED,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }
}
