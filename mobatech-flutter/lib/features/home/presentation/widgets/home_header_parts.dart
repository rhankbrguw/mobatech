import 'package:mobatech_app/core/theme/app_spacing.dart';
import 'dart:ui';
import 'package:mobatech_app/core/constants/strings/home_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

import 'package:mobatech_app/core/theme/app_typography.dart';

class HomeHeaderSearchField extends StatelessWidget {
  const HomeHeaderSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/search'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14), // AppSpacing
            decoration: BoxDecoration(
              color: AppColors.BACKGROUND_WHITE.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
              border: Border.all(
                color: AppColors.BACKGROUND_WHITE.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: AppColors.TEXT_WHITE, size: 20),
                SizedBox(width: AppSpacing.sm12),
                Expanded(
                  child: Text(
                    HomeStrings.searchHint,
                    style: TextStyle(
                      color: AppColors.TEXT_WHITE70,
                      fontSize: AppTypography.sm13,
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

class HomeHeaderNotificationButton extends StatelessWidget {
  final int unreadCount;

  const HomeHeaderNotificationButton({
    super.key,
    required this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColors.TEXT_WHITE,
            size: 28,
          ),
          onPressed: () => context.push('/notifications'),
        ),
        if (unreadCount > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: const BoxDecoration(
                color: AppColors.ERROR_RED,
                shape: BoxShape.circle,
              ),
              child: Text(
                unreadCount.toString(),
                style: const TextStyle(
                  color: AppColors.TEXT_WHITE,
                  fontSize: AppTypography.xs,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
