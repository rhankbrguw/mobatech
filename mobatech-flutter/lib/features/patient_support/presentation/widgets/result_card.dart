import 'package:mobatech_app/core/theme/app_typography.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_status_chip.dart';
import '../../data/models/medical_result.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class ResultCard extends StatelessWidget {
  final MedicalResult result;
  final VoidCallback onTap;

  const ResultCard({super.key, required this.result, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_WHITE,
        borderRadius: BorderRadius.circular(AppSpacing.md20),
        border: Border.all(color: AppColors.BORDER_GREY),
        boxShadow: [
          BoxShadow(
            color: AppColors.SHADOW_COLOR,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.md20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Material(
            color: AppColors.TRANSPARENT,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GlassStatusChip(
                          status: result.status,
                          fontSize: AppTypography.sm,
                        ),
                        Text(
                          result.date,
                          style: const TextStyle(
                            color: AppColors.TEXT_GREY,
                            fontSize: AppTypography.sm13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      result.testName,
                      style: const TextStyle(
                        fontSize: AppTypography.xl,
                        fontWeight: FontWeight.bold,
                        color: AppColors.TEXT_DARK,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        const Icon(
                          Icons.local_hospital_outlined,
                          size: 16,
                          color: AppColors.ICON_GREY,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            result.hospitalName,
                            style: const TextStyle(
                              color: AppColors.TEXT_GREY,
                              fontSize: AppTypography.md,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (result.doctorName != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          const Icon(
                            Icons.person_outline,
                            size: 16,
                            color: AppColors.ICON_GREY,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              result.doctorName ?? '',
                              style: const TextStyle(
                                color: AppColors.TEXT_GREY,
                                fontSize: AppTypography.md,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
