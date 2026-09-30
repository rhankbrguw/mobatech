import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../providers/profile_provider.dart';

class ProfileUserCard extends StatelessWidget {
  final UserProfile user;
  const ProfileUserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_WHITE,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        border: Border.all(color: AppColors.PRIMARY.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: AppColors.SHADOW_COLOR.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          _buildAvatar(),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: _buildInfo()),
          _buildEditButton(context),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final hasImg = user.imagePath != null && user.imagePath!.isNotEmpty;
    return CircleAvatar(
      radius: 28,
      backgroundColor: AppColors.PRIMARY,
      backgroundImage: hasImg
          ? ((user.imagePath?.startsWith('http') ?? false)
              ? NetworkImage(user.imagePath!) as ImageProvider
              : FileImage(File(user.imagePath!)))
          : null,
      child: !hasImg
          ? Text(
              user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : 'U',
              style: const TextStyle(
                fontSize: AppTypography.xxl,
                color: AppColors.BACKGROUND_WHITE,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                user.fullName,
                style: const TextStyle(
                  fontSize: AppTypography.lg,
                  fontWeight: FontWeight.bold,
                  color: AppColors.TEXT_DARK,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            const Icon(Icons.verified, size: 14, color: AppColors.PRIMARY),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          user.email,
          style: const TextStyle(fontSize: AppTypography.xs11, color: AppColors.TEXT_GREY),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          Formatters.formatPhoneNumber(user.phone),
          style: const TextStyle(fontSize: AppTypography.xs11, color: AppColors.TEXT_GREY),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => context.push('/profile/edit'),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
        side: BorderSide(color: AppColors.PRIMARY.withValues(alpha: 0.3)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm)),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.edit_outlined, size: 12, color: AppColors.PRIMARY),
          SizedBox(width: 3),
          Text(
            'Ubah',
            style: TextStyle(fontSize: AppTypography.xs11, color: AppColors.PRIMARY, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
