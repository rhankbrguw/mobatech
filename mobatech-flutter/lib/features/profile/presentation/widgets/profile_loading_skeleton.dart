import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class ProfileLoadingSkeleton extends StatelessWidget {
  const ProfileLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: const CustomScrollView(
          physics: NeverScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 120.0,
              pinned: true,
              backgroundColor: AppColors.PRIMARY,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  // AppSpacing
                  bottom: Radius.circular(AppSpacing.xl),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    SkeletonLoader(
                      width: double.infinity,
                      height: 140,
                      borderRadius: 24,
                    ),
                    SizedBox(height: AppSpacing.xl),
                    SkeletonLoader(
                      width: double.infinity,
                      height: 360,
                      borderRadius: 24,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
