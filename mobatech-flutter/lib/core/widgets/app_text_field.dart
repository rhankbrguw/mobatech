import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobatech_app/core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';
import 'package:mobatech_app/core/theme/app_typography.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: TextStyle(
              color: AppColors.getTextPrimary(isDark),
              fontWeight: FontWeight.w600,
              fontSize: AppTypography.sm13,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          validator: validator,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          style: TextStyle(
            color: AppColors.getTextPrimary(isDark),
            fontSize: AppTypography.md,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.getTextSecondary(isDark),
              fontSize: AppTypography.md,
            ),
            prefixIcon: prefixIcon != null
                ? IconTheme(
                    data: IconThemeData(
                      color: AppColors.getTextSecondary(isDark),
                    ),
                    child: prefixIcon ?? const SizedBox(),
                  )
                : null,
            suffixIcon: suffixIcon,
            errorMaxLines: 4,
            helperMaxLines: 4,
            isDense: true,
            filled: true,
            fillColor: AppColors.getGlassBackground(isDark),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm12,
              vertical: AppSpacing.sm,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
              borderSide: BorderSide(color: AppColors.getGlassBorder(isDark)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
              borderSide: BorderSide(color: AppColors.getGlassBorder(isDark)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
              borderSide: const BorderSide(
                color: AppColors.PRIMARY_GREEN,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
              borderSide: const BorderSide(color: AppColors.ERROR_RED),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
              borderSide: const BorderSide(
                color: AppColors.ERROR_RED,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
