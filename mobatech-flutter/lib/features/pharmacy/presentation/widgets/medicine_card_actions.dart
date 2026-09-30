import 'package:flutter/material.dart';
import '../../../../core/constants/strings/core_strings.dart';
import '../../../../core/constants/strings/pharmacy_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class MedicineStockChip extends StatelessWidget {
  final int stock;
  const MedicineStockChip({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    final hasStock = stock > 0;
    final stockText = hasStock
        ? '$stock ${PharmacyStrings.extTersedia}'
        : PharmacyStrings.extStokhabis;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: hasStock
            ? AppColors.PRIMARY.withValues(alpha: 0.08)
            : AppColors.ERROR_RED.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        stockText,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: hasStock ? AppColors.PRIMARY : AppColors.ERROR_RED,
        ),
      ),
    );
  }
}

class MedicinePrescriptionBadge extends StatelessWidget {
  const MedicinePrescriptionBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.ICON_ORANGE.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
        border: Border.all(
          color: AppColors.ICON_ORANGE.withValues(alpha: 0.25),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long, size: 12, color: AppColors.ICON_ORANGE),
          SizedBox(width: 4),
          Text(
            CoreStrings.prescriptionLabel,
            style: TextStyle(
              color: AppColors.ICON_ORANGE,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class MedicineAddToCartButton extends StatelessWidget {
  final bool isOutOfStock;
  final VoidCallback onAddToCart;

  const MedicineAddToCartButton({
    super.key,
    required this.isOutOfStock,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isOutOfStock ? null : onAddToCart,
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isOutOfStock
              ? AppColors.BACKGROUND_LIGHT_GREY
              : AppColors.PRIMARY.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          border: Border.all(
            color: isOutOfStock
                ? AppColors.BORDER_GREY
                : AppColors.PRIMARY.withValues(alpha: 0.2),
          ),
        ),
        child: Icon(
          Icons.add_shopping_cart_rounded,
          size: 14,
          color: isOutOfStock ? AppColors.TEXT_GREY : AppColors.PRIMARY,
        ),
      ),
    );
  }
}
