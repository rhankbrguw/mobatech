import 'package:mobatech_app/core/theme/app_typography.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'chat_bubble_parts.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isUser;
  final bool isLoading;
  final String? imagePath;
  final String? filePath;

  const ChatBubble({
    super.key,
    required this.text,
    required this.time,
    this.isUser = false,
    this.isLoading = false,
    this.imagePath,
    this.filePath,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isUser) ...[
          Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm12),
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: const BoxDecoration(
              color: AppColors.PRIMARY_LIGHT,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy,
              color: AppColors.PRIMARY,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ] else
          const SizedBox(width: AppSpacing.xxxl),

        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
              boxShadow: [
                BoxShadow(
                  color: AppColors.SHADOW_COLOR.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  color: isUser
                      ? AppColors.PRIMARY.withValues(alpha: 0.85)
                      : AppColors.BACKGROUND_WHITE.withValues(alpha: 0.85),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (imagePath != null)
                        ChatBubbleImage(imagePath: imagePath ?? ''),
                      if (filePath != null)
                        ChatBubbleFile(
                          filePath: filePath ?? '',
                          isUser: isUser,
                        ),
                      if (isLoading)
                        const ChatBubbleLoader()
                      else
                        ChatBubbleText(text: text, isUser: isUser),
                      const SizedBox(height: AppSpacing.sm),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          time,
                          style: TextStyle(
                            fontSize: AppTypography.xs,
                            color: isUser
                                ? AppColors.TEXT_WHITE
                                : AppColors.TEXT_GREY,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        if (isUser) ...[
          const SizedBox(width: AppSpacing.sm),
          Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm12),
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.PRIMARY,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: AppColors.BACKGROUND_WHITE,
              size: 20,
            ),
          ),
        ] else
          const SizedBox(width: AppSpacing.xxxl),
      ],
    );
  }
}
