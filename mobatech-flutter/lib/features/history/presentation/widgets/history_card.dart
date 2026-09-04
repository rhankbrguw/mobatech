import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_status_chip.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

import 'package:mobatech_app/core/theme/app_typography.dart';

class HistoryCard extends StatelessWidget {
  final String title;
  final String status;
  final String date;
  final VoidCallback onTap;

  const HistoryCard({
    super.key,
    required this.title,
    required this.status,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.TRANSPARENT,
      margin: EdgeInsets.zero, // AppSpacing
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: AppColors.PRIMARY_LIGHT.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
                border: Border.all(
                  color: AppColors.PRIMARY.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm12),
                    decoration: BoxDecoration(
                      color: AppColors.BACKGROUND_WHITE,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.SHADOW_COLOR,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.history, color: AppColors.PRIMARY),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppTypography.md15,
                            color: AppColors.TEXT_DARK,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          date,
                          style: const TextStyle(
                            color: AppColors.TEXT_GREY,
                            fontSize: AppTypography.sm13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GlassStatusChip(status: status, fontSize: AppTypography.xs11),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
