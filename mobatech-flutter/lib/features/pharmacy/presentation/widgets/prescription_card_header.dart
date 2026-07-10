part of 'prescription_card.dart';

class PrescriptionCardHeader extends ConsumerWidget {
  final Prescription prescription;

  const PrescriptionCardHeader({super.key, required this.prescription});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Text(
          'Resep #${prescription.id}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textDark,
          ),
        ),
        const Spacer(),
        _buildStatusBadge(),
        const SizedBox(width: 8),
        _buildDeleteButton(context, ref),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return GlassStatusChip(status: prescription.status, fontSize: 12);
  }

  Widget _buildDeleteButton(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _confirmDelete(context, ref),
      child: const Icon(
        Icons.delete_outline,
        color: AppColors.errorRed,
        size: 24,
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(PharmacyStrings.extHapuseresep),
        content: Text(
          PharmacyStrings.extApakahandayakininginmenghapuseresepini,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              CoreStrings.extBatal,
              style: TextStyle(color: AppColors.textGrey),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              CoreStrings.extHapus,
              style: TextStyle(color: AppColors.errorRed),
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
