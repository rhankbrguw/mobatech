import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class ModalTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType type;
  final bool readOnly;
  final VoidCallback? onTap;

  const ModalTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    required this.type,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: AppColors.BACKGROUND_WHITE,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
            border: Border.all(
              color: AppColors.TEXT_GREY.withValues(alpha: 0.2),
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: type,
            readOnly: readOnly,
            onTap: onTap,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: AppTypography.md,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.TEXT_GREY, size: 20),
              border: InputBorder.none,
              hintText: 'Masukkan ${label.split('(').first.trim()}',
              hintStyle: TextStyle(
                color: AppColors.TEXT_GREY.withValues(alpha: 0.5),
                fontSize: AppTypography.sm13,
                fontWeight: FontWeight.normal,
              ),
              contentPadding: const EdgeInsets.symmetric(
                // AppSpacing
                horizontal: AppSpacing.md,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
