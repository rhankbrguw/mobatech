import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class HomeFamilyMemberChip extends StatelessWidget {
  final String name;
  final String relation;
  final bool isPrimary;
  final VoidCallback onTap;

  const HomeFamilyMemberChip({
    super.key,
    required this.name,
    required this.relation,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: AppSpacing.sm12),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.BACKGROUND_WHITE,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          border: Border.all(
            color: isPrimary ? AppColors.PRIMARY : AppColors.BORDER_GREY,
            width: isPrimary ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.SHADOW_COLOR.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: isPrimary ? AppColors.PRIMARY : AppColors.PRIMARY_LIGHT,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'U',
                style: TextStyle(
                  fontSize: AppTypography.sm13,
                  fontWeight: FontWeight.bold,
                  color: isPrimary ? AppColors.TEXT_WHITE : AppColors.PRIMARY,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: AppTypography.sm13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.TEXT_DARK,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  relation,
                  style: const TextStyle(
                    fontSize: AppTypography.xs10,
                    color: AppColors.TEXT_GREY,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomeFamilyAddButton extends StatelessWidget {
  const HomeFamilyAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/profile/family-members'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.BACKGROUND_WHITE,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          border: Border.all(color: AppColors.PRIMARY.withValues(alpha: 0.3)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_circle_outline, size: 20, color: AppColors.PRIMARY),
            SizedBox(width: AppSpacing.xs),
            Text(
              'Tambah',
              style: TextStyle(
                fontSize: AppTypography.xs11,
                fontWeight: FontWeight.bold,
                color: AppColors.PRIMARY,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
