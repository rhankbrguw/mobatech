import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../models/medicine.dart';
import 'package:mobatech_app/core/constants/strings/pharmacy_strings.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

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
        children: [_buildTextInfo(), _buildPriceAndAction()],
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
            fontSize: 14,
            color: AppColors.textDark,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              medicine.genericName,
              style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              medicine.stock > 0 ? '${medicine.stock} Tersedia' : 'Stok Habis',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: medicine.stock > 0 ? AppColors.textLightGrey : AppColors.errorRed,
              ),
            ),
          ],
        ),
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
            color: AppColors.primary,
            fontSize: 14,
          ),
        ),
        medicine.requiresPrescription
            ? _buildPrescriptionLabel()
            : _buildAddToCartButton(),
      ],
    );
  }

  Widget _buildPrescriptionLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.iconOrange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        CoreStrings.prescriptionLabel,
        style: TextStyle(
          color: AppColors.iconOrange,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAddToCartButton() {
    final isOutOfStock = medicine.stock <= 0;
    return GestureDetector(
      onTap: isOutOfStock ? null : onAddToCart,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm12, vertical: 6),
        decoration: BoxDecoration(
          color: isOutOfStock
              ? AppColors.backgroundWave
              : AppColors.primaryLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: isOutOfStock
            ? Text(
                PharmacyStrings.extStokhabis,
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              )
            : const Icon(Icons.add, color: AppColors.primary, size: 18),
      ),
    );
  }
}
