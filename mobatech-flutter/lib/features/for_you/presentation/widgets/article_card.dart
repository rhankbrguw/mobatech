import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/for_you_article.dart';
import 'article_card_parts.dart';

class ArticleCard extends StatelessWidget {
  final ForYouArticle article;
  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final doctorInfo = article.doctorName ?? article.polyName;
    return Card(
      elevation: 0,
      color: AppColors.BACKGROUND_WHITE,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        side: const BorderSide(color: AppColors.BORDER_GREY),
      ),
      child: InkWell(
        onTap: () => context.push('/for-you/detail', extra: article),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTagRow(),
              const SizedBox(height: AppSpacing.sm),
              _buildHeader(),
              const SizedBox(height: AppSpacing.sm),
              _buildBody(),
              if (doctorInfo != null) ...[
                const SizedBox(height: AppSpacing.sm),
                ArticleDoctorChip(text: doctorInfo),
              ],
              const SizedBox(height: AppSpacing.md),
              ArticleCardFooter(article: article),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.PRIMARY.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome, size: 13, color: AppColors.PRIMARY),
          const SizedBox(width: AppSpacing.xs),
          Text(
            article.tag,
            style: const TextStyle(
              color: AppColors.PRIMARY,
              fontSize: AppTypography.xs11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.BACKGROUND_SCREEN,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          ),
          child: Text(
            article.category,
            style: const TextStyle(color: AppColors.TEXT_DARK, fontSize: AppTypography.xs11, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: [
            const Icon(Icons.access_time, size: 12, color: AppColors.TEXT_GREY),
            const SizedBox(width: AppSpacing.xs),
            Text(article.readTime, style: const TextStyle(color: AppColors.TEXT_GREY, fontSize: AppTypography.xs11)),
          ],
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          article.title,
          style: const TextStyle(fontSize: AppTypography.xl, fontWeight: FontWeight.bold, color: AppColors.TEXT_DARK),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          article.content,
          style: const TextStyle(fontSize: AppTypography.md, color: AppColors.TEXT_GREY),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
