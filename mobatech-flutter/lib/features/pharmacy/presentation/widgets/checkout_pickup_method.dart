import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class CheckoutPickupMethod extends StatelessWidget {
  final String pickupMethod;
  final ValueChanged<String> onChanged;

  const CheckoutPickupMethod({
    super.key,
    required this.pickupMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildSelectableCard(
            title: 'Delivery',
            icon: Icons.local_shipping_outlined,
            isSelected: pickupMethod == 'Delivery',
            onTap: () => onChanged('Delivery'),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildSelectableCard(
            title: 'Pickup at Counter',
            icon: Icons.storefront_outlined,
            isSelected: pickupMethod == 'Pickup',
            onTap: () => onChanged('Pickup'),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectableCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.PRIMARY_LIGHT
              : AppColors.BACKGROUND_WHITE,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          border: Border.all(
            color: isSelected ? AppColors.PRIMARY : AppColors.BORDER_GREY,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppColors.PRIMARY : AppColors.ICON_GREY,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppTypography.sm,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.PRIMARY : AppColors.TEXT_GREY,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
