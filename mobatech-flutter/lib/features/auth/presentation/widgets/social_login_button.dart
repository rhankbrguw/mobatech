import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class SocialLoginButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // AppSpacing
      width: double.infinity,
      height: AppSizes.buttonHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.BORDER_GREY, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppSizes.borderRadiusXL,
            ), // AppSpacing
          ),
          backgroundColor: AppColors.BACKGROUND_WHITE,
          foregroundColor: AppColors.TEXT_GREY,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.BACKGROUND_WHITE,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.SHADOW_COLOR,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    AppColors.GOOGLE_BLUE,
                    AppColors.GOOGLE_RED,
                    AppColors.GOOGLE_YELLOW,
                    AppColors.GOOGLE_GREEN,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  'G',
                  style: TextStyle(
                    color: AppColors.TEXT_WHITE,
                    fontWeight: FontWeight.bold,
                    fontSize: AppTypography.xxl,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm12),
            Text(
              text,
              style: const TextStyle(
                color: AppColors.TEXT_DARK,
                fontSize: AppTypography.lg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
