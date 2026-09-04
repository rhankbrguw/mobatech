import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:mobatech_app/core/constants/strings/error_strings.dart';
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
import 'package:mobatech_app/core/theme/app_spacing.dart';

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
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md20,
          ),
          decoration: BoxDecoration(
            color: AppColors.BACKGROUND_WHITE.withValues(alpha: 0.85),
            border: Border(
              top: BorderSide(
                color: AppColors.TEXT_GREY.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _TotalPaymentColumn(grandTotal: grandTotal)),
                ElevatedButton(
                  onPressed: () => _handleCheckout(context, ref),
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
                    PharmacyStrings.extBayarsekarang,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.TEXT_WHITE,
                      fontSize: AppTypography.lg,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleCheckout(BuildContext context, WidgetRef ref) async {
    try {
      final orderData = {
        'payment_method': paymentMethod,
        'pickup_method': pickupMethod,
        'items': cart.items
            .map((e) => {'medicine_id': e.medicine.id, 'quantity': e.quantity})
            .toList(),
      };

      final repo = ref.read(pharmacyOrderRepositoryProvider);
      final result = await repo.createOrder(orderData);
      final order = PharmacyOrder.fromBackendJson(result);

      for (var item in cart.items) {
        await ref.read(cartProvider.notifier).removeFromCart(item.id);
      }

      ref.invalidate(ordersProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        CustomSnackbar.showSuccess(context, PharmacyStrings.extPesananberhasildibuat);
        context.go('/pharmacy/tracking', extra: order);
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackbar.showError(context, ErrorStrings.extGagalmembuatpesanan);
      }
    }
  }
}

class _TotalPaymentColumn extends StatelessWidget {
  final double grandTotal;
  const _TotalPaymentColumn({required this.grandTotal});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          PharmacyStrings.extTotalpembayaran,
          style: TextStyle(
            color: AppColors.TEXT_GREY,
            fontSize: AppTypography.sm13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          Formatters.formatCurrency(grandTotal),
          style: const TextStyle(
            color: AppColors.PRIMARY,
            fontSize: AppTypography.xxl22,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
