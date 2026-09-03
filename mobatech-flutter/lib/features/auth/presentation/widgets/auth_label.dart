import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AuthLabel extends StatelessWidget {
  final String text;

  const AuthLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            color: AppColors.TEXT_DARK,
            fontSize: AppTypography.md,
            fontWeight: FontWeight.w500,
          ),
          children: const [
            TextSpan(
              text: '*',
              style: TextStyle(color: AppColors.ERROR_RED),
            ),
          ],
        ),
      ),
    );
  }
}
