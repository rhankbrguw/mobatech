import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/strings/core_strings.dart';
import '../../../../core/constants/strings/error_strings.dart';
import '../../../../core/constants/strings/pharmacy_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../core/widgets/glass_status_chip.dart';
import '../../models/prescription.dart';
import '../../providers/pharmacy_provider.dart';
import 'prescription_card_components.dart';
import 'prescription_items_list.dart';

part 'prescription_card_header.dart';

class PrescriptionCard extends ConsumerWidget {
  final Prescription prescription;
  const PrescriptionCard({super.key, required this.prescription});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_WHITE,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        border: Border.all(color: AppColors.BORDER_GREY),
        boxShadow: [
          BoxShadow(
            color: AppColors.SHADOW_COLOR,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrescriptionCardHeader(prescription: prescription),
          PrescriptionDoctorInfo(prescription: prescription),
          const SizedBox(height: AppSpacing.xs),
          PrescriptionDateView(createdAt: prescription.createdAt),
          const Divider(height: 20, color: AppColors.DIVIDER_GREY),
          if (prescription.items.isNotEmpty)
            PrescriptionItemsList(prescription: prescription),
          if (prescription.imageUrl.isNotEmpty)
            PrescriptionImage(prescription: prescription),
          if (prescription.notes.isNotEmpty)
            PrescriptionNotes(prescription: prescription),
          PrescriptionRedeemButton(prescription: prescription),
        ],
      ),
    );
  }
}
