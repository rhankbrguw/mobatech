part of 'catalog_widgets.dart';

class MedicineCardImage extends StatelessWidget {
  final Medicine medicine;
  const MedicineCardImage({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.PRIMARY.withValues(alpha: 0.05),
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(AppSpacing.borderRadiusLg),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(AppSpacing.borderRadiusLg),
        ),
        child: medicine.imageUrl.isNotEmpty
            ? Image.network(
                medicine.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildFallbackIcon(),
              )
            : _buildFallbackIcon(),
      ),
    );
  }

  Widget _buildFallbackIcon() => const Center(
        child: Icon(
          Icons.medication_outlined,
          size: 36,
          color: AppColors.PRIMARY,
        ),
      );
}
