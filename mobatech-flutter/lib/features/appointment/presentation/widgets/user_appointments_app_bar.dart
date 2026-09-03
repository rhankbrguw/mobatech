import 'package:mobatech_app/core/theme/app_spacing.dart';
import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class UserAppointmentsAppBar extends StatelessWidget {
  const UserAppointmentsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140.0,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.PRIMARY,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.TEXT_WHITE),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppSpacing.borderRadiusXl),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Janji Temu Saya',
          style: TextStyle(
            color: AppColors.TEXT_WHITE,
            fontWeight: FontWeight.bold,
            fontSize: AppTypography.xl,
          ),
        ),
        background: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -20,
              top: -10,
              child: Opacity(
                opacity: 0.4,
                child: Image.asset('assets/header_logo.png', width: 220),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
