import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:mobatech_app/core/constants/strings/home_strings.dart';
import 'package:mobatech_app/core/constants/strings/profile_strings.dart';
import '../../../../core/utils/custom_snackbar.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key});

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
              children: [
                const Icon(
                  Icons.headset_mic_outlined,
                  size: 64,
                  color: AppColors.PRIMARY,
                ),
                const SizedBox(height: AppSpacing.md),
                const Text(
                  'Butuh Bantuan Lebih Lanjut?',
                  style: TextStyle(
                    fontSize: AppTypography.xl,
                    fontWeight: FontWeight.bold,
                    color: AppColors.TEXT_DARK,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Tim Customer Service kami siap melayani Anda 24/7 melalui berbagai platform di bawah ini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppTypography.md,
                    color: AppColors.TEXT_GREY,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          CustomSnackbar.showInfo(
                            context,
                            HomeStrings.extMenghubungkankeagenlivechat,
                          );
                        },
                        icon: const Icon(Icons.chat_bubble_outline),
                        label: const Text(HomeStrings.extLivechat),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.PRIMARY,
                          foregroundColor: AppColors.BACKGROUND_WHITE,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.sm12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.borderRadiusMd,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          CustomSnackbar.showInfo(
                            context,
                            ProfileStrings.extMembukapanggilanke1500123,
                          );
                        },
                        icon: const Icon(Icons.phone_outlined),
                        label: const Text(ProfileStrings.extCallcenter),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.PRIMARY,
                          side: const BorderSide(color: AppColors.PRIMARY),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.sm12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.borderRadiusMd,
                            ),
                          ),
                        ),
                      ),
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
}
