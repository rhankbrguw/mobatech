import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class AppointmentCardMiddleSection extends StatelessWidget {
  final dynamic appointment;

  const AppointmentCardMiddleSection({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  appointment.doctor?.name ?? 'Dokter Tidak Diketahui',
                  style: const TextStyle(
                    color: AppColors.TEXT_DARK,
                    fontSize: AppTypography.lg,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  appointment.doctor?.specialization ?? '-',
                  style: const TextStyle(
                    color: AppColors.PRIMARY,
                    fontSize: AppTypography.sm13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (appointment.notes != null &&
                    (appointment.notes?.isNotEmpty ?? false)) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      const Icon(
                        Icons.notes,
                        size: 14,
                        color: AppColors.TEXT_GREY,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          appointment.notes ?? '',
                          style: const TextStyle(
                            fontSize: AppTypography.sm,
                            color: AppColors.TEXT_GREY,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
