import 'package:mobatech_app/core/constants/strings/pharmacy_strings.dart';
import '../../../../core/utils/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/pharmacy_provider.dart';
import '../../models/cart.dart';
import '../../models/pharmacy_order.dart';

class CheckoutBottomSheet extends ConsumerWidget {
  final double grandTotal;
  final Cart cart;
  final String paymentMethod;
  final String pickupMethod;

  const CheckoutBottomSheet({
    super.key,
    required this.grandTotal,
    required this.cart,
    required this.paymentMethod,
    required this.pickupMethod,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Pembayaran',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                ),
                Text(
                  'Rp ${grandTotal.toInt()}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final orderData = {
                    'payment_method': paymentMethod,
                    'pickup_method': pickupMethod,
                    'items': cart.items
                        .map(
                          (e) => {
                            'medicine_id': e.medicine.id,
                            'quantity': e.quantity,
                          },
                        )
                        .toList(),
                  };

                  final repo = ref.read(pharmacyOrderRepositoryProvider);
                  final result = await repo.createOrder(orderData);
                  final order = PharmacyOrder.fromJson(result);

                  for (var item in cart.items) {
                    await ref
                        .read(cartProvider.notifier)
                        .removeFromCart(item.id);
                  }

                  // Invalidate orders provider so the UI will fetch the new order
                  ref.invalidate(ordersProvider);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    CustomSnackbar.showSuccess(
                      context,
                      PharmacyStrings.extPesananberhasildibuat,
                    );
                    context.go('/pharmacy/tracking', extra: order);
                  }
                } catch (e) {
                  if (context.mounted) {
                    CustomSnackbar.showError(context, 'Gagal membuat pesanan');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Bayar Sekarang',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textWhite,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
