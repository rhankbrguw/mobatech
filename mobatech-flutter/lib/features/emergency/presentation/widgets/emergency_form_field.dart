import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';

class EmergencyFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const EmergencyFormField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: "", // no label
      hint: hint,
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType ?? TextInputType.text,
      validator: validator ?? (v) => Validators.validateRequired(v, hint),
      prefixIcon: Icon(
        icon,
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.primaryGreen
            : AppColors.primary,
        size: 22,
      ),
    );
  }
}
