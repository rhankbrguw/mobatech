import 'dart:ui';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

import 'package:mobatech_app/core/theme/app_typography.dart';

class ChatTextField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmitted;
  final VoidCallback onAttachmentTap;

  const ChatTextField({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.onAttachmentTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusXl),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.WHITE85,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusXl),
            border: Border.all(color: AppColors.GREY20),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onSubmitted: (_) => onSubmitted(),
                  decoration: const InputDecoration(
                    hintText: CoreStrings.chatInputHint,
                    hintStyle: TextStyle(
                      fontSize: AppTypography.sm13,
                      color: AppColors.TEXT_GREY,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onAttachmentTap,
                child: const Icon(
                  Icons.attach_file,
                  color: AppColors.TEXT_GREY,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
