import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

import 'package:mobatech_app/core/theme/app_typography.dart';

class QuickAccessItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback? onTap;

  const QuickAccessItem({
    super.key,
    required this.icon,
    required this.label,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm12),
            decoration: BoxDecoration(
              color: AppColors.BACKGROUND_WHITE,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
              boxShadow: [
                BoxShadow(
                  color: AppColors.SHADOW_COLOR,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 6.0), // AppSpacing
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: AppTypography.xs11,
              fontWeight: FontWeight.bold,
              color: AppColors.TEXT_DARK,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
