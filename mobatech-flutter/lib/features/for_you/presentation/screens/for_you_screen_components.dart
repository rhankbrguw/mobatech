part of 'for_you_screen.dart';

class _ArticlesListView extends ConsumerWidget {
  final AsyncValue<List<Article>> asyncArticles;
  const _ArticlesListView({required this.asyncArticles});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      color: AppColors.PRIMARY,
      onRefresh: () => ref.read(forYouArticlesProvider.notifier).refresh(),
      child: asyncArticles.when(
        data: (articles) => _buildDataList(context, ref, articles),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.PRIMARY)),
        error: (e, st) => _buildErrorState(ref),
      ),
    );
  }

  Widget _buildDataList(BuildContext context, WidgetRef ref, List<Article> articles) {
    if (articles.isEmpty) {
      return _buildEmptyState(context);
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
      itemCount: articles.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        if (index == 0) return _buildFypHeaderBanner();
        return ArticleCard(article: articles[index - 1]);
      },
    );
  }

  Widget _buildFypHeaderBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.PRIMARY.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
        border: Border.all(color: AppColors.PRIMARY.withValues(alpha: 0.2)),
      ),
      child: const Row(
        children: [
          Icon(Icons.tips_and_updates_outlined, color: AppColors.PRIMARY, size: 20),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Rekomendasi dipersonalisasi berdasarkan keluhan dan obrolan Anda di Asisten Chatbot AI.',
              style: TextStyle(color: AppColors.PRIMARY, fontSize: AppTypography.xs11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome, size: 48, color: AppColors.PRIMARY),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Belum ada rekomendasi personal',
              style: TextStyle(color: AppColors.TEXT_DARK, fontWeight: FontWeight.bold, fontSize: AppTypography.lg),
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              'Mulai konsultasi dengan Asisten AI untuk mendapatkan FYP edukasi kesehatan Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.TEXT_GREY, fontSize: AppTypography.sm),
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: () => context.push('/chat'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.PRIMARY),
              child: const Text('Mulai Chatbot AI', style: TextStyle(color: AppColors.TEXT_WHITE)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(ErrorStrings.extGagalmemuatrekomendasi, style: TextStyle(color: AppColors.TEXT_GREY)),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton(
            onPressed: () => ref.read(forYouArticlesProvider.notifier).refresh(),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}
