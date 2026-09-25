import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class TrackingTopBar extends StatelessWidget {
  const TrackingTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        // AppSpacing
        AppSpacing.md20,
        MediaQuery.of(context).padding.top + 12,
        20,
        16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.TEXT_DARK.withAlpha(160), AppColors.TRANSPARENT],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.BACKGROUND_WHITE.withAlpha(50),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            ),
            child: const Icon(
              Icons.emergency,
              color: AppColors.BACKGROUND_WHITE,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.sm12),
          const Expanded(
            child: Text(
              CoreStrings.ambulanceTracking,
              style: TextStyle(
                color: AppColors.BACKGROUND_WHITE,
                fontSize: AppTypography.lg,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: AppColors.SUCCESS_GREEN,
              borderRadius: BorderRadius.circular(AppSpacing.md20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, color: AppColors.BACKGROUND_WHITE, size: 8),
                SizedBox(width: 6.0), // AppSpacing
                Text(
                  CoreStrings.live,
                  style: TextStyle(
                    color: AppColors.BACKGROUND_WHITE,
                    fontSize: AppTypography.xs11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
