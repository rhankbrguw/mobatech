import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class PolyclinicAppBar extends StatelessWidget {
  const PolyclinicAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.PRIMARY,
      expandedHeight: 120,
      pinned: true,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.TEXT_WHITE),
      title: const Text(
        'Jadwal Poli',
        style: TextStyle(
          color: AppColors.TEXT_WHITE,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppSpacing.borderRadiusXl),
        ),
      ),
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppSpacing.borderRadiusXl),
        ),
        child: FlexibleSpaceBar(
          background: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Opacity(
                  opacity: 0.4,
                  child: Image.asset(
                    'assets/header_logo.png',
                    width: 220,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
