import 'package:mobatech_app/core/theme/app_typography.dart';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../providers/profile_provider.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class ProfileUserCard extends StatelessWidget {
  final UserProfile user;
  const ProfileUserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.PRIMARY_LIGHT.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.SHADOW_COLOR.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.PRIMARY,
                  backgroundImage: user.imagePath != null
                      ? ((user.imagePath?.startsWith('http') ?? false)
                            ? NetworkImage(user.imagePath ?? '')
                                  as ImageProvider
                            : FileImage(File(user.imagePath ?? '')))
                      : null,
                  child: user.imagePath == null
                      ? Text(
                          user.fullName.isNotEmpty
                              ? user.fullName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontSize: AppTypography.display,
                            color: AppColors.BACKGROUND_WHITE,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: const TextStyle(
                          fontSize: AppTypography.xxl,
                          fontWeight: FontWeight.bold,
                          color: AppColors.TEXT_DARK,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: AppTypography.md,
                          color: AppColors.TEXT_GREY,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        Formatters.formatPhoneNumber(user.phone),
                        style: const TextStyle(
                          fontSize: AppTypography.md,
                          color: AppColors.TEXT_GREY,
                        ),
                      ),
                    ],
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
