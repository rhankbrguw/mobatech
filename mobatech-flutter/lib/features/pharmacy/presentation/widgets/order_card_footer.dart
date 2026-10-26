part of 'order_card.dart';

class OrderCardFooter extends StatelessWidget {
  final double totalPrice;
  const OrderCardFooter({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              CoreStrings.totalOrder,
              style: TextStyle(
                color: AppColors.TEXT_GREY,
                fontSize: AppTypography.xs,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              Formatters.formatCurrency(totalPrice),
              style: const TextStyle(
                color: AppColors.PRIMARY,
                fontSize: AppTypography.md,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.PRIMARY.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.PRIMARY.withValues(alpha: 0.2),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                PharmacyStrings.trackOrder,
                style: TextStyle(
                  color: AppColors.PRIMARY,
                  fontSize: AppTypography.xs,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_rounded,
                size: 14,
                color: AppColors.PRIMARY,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
