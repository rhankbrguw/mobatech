import 'package:mobatech_app/core/theme/app_typography.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class SymptomsCard extends StatelessWidget {
  final TextEditingController controller;

  const SymptomsCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
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
          child: Container(
            color: AppColors.BACKGROUND_WHITE.withValues(alpha: 0.85),
            padding: const EdgeInsets.all(AppSpacing.md20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Keluhan / Gejala',
                  style: TextStyle(
                    fontSize: AppTypography.lg,
                    fontWeight: FontWeight.bold,
                    color: AppColors.TEXT_DARK,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.BACKGROUND_WHITE,
                    borderRadius: BorderRadius.circular(
                      AppSpacing.borderRadiusLg,
                    ),
                    border: Border.all(
                      color: AppColors.BORDER_GREY.withValues(alpha: 0.5),
                    ),
                  ),
                  child: TextField(
                    controller: controller,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText:
                          'Tuliskan secara singkat keluhan yang Anda alami...',
                      hintStyle: TextStyle(
                        color: AppColors.TEXT_LIGHT_GREY,
                        fontSize: AppTypography.md,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(AppSpacing.md),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
