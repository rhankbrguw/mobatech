import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/profile_strings.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:mobatech_app/core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class BloodTypeDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const BloodTypeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          ProfileStrings.extGolongandarah,
          style: TextStyle(
            color: AppColors.TEXT_GREY,
            fontSize: AppTypography.sm,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.BACKGROUND_WHITE,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
            border: Border.all(
              color: AppColors.TEXT_GREY.withValues(alpha: 0.2),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.PRIMARY),
              items:
                  [
                        'A',
                        'B',
                        'AB',
                        'O',
                        'A+',
                        'B+',
                        'AB+',
                        'O+',
                        'A-',
                        'B-',
                        'AB-',
                        'O-',
                      ]
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class SaveMedicalDataButton extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onPressed;

  const SaveMedicalDataButton({
    super.key,
    required this.isSaving,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // AppSpacing
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isSaving ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.PRIMARY,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          ),
          elevation: 0,
        ),
        child: isSaving
            ? const SizedBox(
                // AppSpacing
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: AppColors.BACKGROUND_WHITE,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                CoreStrings.extSimpanperubahan,
                style: TextStyle(
                  color: AppColors.BACKGROUND_WHITE,
                  fontWeight: FontWeight.bold,
                  fontSize: AppTypography.lg,
                ),
              ),
      ),
    );
  }
}
