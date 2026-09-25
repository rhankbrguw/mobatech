import 'package:flutter/material.dart';
import '../../../../core/constants/strings/core_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../models/prescription.dart';

export 'prescription_redeem_button.dart';

class PrescriptionDoctorInfo extends StatelessWidget {
  final Prescription prescription;
  const PrescriptionDoctorInfo({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    if (prescription.doctorName.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 14,
                color: AppColors.TEXT_GREY,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Dr. ${prescription.doctorName}',
                style: const TextStyle(
                  color: AppColors.TEXT_DARK,
                  fontSize: AppTypography.sm13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (prescription.diagnosis.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              '${CoreStrings.diagnosisPrefix}${prescription.diagnosis}',
              style: const TextStyle(
                color: AppColors.TEXT_GREY,
                fontSize: AppTypography.sm,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class PrescriptionDateView extends StatelessWidget {
  final DateTime createdAt;
  const PrescriptionDateView({super.key, required this.createdAt});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${CoreStrings.extTanggal} ${Formatters.formatDateID(createdAt.toLocal())}',
      style: const TextStyle(
        color: AppColors.TEXT_GREY,
        fontSize: AppTypography.xs,
      ),
    );
  }
}

class PrescriptionImage extends StatelessWidget {
  final Prescription prescription;
  const PrescriptionImage({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    if (prescription.imageUrl.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
        child: Image.network(
          prescription.imageUrl,
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const SizedBox(),
        ),
      ),
    );
  }
}

class PrescriptionNotes extends StatelessWidget {
  final Prescription prescription;
  const PrescriptionNotes({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    if (prescription.notes.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm12),
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_LIGHT_GREY,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
        border: Border.all(color: AppColors.BORDER_GREY),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, size: 14, color: AppColors.PRIMARY),
              SizedBox(width: 6.0),
              Text(
                CoreStrings.extCatatan,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppTypography.sm,
                  color: AppColors.TEXT_DARK,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Text(
            prescription.notes,
            style: const TextStyle(
              color: AppColors.TEXT_DARK,
              fontSize: AppTypography.sm,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
