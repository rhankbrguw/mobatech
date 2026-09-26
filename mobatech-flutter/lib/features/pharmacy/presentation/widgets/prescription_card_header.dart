part of 'prescription_card.dart';

class PrescriptionCardHeader extends ConsumerWidget {
  final Prescription prescription;

  const PrescriptionCardHeader({super.key, required this.prescription});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Text(
          '${PharmacyStrings.prescriptionPrefix}${prescription.id}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppTypography.lg,
            color: AppColors.TEXT_DARK,
          ),
        ),
        const Spacer(),
        _buildStatusBadge(),
        const SizedBox(width: AppSpacing.sm),
        _buildDeleteButton(context, ref),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return GlassStatusChip(
      status: prescription.status,
      fontSize: AppTypography.sm,
    );
  }

  Widget _buildDeleteButton(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _confirmDelete(context, ref),
      child: const Icon(
        Icons.delete_outline,
        color: AppColors.ERROR_RED,
        size: 24,
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(PharmacyStrings.extHapuseresep),
        content: const Text(
          PharmacyStrings.extApakahandayakininginmenghapuseresepini,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              CoreStrings.extBatal,
              style: TextStyle(color: AppColors.TEXT_GREY),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              CoreStrings.extHapus,
              style: TextStyle(color: AppColors.ERROR_RED),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) {
      if (!context.mounted) return;
      _deletePrescription(context, ref);
    }
  }

  Future<void> _deletePrescription(BuildContext context, WidgetRef ref) async {
    try {
      await ref
          .read(prescriptionRepositoryProvider)
          .deletePrescription(prescription.id);
      ref.invalidate(prescriptionsProvider);
      if (!context.mounted) return;
      CustomSnackbar.showSuccess(
        context,
        PharmacyStrings.extEresepberhasildihapus,
      );
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackbar.showError(context, ErrorStrings.extGagalmenghapuseresep);
    }
  }
}
