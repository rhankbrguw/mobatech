import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../models/pharmacy_order.dart';
import '../../../../core/widgets/glass_status_chip.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:mobatech_app/core/utils/formatters.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class OrderCard extends StatelessWidget {
  final PharmacyOrder order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/pharmacy/tracking', extra: order),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.BACKGROUND_WHITE,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.SHADOW_COLOR,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    order.orderNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppTypography.md,
                      color: AppColors.TEXT_DARK,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GlassStatusChip(
                  status: order.status,
                  fontSize: AppTypography.sm,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm12),
            Row(
              children: [
                const Icon(
                  Icons.inventory_2_outlined,
                  color: AppColors.TEXT_GREY,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    order.items.map((e) => e.medicine.name).join(', '),
                    style: const TextStyle(
                      color: AppColors.TEXT_GREY,
                      fontSize: AppTypography.md,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(height: 24, color: AppColors.DIVIDER_GREY),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  CoreStrings.totalOrder,
                  style: TextStyle(
                    color: AppColors.TEXT_DARK,
                    fontSize: AppTypography.md,
                  ),
                ),
                Text(
                  Formatters.formatCurrency(order.totalPrice),
                  style: const TextStyle(
                    color: AppColors.PRIMARY,
                    fontSize: AppTypography.lg,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
