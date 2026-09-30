import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../models/prescription.dart';

class PrescriptionItemsList extends StatelessWidget {
  final Prescription prescription;
  const PrescriptionItemsList({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    if (prescription.items.isEmpty) {
      return const SizedBox.shrink(); // AppSpacing
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.sm12),
        const Text(
          'Daftar Obat Resep',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppTypography.md,
            color: AppColors.TEXT_DARK,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm12),
          decoration: BoxDecoration(
            color: AppColors.BACKGROUND_WHITE,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            border: Border.all(
              color: AppColors.DIVIDER_GREY.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            children: [
              for (var i = 0; i < prescription.items.length; i++) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6.0), // AppSpacing
                      decoration: BoxDecoration(
                        color: AppColors.PRIMARY_LIGHT.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.borderRadiusSm,
                        ),
                      ),
                      child: const Icon(
                        Icons.medication,
                        size: 16,
                        color: AppColors.PRIMARY,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prescription.items[i].displayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: AppTypography.md,
                              color: AppColors.TEXT_DARK,
                            ),
                          ),
                          const SizedBox(height: 2.0), // AppSpacing
                          Text(
                            '${prescription.items[i].dosageInstruction} • ${prescription.items[i].duration}',
                            style: const TextStyle(
                              fontSize: AppTypography.sm,
                              color: AppColors.TEXT_GREY,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.BACKGROUND_SCREEN,
                        borderRadius: BorderRadius.circular(6.0), // AppSpacing
                      ),
                      child: Text(
                        '${prescription.items[i].quantity}x',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppTypography.sm,
                          color: AppColors.TEXT_DARK,
                        ),
                      ),
                    ),
                  ],
                ),
                if (i < prescription.items.length - 1)
                  const Divider(height: 16, color: AppColors.DIVIDER_GREY),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
