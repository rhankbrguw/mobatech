import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../screens/polyclinic_screen.dart';
import 'appointment_header_widgets.dart';

class AppointmentSliverHeader extends ConsumerWidget {
  final TextEditingController searchController;

  const AppointmentSliverHeader({super.key, required this.searchController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      backgroundColor: AppColors.PRIMARY,
      expandedHeight: 175,
      pinned: true,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.BACKGROUND_WHITE),
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.TEXT_WHITE,
          size: 18,
        ),
      ),
      title: const Text(
        'Janji Temu Dokter',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.TEXT_WHITE,
          fontSize: AppTypography.xl,
        ),
      ),
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppSpacing.borderRadiusXl),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PolyclinicScreen()),
          ),
          child: const Icon(
            Icons.domain,
            color: AppColors.TEXT_WHITE,
            size: 22,
          ),
        ),
        const SizedBox(width: AppSpacing.sm12),
        GestureDetector(
          onTap: () => context.push('/appointment/user-appointments'),
          child: const Icon(
            Icons.calendar_month,
            color: AppColors.TEXT_WHITE,
            size: 22,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
      ],
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppSpacing.borderRadiusXl),
        ),
        child: FlexibleSpaceBar(
          background: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -10,
                top: -10,
                child: Opacity(
                  opacity: 0.25,
                  child: Image.asset('assets/header_logo.png', width: 140),
                ),
              ),
              Positioned(
                bottom: AppSpacing.sm,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppointmentSearchBar(searchController: searchController),
                    const SizedBox(height: AppSpacing.sm),
                    const AppointmentFilterChips(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
