part of 'order_card.dart';

class OrderCardHeader extends StatelessWidget {
  final PharmacyOrder order;
  const OrderCardHeader({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final dateStr = order.createdAt != null
        ? Formatters.formatDateID(order.createdAt!)
        : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.orderNumber,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppTypography.md,
                  color: AppColors.TEXT_DARK,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (dateStr != null) ...[
                const SizedBox(height: 2),
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontSize: AppTypography.xs,
                    color: AppColors.TEXT_GREY,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        GlassStatusChip(
          status: order.status,
          fontSize: AppTypography.xs,
        ),
      ],
    );
  }
}

class OrderCardItems extends StatelessWidget {
  final List<OrderItem> items;
  const OrderCardItems({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final itemNames = items.isEmpty
        ? '-'
        : items.map((e) => '${e.medicine.name} (x${e.quantity})').join(', ');

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.PRIMARY.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.medication_outlined,
            color: AppColors.PRIMARY,
            size: 20,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            itemNames,
            style: const TextStyle(
              color: AppColors.TEXT_GREY,
              fontSize: AppTypography.sm,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
