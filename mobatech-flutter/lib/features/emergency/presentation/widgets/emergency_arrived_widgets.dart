import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:mobatech_app/core/constants/strings/home_strings.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class ArrivedCheckmark extends StatelessWidget {
  const ArrivedCheckmark({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.BACKGROUND_WHITE.withAlpha(30),
        border: Border.all(
          color: AppColors.BACKGROUND_WHITE.withAlpha(60),
          width: 3,
        ),
      ),
      child: const Icon(
        Icons.check_rounded,
        color: AppColors.BACKGROUND_WHITE,
        size: 64,
      ),
    );
  }
}

class ArrivedMessage extends StatelessWidget {
  const ArrivedMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          CoreStrings.ambulanceArrived,
          style: TextStyle(
            color: AppColors.BACKGROUND_WHITE,
            fontSize: AppTypography.xxxl26,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.sm12),
        Text(
          CoreStrings.arrivedMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.BACKGROUND_WHITE.withAlpha(200),
            fontSize: AppTypography.md15,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class ArrivedDriverCard extends StatelessWidget {
  const ArrivedDriverCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_WHITE.withAlpha(25),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        border: Border.all(color: AppColors.BACKGROUND_WHITE.withAlpha(40)),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.local_shipping,
            color: AppColors.BACKGROUND_WHITE,
            size: 28,
          ),
          SizedBox(width: 14), // AppSpacing
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                CoreStrings.driverInfoArrived,
                style: TextStyle(
                  color: AppColors.BACKGROUND_WHITE,
                  fontSize: AppTypography.md,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.0), // AppSpacing
              Text(
                CoreStrings.ambulanceType,
                style: TextStyle(
                  color: AppColors.TEXT_WHITE70,
                  fontSize: AppTypography.sm,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BackToHomeButton extends StatelessWidget {
  final VoidCallback onPressed;

  const BackToHomeButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // AppSpacing
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.BACKGROUND_WHITE,
          foregroundColor: AppColors.ARRIVED_GREEN2,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // AppSpacing
          ),
          elevation: 0,
        ),
        child: const Text(
          HomeStrings.backToHome,
          style: TextStyle(
            fontSize: AppTypography.lg,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
