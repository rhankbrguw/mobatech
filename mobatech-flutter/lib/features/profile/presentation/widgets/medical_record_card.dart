import 'package:mobatech_app/core/theme/app_typography.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class MedicalRecordCard extends StatelessWidget {
  final String date;
  final String type;
  final String doctor;
  final String status;
  final IconData icon;
  final Color color;

  const MedicalRecordCard({
    super.key,
    required this.date,
    required this.type,
    required this.doctor,
    required this.status,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_WHITE.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(AppSpacing.md20),
        boxShadow: [
          BoxShadow(
            color: AppColors.SHADOW_COLOR.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.md20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: AppColors.TRANSPARENT,
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm12),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.borderRadiusLg,
                        ),
                      ),
                      child: Icon(icon, color: color, size: 28),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                date,
                                style: const TextStyle(
                                  fontSize: AppTypography.sm,
                                  color: AppColors.TEXT_GREY,
                                ),
                              ),
                              Text(
                                status,
                                style: const TextStyle(
                                  fontSize: AppTypography.sm,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.PRIMARY,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6.0), // AppSpacing
                          Text(
                            type,
                            style: const TextStyle(
                              fontSize: AppTypography.lg,
                              fontWeight: FontWeight.bold,
                              color: AppColors.TEXT_DARK,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            doctor,
                            style: const TextStyle(
                              fontSize: AppTypography.md,
                              color: AppColors.TEXT_GREY,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
