import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import 'home_family_chip.dart';

class HomeFamilySection extends ConsumerWidget {
  const HomeFamilySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) return const SizedBox.shrink();
        final familyList = user.familyMembers ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Anggota Keluarga',
                    style: TextStyle(
                      fontSize: AppTypography.xl,
                      fontWeight: FontWeight.bold,
                      color: AppColors.TEXT_DARK,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/profile/family-members'),
                    child: const Text(
                      'Kelola →',
                      style: TextStyle(
                        fontSize: AppTypography.sm13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.PRIMARY,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm12),
            SizedBox(
              height: 72,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                physics: const BouncingScrollPhysics(),
                children: [
                  HomeFamilyMemberChip(
                    name: user.fullName.split(' ').first,
                    relation: 'Saya',
                    isPrimary: true,
                    onTap: () => context.push('/profile'),
                  ),
                  ...familyList.map((member) {
                    final m = member as Map<String, dynamic>;
                    final name = (m['full_name'] as String? ?? 'Keluarga').split(' ').first;
                    final relation = m['relationship'] as String? ?? 'Keluarga';
                    return HomeFamilyMemberChip(
                      name: name,
                      relation: relation,
                      isPrimary: false,
                      onTap: () => context.push('/profile/family-members'),
                    );
                  }),
                  const HomeFamilyAddButton(),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
