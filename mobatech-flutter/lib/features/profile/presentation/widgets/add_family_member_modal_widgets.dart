import 'package:mobatech_app/core/theme/app_spacing.dart';
import 'package:mobatech_app/core/constants/strings/profile_strings.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';

import 'package:mobatech_app/core/theme/app_typography.dart';

class GenderOptionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderOptionButton({
    super.key,
    required this.text,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14), // AppSpacing
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.PRIMARY
              : AppColors.getGlassBackground(isDark),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
          border: Border.all(
            color: isSelected
                ? AppColors.PRIMARY_GREEN
                : AppColors.getGlassBorder(isDark),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.PRIMARY_GREEN.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.BACKGROUND_WHITE
                  : AppColors.getTextSecondary(isDark),
              size: 18,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppTypography.sm13,
                color: isSelected
                    ? AppColors.BACKGROUND_WHITE
                    : AppColors.getTextPrimary(isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SaveFamilyMemberButton extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onPressed;

  const SaveFamilyMemberButton({
    super.key,
    required this.isSaving,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: ProfileStrings.extSimpananggota,
      onPressed: onPressed,
      isLoading: isSaving,
      isFullWidth: true,
      size: AppButtonSize.large,
    );
  }
}
