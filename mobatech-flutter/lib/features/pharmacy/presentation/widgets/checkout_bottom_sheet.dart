import 'dart:ui';
import 'package:mobatech_app/core/utils/formatters.dart';
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
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite.withValues(alpha: 0.85),
            border: Border(
              top: BorderSide(
                color: Colors.grey.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Pembayaran',
                        style: TextStyle(color: AppColors.textGrey, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Formatters.formatCurrency(grandTotal),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
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
    )));
  }
}
