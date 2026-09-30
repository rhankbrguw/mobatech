part of 'special_offers_screen.dart';

class _PromoCard extends StatelessWidget {
  final SpecialOffer offer;
  const _PromoCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.TRANSPARENT,
      margin: EdgeInsets.zero, // AppSpacing
      child: InkWell(
        onTap: () => context.push('/special-offers/detail', extra: offer),
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
      height: 160,
      decoration: _buildCardDecoration(),
      child: Stack(children: [_buildBackgroundIcon(), _buildTextContent()]),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [offer.themeColor.withValues(alpha: 0.8), offer.themeColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(AppSpacing.md20),
      boxShadow: [
        BoxShadow(
          color: offer.themeColor.withValues(alpha: 0.3),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  Widget _buildBackgroundIcon() {
    return const Positioned(
      right: -30,
      top: -30,
      child: Opacity(
        opacity: 0.2,
        child: Icon(Icons.local_offer, size: 150, color: AppColors.TEXT_WHITE),
      ),
    );
  }

  Widget _buildTextContent() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPromoLabel(),
          const SizedBox(height: AppSpacing.sm12),
          Text(
            offer.title,
            style: const TextStyle(
              color: AppColors.TEXT_WHITE,
              fontSize: AppTypography.xxl,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            offer.subtitle,
            style: TextStyle(
              color: AppColors.TEXT_WHITE.withValues(alpha: 0.9),
              fontSize: AppTypography.md,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.BLACK10,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
      ),
      child: const Text(
        HomeStrings.extPromo,
        style: TextStyle(
          color: AppColors.TEXT_WHITE,
          fontWeight: FontWeight.bold,
          fontSize: AppTypography.sm,
        ),
      ),
    );
  }
}
