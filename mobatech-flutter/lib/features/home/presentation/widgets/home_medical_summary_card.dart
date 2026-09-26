import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class HomeMedicalSummaryCard extends ConsumerWidget {
  const HomeMedicalSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.BACKGROUND_WHITE,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
              border: Border.all(color: AppColors.PRIMARY.withValues(alpha: 0.15)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.SHADOW_COLOR.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.medical_services_outlined, size: 18, color: AppColors.PRIMARY),
                        SizedBox(width: AppSpacing.xs),
                        Text(
                          'Rekam Medis & Kesehatan',
                          style: TextStyle(
                            fontSize: AppTypography.sm13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.TEXT_DARK,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => context.push('/medical-results'),
                      child: const Text(
                        'Detail →',
                        style: TextStyle(
                          fontSize: AppTypography.xs11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.PRIMARY,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(child: _buildItem('Gol. Darah', user.bloodType ?? '-', isBlood: true)),
                    Expanded(child: _buildItem('Tinggi', user.height != null ? '${user.height} cm' : '-')),
                    Expanded(child: _buildItem('Berat', user.weight != null ? '${user.weight} kg' : '-')),
                    Expanded(child: _buildItem('Alergi', (user.allergies != null && user.allergies!.isNotEmpty) ? user.allergies! : 'Nihil')),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildItem(String label, String value, {bool isBlood = false}) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: AppTypography.xs10, color: AppColors.TEXT_GREY),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontSize: AppTypography.sm13,
            fontWeight: FontWeight.bold,
            color: isBlood ? AppColors.ERROR_RED : AppColors.TEXT_DARK,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
