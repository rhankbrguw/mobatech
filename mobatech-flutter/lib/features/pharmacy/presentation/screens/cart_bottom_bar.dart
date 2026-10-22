part of 'cart_screen.dart';

class _CartBottomBar extends StatelessWidget {
  final dynamic cart;
  const _CartBottomBar({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_WHITE,
        border: const Border(top: BorderSide(color: AppColors.BORDER_GREY)),
        boxShadow: [
          BoxShadow(
            color: AppColors.SHADOW_COLOR.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_buildTotalText(), _buildCheckoutButton(context)],
        ),
      ),
    );
  }

  Widget _buildTotalText() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          PharmacyStrings.extTotalpembayaran,
          style: TextStyle(color: AppColors.TEXT_GREY, fontSize: AppTypography.xs11),
        ),
        const SizedBox(height: 2),
        Text(
          Formatters.formatCurrency(cart.totalPrice),
          style: const TextStyle(
            color: AppColors.PRIMARY,
            fontSize: AppTypography.xl,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => context.push('/pharmacy/checkout'),
      icon: const Icon(Icons.shopping_bag_outlined, size: 18),
      label: const Text(
        PharmacyStrings.extCheckout,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppTypography.md),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.PRIMARY,
        foregroundColor: AppColors.TEXT_WHITE,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd)),
        elevation: 0,
      ),
    );
  }
}
