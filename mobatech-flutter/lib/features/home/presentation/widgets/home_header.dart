import 'package:mobatech_app/core/theme/app_typography.dart';
import 'dart:io';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:mobatech_app/core/constants/strings/home_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../patient_support/providers/patient_support_provider.dart';
import 'home_header_parts.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider).value;
    final firstName =
        userProfile?.fullName.split(' ').first ?? CoreStrings.defaultUser;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.PRIMARY,
        borderRadius: BorderRadius.only(
          // AppSpacing
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
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
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.BACKGROUND_WHITE.withValues(
                          alpha: 0.2,
                        ),
                        backgroundImage: userProfile?.imagePath != null
                            ? ((userProfile?.imagePath?.startsWith('http') ??
                                      false)
                                  ? NetworkImage(userProfile?.imagePath ?? '')
                                        as ImageProvider
                                  : FileImage(
                                      File(userProfile?.imagePath ?? ''),
                                    ))
                            : null,
                        child: userProfile?.imagePath == null
                            ? const Icon(
                                Icons.person,
                                color: AppColors.TEXT_WHITE,
                                size: 28,
                              )
                            : null,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${HomeStrings.homeGreetingPrefix}$firstName',
                              style: const TextStyle(
                                color: AppColors.TEXT_WHITE,
                                fontSize: AppTypography.xxl,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            const Text(
                              HomeStrings.homeGreetingSubtitle,
                              style: TextStyle(
                                color: AppColors.TEXT_WHITE,
                                fontSize: AppTypography.sm13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final unreadCount = ref.watch(unreadReminderCountProvider).value ?? 0;
                          return HomeHeaderNotificationButton(unreadCount: unreadCount);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const HomeHeaderSearchField(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
