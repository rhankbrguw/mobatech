import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class ProfileAvatarPicker extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onPickImage;

  const ProfileAvatarPicker({
    super.key,
    required this.imagePath,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 3),
              image: imagePath != null
                  ? DecorationImage(
                      image: (imagePath?.startsWith('http') ?? false)
                          ? NetworkImage(imagePath ?? '') as ImageProvider
                          : FileImage(File(imagePath ?? '')),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imagePath == null
                ? const Icon(Icons.person, size: 50, color: AppColors.primary)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onPickImage,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.backgroundWhite,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: AppColors.backgroundWhite,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
