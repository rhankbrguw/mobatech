import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class ScheduleDetailsCard extends StatelessWidget {
  final dynamic appointment;

  const ScheduleDetailsCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md20),
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_WHITE,
        borderRadius: BorderRadius.circular(AppSpacing.md20),
        boxShadow: [
          BoxShadow(
            color: AppColors.SHADOW_COLOR.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jadwal Konsultasi',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppTypography.lg,
              color: AppColors.TEXT_DARK,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Icon(
                Icons.calendar_month,
                color: AppColors.PRIMARY,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm12),
              Text(
                appointment.schedule?.date != null
                    ? Formatters.formatDateWithDayID(
                        (appointment.schedule?.date ?? DateTime.now()),
                      )
                    : '-',
                style: const TextStyle(color: AppColors.TEXT_DARK),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm12),
          Row(
            children: [
              const Icon(Icons.access_time, color: AppColors.PRIMARY, size: 20),
              const SizedBox(width: AppSpacing.sm12),
              Text(
                '${appointment.schedule?.startTime ?? ''} - ${appointment.schedule?.endTime ?? ''}',
                style: const TextStyle(color: AppColors.TEXT_DARK),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.note_alt_outlined,
                color: AppColors.PRIMARY,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm12),
              Expanded(
                child: Text(
                  appointment.notes ?? '-',
                  style: const TextStyle(color: AppColors.TEXT_DARK),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
