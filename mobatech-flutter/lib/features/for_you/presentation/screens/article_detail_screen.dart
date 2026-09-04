import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:mobatech_app/core/constants/strings/profile_strings.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/mock_ui_providers.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_SCREEN,
      appBar: AppBar(
        title: const Text(
          ProfileStrings.extDetailartikel,
          style: TextStyle(
            color: AppColors.TEXT_WHITE,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.PRIMARY,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.TEXT_WHITE),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(AppSpacing.borderRadiusXl),
          ),
        ),
        flexibleSpace: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            // AppSpacing
            bottom: Radius.circular(AppSpacing.borderRadiusXl),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Opacity(
                  opacity: 0.3,
                  child: Image.asset('assets/header_logo.png', width: 220),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.PRIMARY.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
              ),
              child: Text(
                article.category,
                style: const TextStyle(
                  color: AppColors.PRIMARY,
                  fontSize: AppTypography.sm,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              article.title,
              style: const TextStyle(
                fontSize: AppTypography.xxxl,
                fontWeight: FontWeight.bold,
                color: AppColors.TEXT_DARK,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppColors.TEXT_GREY,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  article.readTime,
                  style: const TextStyle(
                    color: AppColors.TEXT_GREY,
                    fontSize: AppTypography.md,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.md20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.PRIMARY.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(AppSpacing.md20),
                    border: Border.all(
                      color: AppColors.PRIMARY.withValues(alpha: 0.1),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    article.content,
                    style: const TextStyle(
                      fontSize: AppTypography.lg,
                      height: 1.6,
                      color: AppColors.TEXT_DARK,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
