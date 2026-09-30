import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/for_you_article.dart';
import '../providers/for_you_provider.dart';

class ArticleDoctorChip extends StatelessWidget {
  final String text;
  const ArticleDoctorChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.PRIMARY.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
        border: Border.all(color: AppColors.PRIMARY.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_hospital_outlined, size: 13, color: AppColors.PRIMARY),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: AppTypography.xs11, color: AppColors.PRIMARY, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class ArticleCardFooter extends ConsumerWidget {
  final ForYouArticle article;
  const ArticleCardFooter({super.key, required this.article});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        InkWell(
          onTap: () => ref.read(forYouArticlesProvider.notifier).toggleLike(article.id),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              children: [
                Icon(
                  article.isLiked ? Icons.favorite : Icons.favorite_border,
                  size: 16,
                  color: article.isLiked ? Colors.red : AppColors.TEXT_GREY,
                ),
                const SizedBox(width: 4),
                Text('${article.likesCount}', style: const TextStyle(fontSize: AppTypography.xs11, color: AppColors.TEXT_GREY)),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        InkWell(
          onTap: () => ref.read(forYouArticlesProvider.notifier).toggleBookmark(article.id),
          child: Icon(
            article.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            size: 18,
            color: article.isBookmarked ? AppColors.PRIMARY : AppColors.TEXT_GREY,
          ),
        ),
        const Spacer(),
        OutlinedButton(
          onPressed: () => context.push(article.actionRoute),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm12, vertical: 6),
            side: const BorderSide(color: AppColors.PRIMARY),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd)),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            article.actionText,
            style: const TextStyle(color: AppColors.PRIMARY, fontSize: AppTypography.xs11, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
