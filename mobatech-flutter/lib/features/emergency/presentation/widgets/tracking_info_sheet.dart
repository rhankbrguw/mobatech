import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';

import '../../../../core/theme/app_colors.dart';
import 'tracking_info_widgets.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

import 'package:mobatech_app/core/theme/app_typography.dart';

class TrackingInfoSheet extends StatelessWidget {
  final int estimatedMinutes;

  const TrackingInfoSheet({super.key, required this.estimatedMinutes});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_WHITE,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.borderRadiusXl),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.TEXT_DARK.withAlpha(30),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.sm12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.BORDER_GREY,
              borderRadius: BorderRadius.circular(2.0), // AppSpacing
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md20,
              AppSpacing.md20,
              AppSpacing.md20,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                EstimatedTimeCircle(estimatedMinutes: estimatedMinutes),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        CoreStrings.ambulanceHeading,
                        style: TextStyle(
                          fontSize: AppTypography.md15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.TEXT_DARK,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${CoreStrings.estimateArrival}$estimatedMinutes${CoreStrings.minuteText}',
                        style: const TextStyle(
                          fontSize: AppTypography.sm13,
                          color: AppColors.TEXT_GREY,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 24),

          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md20,
              0,
              AppSpacing.md20,
              AppSpacing.sm,
            ),
            child: Row(children: [DriverInfoRow()]),
          ),

          SizedBox(
            height: MediaQuery.of(context).padding.bottom + 16,
          ), // AppSpacing
        ],
      ),
    );
  }
}
