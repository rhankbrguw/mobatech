import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/strings/profile_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/profile_provider.dart';

class ProfileMenuSection extends ConsumerWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildGroupCard([
          _MenuItem('Ubah Profil', Icons.person_outline, () => context.push('/profile/edit')),
          _MenuItem('Data Rekam Medis', Icons.medical_information_outlined, () => context.push('/medical-results')),
          _MenuItem('Anggota Keluarga', Icons.family_restroom, () => context.push('/profile/family-members')),
        ]),
        const SizedBox(height: AppSpacing.md),
        _buildGroupCard([
          _MenuItem('Pengaturan', Icons.settings_outlined, () => context.push('/profile/settings')),
          _MenuItem('Bantuan & Dukungan', Icons.help_outline, () => context.push('/profile/help-support')),
          _MenuItem('Keluar dari Akun', Icons.logout, () => _handleLogout(context, ref), isDestructive: true),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _buildFooter(),
      ],
    );
  }

  Widget _buildGroupCard(List<_MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_WHITE,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        border: Border.all(color: AppColors.BORDER_GREY),
        boxShadow: [
          BoxShadow(
            color: AppColors.SHADOW_COLOR.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isLast = index == items.length - 1;
          return Column(
            children: [
              ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 2),
                leading: Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: item.isDestructive
                        ? AppColors.ERROR_RED.withValues(alpha: 0.08)
                        : AppColors.PRIMARY.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
                  ),
                  child: Icon(
                    item.icon,
                    size: 18,
                    color: item.isDestructive ? AppColors.ERROR_RED : AppColors.PRIMARY,
                  ),
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: AppTypography.sm13,
                    fontWeight: FontWeight.w600,
                    color: item.isDestructive ? AppColors.ERROR_RED : AppColors.TEXT_DARK,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: item.isDestructive ? AppColors.ERROR_RED : AppColors.ICON_GREY,
                ),
                onTap: item.onTap,
              ),
              if (!isLast) const Divider(height: 1, indent: 48, color: AppColors.BORDER_GREY),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildFooter() {
    return const Column(
      children: [
        Text(
          'Hermina Mobile • v1.0.0',
          style: TextStyle(fontSize: AppTypography.xs11, color: AppColors.TEXT_GREY, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 2),
        Text(
          'Dilindungi Kebijakan Privasi & Kepatuhan PDP',
          style: TextStyle(fontSize: AppTypography.xs10, color: AppColors.TEXT_GREY),
        ),
      ],
    );
  }

  void _handleLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Keluar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppTypography.lg)),
        content: const Text(ProfileStrings.extApakahandayakininginkeluar, style: TextStyle(color: AppColors.TEXT_GREY)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal', style: TextStyle(color: AppColors.TEXT_GREY))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.ERROR_RED),
            onPressed: () => _performLogout(ctx, ref),
            child: const Text('Keluar', style: TextStyle(color: AppColors.TEXT_WHITE)),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogout(BuildContext ctx, WidgetRef ref) async {
    Navigator.pop(ctx);
    await const FlutterSecureStorage().delete(key: 'jwt_token');
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    ref.invalidate(userProfileProvider);
    if (ctx.mounted) ctx.go('/login');
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem(this.title, this.icon, this.onTap, {this.isDestructive = false});
}
