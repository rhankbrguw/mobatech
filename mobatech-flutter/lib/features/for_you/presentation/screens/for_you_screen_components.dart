part of 'for_you_screen.dart';

class _ForYouAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ForYouAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        CoreStrings.extUntukanda,
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ArticleCard extends StatelessWidget {
  final Article article;
  const _ArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.TRANSPARENT,
      margin: EdgeInsets.zero, // AppSpacing
      child: InkWell(
        onTap: () => context.push('/for-you/detail', extra: article),
        borderRadius: BorderRadius.circular(AppSpacing.md20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.md20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: _buildCardContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.PRIMARY.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSpacing.md20),
        border: Border.all(
          color: AppColors.PRIMARY.withValues(alpha: 0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryLabel(),
          const SizedBox(height: AppSpacing.sm12),
          Text(
            article.title,
            style: const TextStyle(
              fontSize: AppTypography.xl,
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
                  fontSize: AppTypography.sm,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryLabel() {
    return Container(
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
    );
  }
}
