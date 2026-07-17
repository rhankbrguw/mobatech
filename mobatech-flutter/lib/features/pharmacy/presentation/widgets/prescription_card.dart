import 'dart:ui';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:mobatech_app/core/constants/strings/error_strings.dart';
import 'package:mobatech_app/core/constants/strings/pharmacy_strings.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/glass_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../models/prescription.dart';
import '../../providers/pharmacy_provider.dart';
import 'prescription_items_list.dart';
import 'prescription_card_components.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

part 'prescription_card_header.dart';

class PrescriptionCard extends ConsumerWidget {
  final Prescription prescription;
  const PrescriptionCard({super.key, required this.prescription});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.backgroundWhite.withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textDark.withValues(alpha: 0.08),
                  blurRadius: 20,
                  spreadRadius: -2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrescriptionCardHeader(prescription: prescription),
            if (prescription.doctorName.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person, size: 14, color: AppColors.textGrey),
                  const SizedBox(width: 4),
                  Text(
                    'Dr. ${prescription.doctorName}',
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (prescription.diagnosis.isNotEmpty)
                Text(
                  ' ${prescription.diagnosis}',
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 12,
                  ),
                ),
            ],
            const SizedBox(height: 8),
            _buildDate(),
            const Divider(height: 24, color: AppColors.dividerGrey),
            if (prescription.items.isNotEmpty) PrescriptionItemsList(prescription: prescription),
            if (prescription.imageUrl.isNotEmpty) PrescriptionImage(prescription: prescription),
            if (prescription.notes.isNotEmpty) PrescriptionNotes(prescription: prescription),
            PrescriptionRedeemButton(prescription: prescription),
          ],
        ),
      ),
    ),
  ),
);
  }

  Widget _buildDate() => Text(
    '${CoreStrings.extTanggal} ${Formatters.formatDateID(prescription.createdAt.toLocal())}',
    style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
  );
}
