import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class GenderSelection extends StatelessWidget {
  final String? selectedGender;
  final ValueChanged<String> onChanged;

  const GenderSelection({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.sm),
          child: Text(
            CoreStrings.extJeniskelamin,
            style: TextStyle(
              color: AppColors.TEXT_GREY,
              fontSize: AppTypography.sm13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(child: _buildGenderCard('Laki-laki', Icons.male)),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: _buildGenderCard('Perempuan', Icons.female)),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderCard(String gender, IconData icon) {
    final isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () => onChanged(gender),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: _buildCardDecoration(isSelected),
        child: _buildCardContent(gender, icon, isSelected),
      ),
    );
  }

  BoxDecoration _buildCardDecoration(bool isSelected) {
    return BoxDecoration(
      color: isSelected
          ? AppColors.PRIMARY
          : AppColors.BACKGROUND_WHITE.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
      border: Border.all(
        color: isSelected
            ? AppColors.PRIMARY
            : AppColors.TEXT_GREY.withValues(alpha: 0.2),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.PRIMARY.withValues(alpha: isSelected ? 0.3 : 0.05),
          blurRadius: isSelected ? 8 : 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildCardContent(String gender, IconData icon, bool isSelected) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isSelected ? AppColors.BACKGROUND_WHITE : AppColors.TEXT_GREY,
          size: 20,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          gender,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppTypography.md,
            color: isSelected
                ? AppColors.BACKGROUND_WHITE
                : AppColors.TEXT_DARK,
          ),
        ),
      ],
    );
  }
}
