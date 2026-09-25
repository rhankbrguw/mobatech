import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobatech_app/core/constants/strings/home_strings.dart';
import 'package:mobatech_app/core/constants/strings/profile_strings.dart';
import '../../../../core/theme/app_colors.dart';
import 'search_screen.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class SearchAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final TabController tabController;

  const SearchAppBar({
    super.key,
    required this.searchController,
    required this.tabController,
  });

  @override
  Size get preferredSize => const Size.fromHeight(156.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: AppColors.PRIMARY,
      elevation: 0,
      flexibleSpace: ClipRect(
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
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.TEXT_WHITE),
        onPressed: () => context.pop(),
      ),
      title: const Text(
        ProfileStrings.extHasilpencarian,
        style: TextStyle(
          color: AppColors.BACKGROUND_WHITE,
          fontSize: AppTypography.xl,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                // AppSpacing
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.BACKGROUND_WHITE.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(
                    AppSpacing.borderRadiusSm,
                  ),
                ),
                child: TextField(
                  controller: searchController,
                  autofocus: true,
                  style: const TextStyle(
                    color: AppColors.BACKGROUND_WHITE,
                    fontSize: AppTypography.md,
                  ),
                  decoration: const InputDecoration(
                    hintText: HomeStrings.searchGeneralHint,
                    hintStyle: TextStyle(
                      color: AppColors.TEXT_WHITE70,
                      fontSize: AppTypography.sm13,
                    ),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.TEXT_WHITE70,
                      size: 18,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                    ), // AppSpacing
                  ),
                  onChanged: (val) {
                    ref.read(globalSearchQueryProvider.notifier).state = val;
                  },
                ),
              ),
            ),
            TabBar(
              controller: tabController,
              indicatorColor: AppColors.BACKGROUND_WHITE,
              labelColor: AppColors.BACKGROUND_WHITE,
              unselectedLabelColor: AppColors.TEXT_WHITE70,
              isScrollable: false,
              labelPadding: EdgeInsets.zero, // AppSpacing
              dividerColor: AppColors.TRANSPARENT,
              labelStyle: const TextStyle(
                fontSize: AppTypography.sm13,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: AppTypography.sm13,
              ),
              tabs: const [
                Tab(text: 'Semua'),
                Tab(text: 'Dokter'),
                Tab(text: 'Agenda'),
                Tab(text: 'Layanan'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
