import 'package:mobatech_app/core/theme/app_typography.dart';
import 'dart:ui';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class EmergencyAppBar extends StatelessWidget {
  const EmergencyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.ERROR_RED,
      foregroundColor: AppColors.BACKGROUND_WHITE,
      title: const Text(
        CoreStrings.emergencyTitle,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: AppTypography.xl,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppSpacing.borderRadiusXl),
        ),
      ),
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppSpacing.borderRadiusXl),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Opacity(
                opacity: 0.4,
                child: Image.asset('assets/header_logo.png', width: 220),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmergencyWarningBanner extends StatelessWidget {
  const EmergencyWarningBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.ERROR_RED.withAlpha(13),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        border: Border.all(color: AppColors.ERROR_RED.withAlpha(51)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.ERROR_RED,
                  size: 32,
                ),
                SizedBox(width: AppSpacing.sm12),
                Expanded(
                  child: Text(
                    CoreStrings.emergencyWarning,
                    style: TextStyle(
                      color: AppColors.ERROR_RED,
                      fontSize: AppTypography.sm13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmergencySectionLabel extends StatelessWidget {
  final String text;
  final IconData icon;

  const EmergencySectionLabel({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.TEXT_GREY),
        const SizedBox(width: AppSpacing.sm),
        Text(
          text,
          style: const TextStyle(
            fontSize: AppTypography.sm,
            fontWeight: FontWeight.w700,
            color: AppColors.TEXT_GREY,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
