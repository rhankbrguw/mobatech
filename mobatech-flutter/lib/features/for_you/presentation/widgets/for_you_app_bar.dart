import 'package:flutter/material.dart';
import '../../../../core/constants/strings/core_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class ForYouAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ForYouAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        CoreStrings.extUntukanda,
        style: TextStyle(
          color: AppColors.TEXT_WHITE,
          fontWeight: FontWeight.bold,
          fontSize: AppTypography.xl,
        ),
      ),
      backgroundColor: AppColors.PRIMARY,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.TEXT_WHITE),
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
                opacity: 0.3,
                child: Image.asset(CoreStrings.headerLogoAsset, width: 220),
              ),
            ),
          ],
        ),
      ),
      bottom: TabBar(
        indicatorColor: AppColors.TEXT_WHITE,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.TEXT_WHITE,
        unselectedLabelColor: AppColors.TEXT_WHITE.withValues(alpha: 0.7),
        labelStyle: const TextStyle(fontSize: AppTypography.sm13, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: AppTypography.sm13, fontWeight: FontWeight.w500),
        tabs: const [
          Tab(text: 'FYP Untuk Anda'),
          Tab(text: 'Promo Spesial'),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 46);
}
