import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/polyclinic.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

import 'package:mobatech_app/core/theme/app_typography.dart';

class PolyclinicScheduleItem extends StatelessWidget {
  final PolyclinicSchedule schedule;

  const PolyclinicScheduleItem({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.BACKGROUND_WHITE,
              borderRadius: BorderRadius.circular(10), // AppSpacing
            ),
            child: const Icon(
              Icons.schedule,
              color: AppColors.PRIMARY,
              size: 16,
            ),
          ),
          const SizedBox(width: AppSpacing.sm12),
          Expanded(
            child: Text(
              schedule.dayOfWeek,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.TEXT_DARK,
                fontSize: AppTypography.sm13,
              ),
            ),
          ),
          Text(
            '${schedule.startTime} - ${schedule.endTime}',
            style: const TextStyle(
              color: AppColors.TEXT_DARK,
              fontWeight: FontWeight.w600,
              fontSize: AppTypography.sm13,
            ),
          ),
        ],
      ),
    );
  }
}
