import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../models/prescription.dart';
import '../../providers/prescription_provider.dart';

class PrescriptionRedeemButton extends ConsumerStatefulWidget {
  final Prescription prescription;
  const PrescriptionRedeemButton({super.key, required this.prescription});

  @override
  ConsumerState<PrescriptionRedeemButton> createState() => _PrescriptionRedeemButtonState();
}

class _PrescriptionRedeemButtonState extends ConsumerState<PrescriptionRedeemButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (widget.prescription.status.toLowerCase() != 'active') return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isLoading
              ? null
              : () async {
                  setState(() => _isLoading = true);
                  final success = await ref
                      .read(prescriptionsProvider.notifier)
                      .redeemPrescription(widget.prescription.id);
                  if (!context.mounted) return;
                  setState(() => _isLoading = false);
                  if (success) {
                    CustomSnackbar.showSuccess(
                      context,
                      'Permintaan penebusan obat terkirim ke Apoteker',
                    );
                  } else {
                    CustomSnackbar.showError(
                      context,
                      'Gagal menebus obat. Silakan coba lagi.',
                    );
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textWhite,
            padding: const EdgeInsets.symmetric(vertical: 12),
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
                    color: AppColors.textWhite,
                  ),
                )
              : const Text(
                  'Tebus Obat',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primaryLight.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  const Text(
                    CoreStrings.extCatatan,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                prescription.notes,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 14,
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
