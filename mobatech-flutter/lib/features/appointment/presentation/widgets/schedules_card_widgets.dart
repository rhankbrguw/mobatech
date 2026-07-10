import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/doctor_schedule.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class ScheduleItemCard extends StatelessWidget {
  final DoctorSchedule schedule;
  final bool isSelected;
  final VoidCallback? onTap;

  const ScheduleItemCard({
    super.key,
    required this.schedule,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isExpired = false;
    if (schedule.date != null && schedule.endTime.isNotEmpty) {
      final now = DateTime.now();
      final localDate = (schedule.date?.toLocal() ?? DateTime.now());
      final timeParts = schedule.endTime.split(':');
      if (timeParts.length >= 2) {
        final endHour = int.tryParse(timeParts[0]) ?? 0;
        final endMinute = int.tryParse(timeParts[1]) ?? 0;
        final scheduleEnd = DateTime(
          localDate.year,
          localDate.month,
          localDate.day,
          endHour,
          endMinute,
        );
        if (now.isAfter(scheduleEnd)) {
          isExpired = true;
        }
      }
    }

    final isAvailable =
        !isExpired &&
        schedule.isAvailable &&
        (schedule.quota - schedule.booked > 0);
    final localDate = schedule.date?.toLocal();
    final dateStr = localDate != null
        ? '${localDate.day}/${localDate.month}/${localDate.year}'
        : '';

    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderGrey,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.backgroundScreen,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_month,
                color: isSelected
                    ? AppColors.backgroundWhite
                    : AppColors.textGrey,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$dateStr • ${schedule.startTime} - ${schedule.endTime}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isAvailable
                          ? AppColors.textDark
                          : AppColors.textGrey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sisa kuota: ${schedule.quota - schedule.booked}',
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (!isAvailable)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.errorRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isExpired ? 'Berakhir' : 'Penuh',
                  style: const TextStyle(
                    color: AppColors.errorRed,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected ? AppColors.primary : AppColors.textLightGrey,
              ),
          ],
        ),
      ),
    );
  }
}
