import 'package:mobatech_app/core/theme/app_typography.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class ChatBubbleImage extends StatelessWidget {
  final String imagePath;

  const ChatBubbleImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
        child: Image.file(File(imagePath), fit: BoxFit.cover),
      ),
    );
  }
}

class ChatBubbleFile extends StatelessWidget {
  final String filePath;
  final bool isUser;

  const ChatBubbleFile({
    super.key,
    required this.filePath,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm12),
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_WHITE.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
        border: Border.all(
          color: isUser ? AppColors.ICON_WHITE30 : AppColors.BORDER_GREY,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.description,
            color: isUser ? AppColors.BACKGROUND_WHITE : AppColors.ICON_ORANGE,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              filePath.split('/').last,
              style: TextStyle(
                color: isUser
                    ? AppColors.BACKGROUND_WHITE
                    : AppColors.TEXT_DARK,
                fontSize: AppTypography.sm,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubbleLoader extends StatelessWidget {
  const ChatBubbleLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonLoader(
          height: 14,
          width: 200,
          margin: EdgeInsets.only(bottom: AppSpacing.sm),
        ),
        SkeletonLoader(
          height: 14,
          width: 150,
          margin: EdgeInsets.only(bottom: AppSpacing.sm),
        ),
        SkeletonLoader(height: 14, width: 180),
      ],
    );
  }
}

class ChatBubbleText extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatBubbleText({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink(); // AppSpacing
    if (isUser) {
      return Text(
        text,
        style: const TextStyle(
          fontSize: AppTypography.md,
          color: AppColors.TEXT_WHITE,
          height: 1.4,
          fontWeight: FontWeight.normal,
        ),
      );
    }
    return MarkdownBody(
      data: text,
      styleSheet: MarkdownStyleSheet(
        p: const TextStyle(
          fontSize: AppTypography.md,
          color: AppColors.TEXT_DARK,
          height: 1.4,
          fontWeight: FontWeight.w500,
        ),
        pPadding: const EdgeInsets.only(bottom: AppSpacing.sm),
        listBullet: const TextStyle(color: AppColors.TEXT_DARK),
        listBulletPadding: const EdgeInsets.only(right: AppSpacing.sm),
        strong: const TextStyle(
          color: AppColors.TEXT_DARK,
          fontWeight: FontWeight.bold,
        ),
        blockSpacing: 12.0,
      ),
    );
  }
}
