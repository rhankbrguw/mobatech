import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class AppointmentDoctorCard extends StatelessWidget {
  final dynamic appointment;

  const AppointmentDoctorCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14), // AppSpacing
            child:
                appointment.doctor?.imageUrl != null &&
                    (appointment.doctor?.imageUrl?.isNotEmpty ?? false)
                ? Image.network(
                    (appointment.doctor?.imageUrl ?? '')
                        .replaceAll('/svg', '/png')
                        .replaceAll('.svg', '.png'),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      width: 60,
                      height: 60,
                      color: AppColors.PRIMARY_LIGHT,
                      child: const Icon(Icons.person, color: AppColors.PRIMARY),
                    ),
                  )
                : Container(
                    width: 60,
                    height: 60,
                    color: AppColors.PRIMARY_LIGHT,
                    child: const Icon(Icons.person, color: AppColors.PRIMARY),
                  ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.doctor?.name ?? 'Dokter',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppTypography.lg,
                    color: AppColors.TEXT_DARK,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    // AppSpacing
                    horizontal: 10,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.PRIMARY_LIGHT,
                    borderRadius: BorderRadius.circular(
                      AppSpacing.borderRadiusMd,
                    ),
                  ),
                  child: Text(
                    appointment.doctor?.specialization ?? '-',
                    style: const TextStyle(
                      fontSize: AppTypography.sm,
                      color: AppColors.PRIMARY,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
