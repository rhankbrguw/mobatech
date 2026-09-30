import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../models/pharmacy_order.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class OrderTrackingHeader extends StatelessWidget {
  final PharmacyOrder? order;
  final String orderTitle;
  final String status;

  const OrderTrackingHeader({
    super.key,
    required this.order,
    required this.orderTitle,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  orderTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppTypography.lg,
                    color: AppColors.TEXT_DARK,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  // AppSpacing
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.getStatusBgColor(status),
                  borderRadius: BorderRadius.circular(
                    AppSpacing.borderRadiusMd,
                  ),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: AppColors.getStatusColor(status),
                    fontSize: AppTypography.sm,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Tgl Pemesanan: Hari ini',
            style: TextStyle(color: AppColors.TEXT_GREY),
          ),
        ],
      ),
    );
  }
}
