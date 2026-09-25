part of 'cart_screen.dart';

class _CartItemList extends ConsumerWidget {
  final dynamic cart;
  const _CartItemList({required this.cart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (cart.items.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.PRIMARY.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shopping_cart_outlined, size: 48, color: AppColors.PRIMARY),
                ),
                const SizedBox(height: AppSpacing.md),
                const Text(
                  PharmacyStrings.extKeranjangandakosong,
                  style: TextStyle(fontSize: AppTypography.lg, fontWeight: FontWeight.bold, color: AppColors.TEXT_DARK),
                ),
                const SizedBox(height: AppSpacing.xs),
                const Text(
                  'Silakan tambahkan produk atau obat dari apotek.',
                  style: TextStyle(fontSize: AppTypography.sm13, color: AppColors.TEXT_GREY),
                ),
                const SizedBox(height: AppSpacing.lg),
                OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.PRIMARY),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd)),
                  ),
                  child: const Text('Mulai Belanja', style: TextStyle(color: AppColors.PRIMARY, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final item = cart.items[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _CartItemWidget(item: item),
          );
        }, childCount: cart.items.length),
      ),
    );
  }
}
