import 'package:mobatech_app/core/theme/app_typography.dart';
import 'dart:ui';
import 'package:mobatech_app/core/constants/strings/profile_strings.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/medical_result.dart';
import 'detail_row_widget.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class MedicalResultHeader extends StatelessWidget {
  final MedicalResult result;

  const MedicalResultHeader({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_WHITE.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusXl),
        border: Border.all(
          color: AppColors.BACKGROUND_WHITE.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.TEXT_DARK.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.testName,
                  style: const TextStyle(
                    fontSize: AppTypography.xxl22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.TEXT_DARK,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                DetailRowWidget(label: 'Tanggal', value: result.date),
                DetailRowWidget(label: 'Status', value: result.status),
                DetailRowWidget(
                  label: 'Rumah Sakit',
                  value: result.hospitalName,
                ),
                if (result.doctorName != null)
                  DetailRowWidget(
                    label: 'Dokter',
                    value: result.doctorName ?? '',
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MedicalResultDetailsBox extends StatelessWidget {
  final String details;

  const MedicalResultDetailsBox({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          ProfileStrings.extHasilpemeriksaan,
          style: TextStyle(
            fontSize: AppTypography.xl,
            fontWeight: FontWeight.bold,
            color: AppColors.TEXT_DARK,
          ),
        ),
        const SizedBox(height: AppSpacing.sm12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusXl),
            boxShadow: [
              BoxShadow(
                color: AppColors.TEXT_DARK.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusXl),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.PRIMARY_LIGHT.withValues(alpha: 0.3),
                  border: Border.all(color: AppColors.PRIMARY_LIGHT),
                ),
                child: Text(
                  details,
                  style: const TextStyle(
                    fontSize: AppTypography.md15,
                    color: AppColors.TEXT_DARK,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
