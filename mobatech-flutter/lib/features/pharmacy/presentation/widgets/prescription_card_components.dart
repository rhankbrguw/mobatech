import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../models/prescription.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';
import 'package:mobatech_app/core/constants/strings/pharmacy_strings.dart';



class PrescriptionRedeemButton extends StatelessWidget {
  final Prescription prescription;
  const PrescriptionRedeemButton({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    if (prescription.status != 'Pending') return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            CustomSnackbar.showSuccess(
              context,
              PharmacyStrings.addedToCartMessage,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm12),
          ),
          child: const Text(
            'Tebus Obat',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        prescription.imageUrl,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const SizedBox(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(
          CoreStrings.extCatatan,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          prescription.notes,
          style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
        ),
      ],
    );
  }
}
