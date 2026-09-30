part of 'cart_screen.dart';

class _CartItemWidget extends ConsumerWidget {
  final dynamic item;
  const _CartItemWidget({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm12),
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_WHITE,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        border: Border.all(color: AppColors.BORDER_GREY),
        boxShadow: [
          BoxShadow(
            color: AppColors.SHADOW_COLOR.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildItemImage(),
          const SizedBox(width: AppSpacing.sm12),
          _buildItemDetails(),
          _buildQuantityControls(ref),
        ],
      ),
    );
  }

  Widget _buildItemImage() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_SCREEN,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
        border: Border.all(color: AppColors.BORDER_GREY),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
        child: item.medicine.imageUrl.isNotEmpty
            ? Image.network(
                item.medicine.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.medication, color: AppColors.PRIMARY),
              )
            : const Icon(Icons.medication, color: AppColors.PRIMARY),
      ),
    );
  }

  Widget _buildItemDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.medicine.name,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.TEXT_DARK, fontSize: AppTypography.sm13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            Formatters.formatCurrency(item.medicine.price),
            style: const TextStyle(color: AppColors.PRIMARY, fontWeight: FontWeight.bold, fontSize: AppTypography.sm13),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityControls(WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_SCREEN,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
        border: Border.all(color: AppColors.BORDER_GREY),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              if (item.quantity > 1) {
                ref.read(cartProvider.notifier).updateCartItem(item.id, item.quantity - 1);
              } else {
                ref.read(cartProvider.notifier).removeFromCart(item.id);
              }
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Icon(Icons.remove, size: 14, color: AppColors.TEXT_GREY),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppTypography.xs11)),
          ),
          InkWell(
            onTap: () => ref.read(cartProvider.notifier).updateCartItem(item.id, item.quantity + 1),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Icon(Icons.add, size: 14, color: AppColors.PRIMARY),
            ),
          ),
        ],
      ),
    );
  }
}
