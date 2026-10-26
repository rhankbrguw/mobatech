import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:mobatech_app/core/constants/strings/error_strings.dart';
import 'package:mobatech_app/core/constants/strings/pharmacy_strings.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/checkout_order_summary.dart';
import '../widgets/checkout_pickup_method.dart';
import '../widgets/checkout_payment_method.dart';
import '../widgets/checkout_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/pharmacy_provider.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String _pickupMethod = 'Delivery';
  String _paymentMethod = 'Transfer';

  @override
  Widget build(BuildContext context) {
    final cartAsync = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_LIGHT_GREY,
      appBar: AppBar(
        title: const Text(
          PharmacyStrings.extCheckout,
          style: TextStyle(
            color: AppColors.TEXT_WHITE,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.PRIMARY,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.TEXT_WHITE),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            // AppSpacing
            bottom: Radius.circular(AppSpacing.borderRadiusXl),
          ),
        ),
        flexibleSpace: SafeArea(
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -10,
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset('assets/header_logo.png', width: 150),
                ),
              ),
            ],
          ),
        ),
      ),
      body: cartAsync.when(
        data: (cart) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Text(PharmacyStrings.extKeranjangandakosong),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(PharmacyStrings.orderSummary),
                CheckoutOrderSummary(pickupMethod: _pickupMethod, cart: cart),
                const SizedBox(height: AppSpacing.lg),
                _buildSectionTitle(PharmacyStrings.pickupMethod),
                CheckoutPickupMethod(
                  pickupMethod: _pickupMethod,
                  onChanged: (val) => setState(() => _pickupMethod = val),
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildSectionTitle(PharmacyStrings.paymentMethod),
                CheckoutPaymentMethod(
                  paymentMethod: _paymentMethod,
                  onChanged: (val) => setState(() => _paymentMethod = val),
                ),
                const SizedBox(height: 100), // AppSpacing
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) =>
            const Center(child: Text(ErrorStrings.extGagalmemuatpesanan)),
      ),
      bottomSheet: cartAsync.whenOrNull(
        data: (cart) {
          if (cart.items.isEmpty) return null;
          final ongkir = _pickupMethod == 'Delivery' ? 10000 : 0;
          final grandTotal = cart.totalPrice + ongkir;
          return CheckoutBottomSheet(
            grandTotal: grandTotal,
            cart: cart,
            paymentMethod: _paymentMethod,
            pickupMethod: _pickupMethod,
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: AppTypography.lg,
          fontWeight: FontWeight.bold,
          color: AppColors.TEXT_DARK,
        ),
      ),
    );
  }
}
