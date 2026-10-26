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
  final IconData icon;

  const HistoryCard({
    super.key,
    required this.title,
    required this.status,
    required this.date,
    required this.onTap,
    this.icon = Icons.history_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_WHITE,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        border: Border.all(color: AppColors.BORDER_GREY),
        boxShadow: [
          BoxShadow(
            color: AppColors.SHADOW_COLOR,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: AppColors.TRANSPARENT,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                _buildIcon(),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: _buildDetails()),
                const SizedBox(width: AppSpacing.sm),
                GlassStatusChip(status: status, fontSize: AppTypography.xs11),
                const SizedBox(width: AppSpacing.xs),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.TEXT_LIGHT_GREY,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.PRIMARY_LIGHT.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
      ),
      child: Icon(icon, color: AppColors.PRIMARY, size: 22),
    );
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: AppTypography.md15,
            color: AppColors.TEXT_DARK,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            const Icon(
              Icons.access_time_rounded,
              size: 14,
              color: AppColors.TEXT_GREY,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                date,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.TEXT_GREY,
                  fontSize: AppTypography.sm13,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
