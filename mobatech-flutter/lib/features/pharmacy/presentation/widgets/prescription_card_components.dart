import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../models/prescription.dart';

export 'prescription_redeem_button.dart';

class PrescriptionImage extends StatelessWidget {
  final Prescription prescription;
  const PrescriptionImage({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    if (prescription.imageUrl.isEmpty) {
      return const SizedBox.shrink(); // AppSpacing
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
      child: Image.network(
        prescription.imageUrl,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const SizedBox(), // AppSpacing
      ),
    );
  }
}

class PrescriptionNotes extends StatelessWidget {
  final Prescription prescription;
  const PrescriptionNotes({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    if (prescription.notes.isEmpty) {
      return const SizedBox.shrink(); // AppSpacing
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.sm12),
          decoration: BoxDecoration(
            color: AppColors.BACKGROUND_WHITE.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            border: Border.all(
              color: AppColors.PRIMARY_LIGHT.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: AppColors.PRIMARY),
                  SizedBox(width: 6.0), // AppSpacing
                  Text(
                    CoreStrings.extCatatan,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppTypography.md,
                      color: AppColors.TEXT_DARK,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6.0), // AppSpacing
              Text(
                prescription.notes,
                style: const TextStyle(
                  color: AppColors.TEXT_DARK,
                  fontSize: AppTypography.md,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
