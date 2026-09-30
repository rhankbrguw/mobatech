import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class AttachmentBottomSheet extends StatelessWidget {
  final VoidCallback onPickGallery;
  final VoidCallback onPickCamera;
  final VoidCallback onPickDocument;

  const AttachmentBottomSheet({
    super.key,
    required this.onPickGallery,
    required this.onPickCamera,
    required this.onPickDocument,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.BACKGROUND_WHITE,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.borderRadiusXl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.DIVIDER_GREY,
              borderRadius: BorderRadius.circular(2.0), // AppSpacing
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOption(
                Icons.image,
                CoreStrings.chatAttachmentGallery,
                AppColors.ICON_BLUE,
                onPickGallery,
              ),
              _buildOption(
                Icons.camera_alt,
                CoreStrings.chatAttachmentCamera,
                AppColors.ICON_GREEN,
                onPickCamera,
              ),
              _buildOption(
                Icons.description,
                CoreStrings.chatAttachmentDocument,
                AppColors.ICON_ORANGE,
                onPickDocument,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildOption(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: const TextStyle(
              fontSize: AppTypography.sm,
              color: AppColors.TEXT_DARK,
            ),
          ),
        ],
      ),
    );
  }
}
