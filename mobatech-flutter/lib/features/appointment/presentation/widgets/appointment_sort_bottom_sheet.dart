import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/appointment_provider.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class AppointmentSortBottomSheet extends ConsumerWidget {
  const AppointmentSortBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.TRANSPARENT,
      builder: (context) => const AppointmentSortBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: AppColors.BACKGROUND_SCREEN,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppSpacing.borderRadiusXl),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Urutkan Dokter',
              style: TextStyle(
                fontSize: AppTypography.xl,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              title: const Text(CoreStrings.extAbjadaz),
              trailing:
                  ref.watch(doctorSortProvider) == DoctorSortOption.nameAsc
                  ? const Icon(Icons.check, color: AppColors.PRIMARY)
                  : null,
              onTap: () {
                ref
                    .read(doctorSortProvider.notifier)
                    .update(DoctorSortOption.nameAsc);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(CoreStrings.extAbjadza),
              trailing:
                  ref.watch(doctorSortProvider) == DoctorSortOption.nameDesc
                  ? const Icon(Icons.check, color: AppColors.PRIMARY)
                  : null,
              onTap: () {
                ref
                    .read(doctorSortProvider.notifier)
                    .update(DoctorSortOption.nameDesc);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
