import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/strings/core_strings.dart';
import '../../../../core/constants/strings/pharmacy_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/glass_status_chip.dart';
import '../../models/pharmacy_order.dart';

part 'order_card_parts.dart';
part 'order_card_footer.dart';

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
          border: Border.all(color: AppColors.BORDER_GREY),
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
            OrderCardHeader(order: order),
            const SizedBox(height: AppSpacing.sm12),
            OrderCardItems(items: order.items),
            const Divider(height: 24, color: AppColors.DIVIDER_GREY),
            OrderCardFooter(totalPrice: order.totalPrice),
          ],
        ),
      ),
    );
  }
}
