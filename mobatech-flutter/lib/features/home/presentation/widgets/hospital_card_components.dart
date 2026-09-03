import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:mobatech_app/core/constants/strings/home_strings.dart';
import '../../../../core/theme/app_colors.dart';

class HospitalInfoColumn extends StatelessWidget {
  final String name;
  final String address;
  final String distance;

  const HospitalInfoColumn({
    super.key,
    required this.name,
    required this.address,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppTypography.lg,
                  color: AppColors.TEXT_DARK,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.PRIMARY,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  distance,
                  style: const TextStyle(
                    color: AppColors.PRIMARY,
                    fontSize: AppTypography.sm13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6.0), // AppSpacing
        Text(
          address,
          style: const TextStyle(
            fontSize: AppTypography.sm,
            color: AppColors.TEXT_GREY,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class HospitalActionButtons extends StatelessWidget {
  final VoidCallback onMapTap;

  const HospitalActionButtons({super.key, required this.onMapTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onMapTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconContainer(Icons.directions_outlined),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                HomeStrings.extRute,
                style: TextStyle(
                  fontSize: AppTypography.xs,
                  fontWeight: FontWeight.bold,
                  color: AppColors.PRIMARY,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm12),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIconContainer(Icons.more_vert),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              CoreStrings.extMore,
              style: TextStyle(
                fontSize: AppTypography.xs,
                fontWeight: FontWeight.bold,
                color: AppColors.PRIMARY,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIconContainer(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6.0), // AppSpacing
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.BORDER_GREY.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
      ),
      child: Icon(icon, color: AppColors.PRIMARY, size: 20),
    );
  }
}
