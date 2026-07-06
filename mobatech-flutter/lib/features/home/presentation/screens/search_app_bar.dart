import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobatech_app/core/constants/strings/home_strings.dart';
import 'package:mobatech_app/core/constants/strings/profile_strings.dart';
import '../../../../core/theme/app_colors.dart';
import 'search_screen.dart';

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
      backgroundColor: AppColors.primary,
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
        icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
        onPressed: () => context.pop(),
      ),
      title: Text(
        ProfileStrings.extHasilpencarian,
        style: const TextStyle(
          color: AppColors.backgroundWhite,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4.0,
              ),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: searchController,
                  autofocus: true,
                  style: const TextStyle(
                    color: AppColors.backgroundWhite,
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    hintText: HomeStrings.searchGeneralHint,
                    hintStyle: TextStyle(
                      color: AppColors.textWhite70,
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.textWhite70,
                      size: 18,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  onChanged: (val) {
                    ref.read(globalSearchQueryProvider.notifier).state = val;
                  },
                ),
              ),
            ),
            TabBar(
              controller: tabController,
              indicatorColor: AppColors.backgroundWhite,
              labelColor: AppColors.backgroundWhite,
              unselectedLabelColor: AppColors.textWhite70,
              isScrollable: false,
              labelPadding: EdgeInsets.zero,
              dividerColor: AppColors.transparent,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(fontSize: 13),
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
