import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/strings/appointment_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/polyclinic.dart';
import '../../providers/appointment_provider.dart';

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
              borderRadius: BorderRadius.circular(10),
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

class PolyclinicExpandedContent extends StatelessWidget {
  final Polyclinic poly;
  final WidgetRef ref;

  const PolyclinicExpandedContent({
    super.key,
    required this.poly,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.PRIMARY_LIGHT.withValues(alpha: 0.5),
      padding: const EdgeInsets.all(AppSpacing.md20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppointmentStrings.extJadwalpraktik,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.TEXT_DARK,
              fontSize: AppTypography.md,
            ),
          ),
          const SizedBox(height: AppSpacing.sm12),
          if (poly.schedules.isEmpty)
            const Text(
              AppointmentStrings.extJadwalbelumtersedia,
              style: TextStyle(
                color: AppColors.TEXT_GREY,
                fontSize: AppTypography.sm13,
              ),
            )
          else
            ...poly.schedules.map(
              (s) => PolyclinicScheduleItem(schedule: s),
            ),
          const SizedBox(height: AppSpacing.md20),
          _buildActionButton(context),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          ref.read(selectedPolyclinicIdProvider.notifier).state = poly.id;
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.PRIMARY,
          foregroundColor: AppColors.BACKGROUND_WHITE,
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search, size: 18),
            SizedBox(width: AppSpacing.sm),
            Text(
              AppointmentStrings.extLihatdokterdipoliini,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
