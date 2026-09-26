import 'package:flutter/material.dart';
import '../../../../core/constants/strings/home_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class HospitalFooterAction extends StatelessWidget {
  final VoidCallback onMapTap;
  const HospitalFooterAction({super.key, required this.onMapTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.PRIMARY.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
        border: Border.all(
          color: AppColors.PRIMARY.withValues(alpha: 0.15),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_outlined,
            size: 16,
            color: AppColors.PRIMARY,
          ),
          SizedBox(width: 6),
          Text(
            HomeStrings.extPetunjukarah,
            style: TextStyle(
              fontSize: AppTypography.xs,
              fontWeight: FontWeight.bold,
              color: AppColors.PRIMARY,
            ),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.open_in_new_rounded,
            size: 13,
            color: AppColors.PRIMARY,
          ),
        ],
      ),
    );
  }
}
