import 'package:flutter/material.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_status_chip.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

import 'package:mobatech_app/core/theme/app_typography.dart';

class AppointmentCardTopSection extends StatelessWidget {
  final dynamic appointment;

  const AppointmentCardTopSection({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm12,
      ),
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_SCREEN.withValues(alpha: 0.5),
        border: const Border(
          bottom: BorderSide(color: AppColors.BACKGROUND_SCREEN),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_month,
                size: 16,
                color: AppColors.PRIMARY,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${appointment.schedule?.date != null ? Formatters.formatDateID((appointment.schedule?.date ?? DateTime.now())) : '-'} • ${appointment.schedule?.startTime ?? ''}',
                style: const TextStyle(
                  fontSize: AppTypography.sm13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.TEXT_DARK,
                ),
              ),
            ],
          ),
          GlassStatusChip(
            status: appointment.status,
            fontSize: AppTypography.xs11,
          ),
        ],
      ),
    );
  }
}

class AppointmentCardBottomSection extends StatelessWidget {
  final dynamic appointment;
  final VoidCallback onCancel;

  const AppointmentCardBottomSection({
    super.key,
    required this.appointment,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    if (appointment.status != 'pending' && appointment.status != 'approved') {
      return const SizedBox.shrink(); // AppSpacing
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: SizedBox(
        // AppSpacing
        width: double.infinity,
        child: OutlinedButton(
          onPressed: onCancel,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.ERROR_RED,
            side: BorderSide(color: AppColors.ERROR_RED.withValues(alpha: 0.3)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            ),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm12),
          ),
          child: const Text(
            'Batalkan Janji Temu',
            style: TextStyle(
              fontSize: AppTypography.sm13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
