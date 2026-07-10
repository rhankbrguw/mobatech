import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobatech_app/core/constants/strings/appointment_strings.dart';
import 'package:mobatech_app/core/constants/strings/error_strings.dart';
import 'package:mobatech_app/core/theme/app_colors.dart';
import 'package:mobatech_app/core/widgets/skeleton_loader.dart';
import '../providers/branch_provider.dart';
import 'hospital_card.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class HospitalsListWidget extends ConsumerWidget {
  const HospitalsListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchesAsync = ref.watch(branchProvider);

    return branchesAsync.when(
      data: (branches) {
        if (branches.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Text(
              AppointmentStrings.extTidakadarumahsakitterdekat,
              style: TextStyle(color: AppColors.textGrey),
            ),
          );
        }
        return Column(
          children: branches.map((branch) {
            final dummyDistance =
                '${(branch.id * 1.5 + 2).toStringAsFixed(1)} KM';
            return HospitalCard(
              name: branch.name,
              address: branch.address,
              distance: dummyDistance,
              imageUrl: branch.imageUrl,
              gmapsLink: branch.gmapsLink,
            );
          }).toList(),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: CardSkeletonLoader(count: 2),
      ),
      error: (err, stack) => const Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Text(
          ErrorStrings.extGagalmemuatrumahsakit,
          style: TextStyle(color: AppColors.errorRed),
        ),
      ),
    );
  }
}
