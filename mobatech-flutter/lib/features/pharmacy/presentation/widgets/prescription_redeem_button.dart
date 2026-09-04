import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobatech_app/core/constants/strings/pharmacy_strings.dart';
import 'package:mobatech_app/core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';
import 'package:mobatech_app/core/theme/app_typography.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../models/prescription.dart';
import '../../providers/prescription_provider.dart';

class PrescriptionRedeemButton extends ConsumerStatefulWidget {
  final Prescription prescription;
  const PrescriptionRedeemButton({super.key, required this.prescription});

  @override
  ConsumerState<PrescriptionRedeemButton> createState() =>
      _PrescriptionRedeemButtonState();
}

class _PrescriptionRedeemButtonState
    extends ConsumerState<PrescriptionRedeemButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (widget.prescription.status.toLowerCase() != 'active') {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isLoading ? null : () => _handleRedeem(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.PRIMARY,
            foregroundColor: AppColors.TEXT_WHITE,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.TEXT_WHITE,
                  ),
                )
              : const Text(
                  'Tebus Obat',
                  style: TextStyle(
                    fontSize: AppTypography.md,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _handleRedeem(BuildContext context) async {
    setState(() => _isLoading = true);
    final success = await ref
        .read(prescriptionsProvider.notifier)
        .redeemPrescription(widget.prescription.id);
    if (!context.mounted) return;
    setState(() => _isLoading = false);
    if (success) {
      CustomSnackbar.showSuccess(
        context,
        PharmacyStrings.redeemRequestSent,
      );
    } else {
      CustomSnackbar.showError(
        context,
        PharmacyStrings.redeemFailed,
      );
    }
  }
}
