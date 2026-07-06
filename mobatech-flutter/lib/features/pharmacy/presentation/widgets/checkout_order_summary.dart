import 'package:mobatech_app/core/utils/formatters.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:mobatech_app/core/constants/strings/pharmacy_strings.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../models/cart.dart';

class CheckoutOrderSummary extends StatelessWidget {
  final String pickupMethod;
  final Cart cart;

  const CheckoutOrderSummary({
    super.key,
    required this.pickupMethod,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          ...cart.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${item.medicine.name} (${item.quantity})',
                    style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    Formatters.formatCurrency(item.medicine.price * item.quantity),
                    style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 24, color: AppColors.dividerGrey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                CoreStrings.extSubtotal,
                style: TextStyle(color: AppColors.textGrey),
              ),
              Text(
                Formatters.formatCurrency(cart.totalPrice),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                PharmacyStrings.extOngkoskirim,
                style: TextStyle(color: AppColors.textGrey),
              ),
              Text(
                pickupMethod == 'Delivery' ? Formatters.formatCurrency(10000) : Formatters.formatCurrency(0),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
