import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../models/medicine.dart';
import 'medicine_card_actions.dart';

class MedicineCardDetails extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback onAddToCart;

  const MedicineCardDetails({
    super.key,
    required this.medicine,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTextInfo(),
          const SizedBox(height: AppSpacing.sm12),
          _buildPriceAndAction(),
        ],
      ),
    );
  }

  Widget _buildTextInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          medicine.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppTypography.md,
            color: AppColors.TEXT_DARK,
          ),
          maxLines: 2,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
        if (medicine.genericName.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            medicine.genericName,
            style: const TextStyle(
              fontSize: AppTypography.xs,
              color: AppColors.TEXT_GREY,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 6),
        MedicineStockChip(stock: medicine.stock),
      ],
    );
  }

  Widget _buildPriceAndAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          Formatters.formatCurrency(medicine.price),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.PRIMARY,
            fontSize: AppTypography.md,
          ),
        ),
        medicine.requiresPrescription
            ? const MedicinePrescriptionBadge()
            : MedicineAddToCartButton(
                isOutOfStock: medicine.stock <= 0,
                onAddToCart: onAddToCart,
              ),
      ],
    );
  }
}
