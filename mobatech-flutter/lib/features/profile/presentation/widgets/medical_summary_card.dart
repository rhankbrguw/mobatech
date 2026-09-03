import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:mobatech_app/core/constants/strings/profile_strings.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import 'edit_medical_data_modal.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class MedicalSummaryCard extends StatelessWidget {
  final dynamic user;
  final WidgetRef ref;

  const MedicalSummaryCard({super.key, required this.user, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.SHADOW_COLOR.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: AppColors.PRIMARY_LIGHT.withValues(alpha: 0.5),
            padding: const EdgeInsets.all(AppSpacing.md20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      ProfileStrings.extGolongandarah,
                      style: TextStyle(
                        color: AppColors.TEXT_GREY,
                        fontSize: AppTypography.md,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            // AppSpacing
                            horizontal: AppSpacing.sm12,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.ERROR_RED.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.borderRadiusMd,
                            ),
                          ),
                          child: Text(
                            user.bloodType ?? '-',
                            style: const TextStyle(
                              color: AppColors.ERROR_RED,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        GestureDetector(
                          onTap: () =>
                              showEditMedicalDataModal(context, ref, user),
                          child: Container(
                            padding: const EdgeInsets.all(6.0), // AppSpacing
                            decoration: BoxDecoration(
                              color: AppColors.PRIMARY,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.borderRadiusSm,
                              ),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: AppColors.BACKGROUND_WHITE,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildVitals(
                      'Tinggi',
                      user.height != null ? '${user.height} cm' : '- cm',
                    ),
                    _buildVitals(
                      'Berat',
                      user.weight != null ? '${user.weight} kg' : '- kg',
                    ),
                    _buildVitals(
                      'Alergi',
                      user.allergies != null && user.allergies.isNotEmpty
                          ? user.allergies
                          : 'Tidak Ada',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVitals(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.TEXT_GREY,
            fontSize: AppTypography.sm,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.TEXT_DARK,
            fontWeight: FontWeight.bold,
            fontSize: AppTypography.lg,
          ),
        ),
      ],
    );
  }
}
