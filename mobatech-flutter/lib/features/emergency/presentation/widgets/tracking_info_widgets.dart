import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class EstimatedTimeCircle extends StatelessWidget {
  final int estimatedMinutes;

  const EstimatedTimeCircle({super.key, required this.estimatedMinutes});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.AMBULANCE_BLUE, AppColors.AMBULANCE_BLUE_DARK],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.AMBULANCE_BLUE.withAlpha(80),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$estimatedMinutes',
            style: const TextStyle(
              color: AppColors.BACKGROUND_WHITE,
              fontSize: AppTypography.xxl22,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const Text(
            CoreStrings.min,
            style: TextStyle(
              color: AppColors.TEXT_WHITE70,
              fontSize: AppTypography.xs11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class DriverInfoRow extends StatelessWidget {
  const DriverInfoRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.PRIMARY.withAlpha(25),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person, color: AppColors.PRIMARY, size: 26),
        ),
        const SizedBox(width: 14), // AppSpacing
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                CoreStrings.driverName,
                style: TextStyle(
                  fontSize: AppTypography.md15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.TEXT_DARK,
                ),
              ),
              SizedBox(height: 2.0), // AppSpacing
              Text(
                CoreStrings.driverDetails,
                style: TextStyle(
                  fontSize: AppTypography.sm,
                  color: AppColors.TEXT_GREY,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.SUCCESS_GREEN,
            borderRadius: BorderRadius.circular(14), // AppSpacing
            boxShadow: [
              BoxShadow(
                color: AppColors.SUCCESS_GREEN.withAlpha(80),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: AppColors.TRANSPARENT,
            child: InkWell(
              borderRadius: BorderRadius.circular(14), // AppSpacing
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                CustomSnackbar.showInfo(context, CoreStrings.contactingDriver);
              },
              child: const Padding(
                padding: EdgeInsets.all(AppSpacing.sm12),
                child: Icon(
                  Icons.phone,
                  color: AppColors.BACKGROUND_WHITE,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
