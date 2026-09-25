import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:mobatech_app/core/constants/strings/error_strings.dart';
import 'package:mobatech_app/core/utils/formatters.dart';
import 'package:mobatech_app/core/constants/strings/pharmacy_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/pharmacy_provider.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';
import 'package:mobatech_app/core/theme/app_typography.dart';
part 'cart_screen_widgets.dart';
part 'cart_item_widget.dart';
part 'cart_bottom_bar.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_SCREEN,
      body: cartAsync.when(
        data: (cart) => CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 56,
              pinned: true,
              backgroundColor: AppColors.PRIMARY,
              iconTheme: const IconThemeData(color: AppColors.TEXT_WHITE),
              centerTitle: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(AppSpacing.borderRadiusXl),
                ),
              ),
              title: const Text(
                PharmacyStrings.extKeranjang,
                style: TextStyle(
                  color: AppColors.TEXT_WHITE,
                  fontWeight: FontWeight.bold,
                ),
              ),
              flexibleSpace: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(AppSpacing.borderRadiusXl),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      top: -10,
                      child: Opacity(
                        opacity: 0.35,
                        child: Image.asset(
                          CoreStrings.headerLogoAsset,
                          width: 180,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _CartItemList(cart: cart),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            const Center(child: Text(ErrorStrings.extGagalmemuatkeranjang)),
      ),
      bottomNavigationBar: cartAsync.whenOrNull(
        data: (cart) {
          if (cart.items.isEmpty) return null;
          return _CartBottomBar(cart: cart);
        },
      ),
    );
  }
}
