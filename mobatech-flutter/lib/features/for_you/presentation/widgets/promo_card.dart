import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/providers/mock_promos_provider.dart';

class PromoCard extends StatelessWidget {
  final SpecialOffer offer;
  const PromoCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_WHITE,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        border: Border.all(color: AppColors.BORDER_GREY),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: offer.themeColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.borderRadiusLg),
                  bottomLeft: Radius.circular(AppSpacing.borderRadiusLg),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBadge(),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      offer.title,
                      style: const TextStyle(fontSize: AppTypography.xl, fontWeight: FontWeight.bold, color: AppColors.TEXT_DARK),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      offer.subtitle,
                      style: const TextStyle(fontSize: AppTypography.md, color: AppColors.TEXT_GREY),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: offer.themeColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.local_offer_rounded, size: 11, color: offer.themeColor),
              const SizedBox(width: AppSpacing.xs),
              Text('PROMO', style: TextStyle(fontSize: AppTypography.xs, fontWeight: FontWeight.bold, color: offer.themeColor)),
            ],
          ),
        ),
      ],
    );
  }
}
