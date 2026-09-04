import 'package:mobatech_app/core/constants/strings/profile_strings.dart';
import '../../../../core/utils/custom_snackbar.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/profile_provider.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class ProfileMenuSection extends ConsumerWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuItems = [
      {'icon': Icons.person_outline, 'title': 'Ubah Profil'},
      {'icon': Icons.medical_information_outlined, 'title': 'Data Rekam Medis'},
      {'icon': Icons.family_restroom, 'title': 'Anggota Keluarga'},
      {'icon': Icons.settings_outlined, 'title': 'Pengaturan'},
      {'icon': Icons.help_outline, 'title': 'Bantuan & Dukungan'},
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.SHADOW_COLOR.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: AppColors.BACKGROUND_WHITE.withValues(alpha: 0.85),
            child: Column(
              children: [
                ...menuItems.map(
                  (item) => ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.PRIMARY_LIGHT,
                        borderRadius: BorderRadius.circular(10), // AppSpacing
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: AppColors.PRIMARY,
                      ),
                    ),
                    title: Text(
                      item['title'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.TEXT_DARK,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.ICON_GREY,
                    ),
                    onTap: () {
                      if (item['title'] == 'Ubah Profil') {
                        context.push('/profile/edit');
                      } else if (item['title'] == 'Data Rekam Medis') {
                        context.push('/medical-results');
                      } else if (item['title'] == 'Anggota Keluarga') {
                        context.push('/profile/family-members');
                      } else if (item['title'] == 'Pengaturan') {
                        context.push('/profile/settings');
                      } else if (item['title'] == 'Bantuan & Dukungan') {
                        context.push('/profile/help-support');
                      } else {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        CustomSnackbar.showInfo(
                          context,
                          ProfileStrings.menuComingSoon(
                            item['title'] as String,
                          ),
                        );
                      }
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.ERROR_RED.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10), // AppSpacing
                    ),
                    child: const Icon(Icons.logout, color: AppColors.ERROR_RED),
                  ),
                  title: const Text(
                    ProfileStrings.extKeluar,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.ERROR_RED,
                    ),
                  ),
                  onTap: () async {
                    const secureStorage = FlutterSecureStorage();
                    await secureStorage.delete(key: 'jwt_token');
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    // Secure storage handles deletion
                    ref.invalidate(userProfileProvider);
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
