import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/glass_status_chip.dart';
import '../../../appointment/data/models/appointment.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class AgendaScheduleInfo extends StatelessWidget {
  final Appointment appointment;
  const AgendaScheduleInfo({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 10,
      ),
      decoration: const BoxDecoration(
        color: AppColors.AGENDA_BACKGROUND,
        borderRadius: BorderRadius.only(
          // AppSpacing
          bottomLeft: Radius.circular(AppSpacing.borderRadiusLg),
          bottomRight: Radius.circular(AppSpacing.borderRadiusLg),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appointment.schedule?.date != null
                ? '${Formatters.formatDateWithDayID((appointment.schedule?.date ?? DateTime.now()))} • ${(appointment.schedule?.startTime ?? '')}'
                : 'Jadwal belum ditentukan',
            style: const TextStyle(
              fontSize: AppTypography.sm13,
              fontWeight: FontWeight.bold,
              color: AppColors.TEXT_DARK,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Text(
                'Status Pendaftaran',
                style: TextStyle(
                  fontSize: AppTypography.sm,
                  color: AppColors.TEXT_GREY,
                ),
              ),
              const SizedBox(width: 10), // AppSpacing
              GlassStatusChip(
                status: appointment.status,
                fontSize: AppTypography.xs,
                padding: const EdgeInsets.symmetric(
                  // AppSpacing
                  horizontal: 10,
                  vertical: AppSpacing.xs,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
