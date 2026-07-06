import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_text_field.dart';

class PhoneTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const PhoneTextField({super.key, this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: "", // No floating label for auth fields initially
      controller: controller,
      keyboardType: TextInputType.phone,
      validator: validator,
      inputFormatters: [PhonePrefixFormatter()],
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '+62',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.textLightGrey
                    : AppColors.textGrey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 1,
              height: 24,
              color: AppColors.getGlassBorder(
                Theme.of(context).brightness == Brightness.dark,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
