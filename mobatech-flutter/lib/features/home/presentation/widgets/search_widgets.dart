import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class SearchEmptyState extends StatelessWidget {
  final String msg;
  const SearchEmptyState({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.TEXT_GREY.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            msg,
            style: const TextStyle(
              color: AppColors.TEXT_GREY,
              fontSize: AppTypography.lg,
            ),
          ),
        ],
      ),
    );
  }
}

class SearchSectionHeader extends StatelessWidget {
  final String title;
  const SearchSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: AppTypography.lg,
          color: AppColors.PRIMARY,
        ),
      ),
    );
  }
}

class SearchItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SearchItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.TRANSPARENT,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
        side: BorderSide(color: AppColors.TEXT_GREY.withValues(alpha: 0.2)),
      ),
      child: Material(
        color: AppColors.BACKGROUND_WHITE,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              // AppSpacing
              horizontal: AppSpacing.sm12,
              vertical: 2,
            ),
            minLeadingWidth: 0,
            horizontalTitleGap: 12,
            leading: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.PRIMARY_LIGHT,
              child: Icon(icon, color: AppColors.PRIMARY, size: 20),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: AppTypography.sm13,
              ),
            ),
            subtitle: Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: AppTypography.xs11),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: AppColors.TEXT_GREY,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
