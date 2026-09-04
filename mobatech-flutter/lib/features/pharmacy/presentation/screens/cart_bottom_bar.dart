part of 'cart_screen.dart';

class _CartBottomBar extends StatelessWidget {
  final dynamic cart;
  const _CartBottomBar({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_WHITE,
        boxShadow: [
          BoxShadow(
            color: AppColors.SHADOW_COLOR,
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
          style: TextStyle(
            color: AppColors.TEXT_GREY,
            fontSize: AppTypography.sm,
          ),
        ),
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
    return ElevatedButton(
      onPressed: () => context.push('/pharmacy/checkout'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.PRIMARY,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
        ),
      ),
      child: const Text(
        PharmacyStrings.extCheckout,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.TEXT_WHITE,
          fontSize: AppTypography.lg,
        ),
      ),
    );
  }
}
