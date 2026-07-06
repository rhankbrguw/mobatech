import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:mobatech_app/core/constants/strings/error_strings.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../providers/pharmacy_provider.dart';
import '../widgets/shimmer_loading.dart';
import 'catalog_widgets.dart';

class MedicinesList extends ConsumerWidget {
  final AsyncValue<List<dynamic>> medicinesAsync;
  const MedicinesList({super.key, required this.medicinesAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return medicinesAsync.when(
      data: (medicines) => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: MedicineCard(
                medicine: medicines[index],
                onAddToCart: () {
                  ref
                      .read(cartProvider.notifier)
                      .addToCart(medicines[index].id, 1);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  CustomSnackbar.showSuccess(
                    context,
                    '${medicines[index].name}${CoreStrings.addedToCartSuffix}',
                  );
                },
              ),
            );
          }, childCount: medicines.length),
        ),
      ),
      loading: () => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: ShimmerLoading(
                width: double.infinity,
                height: 100,
                borderRadius: 16,
              ),
            ),
            childCount: 4,
          ),
        ),
      ),
      error: (err, stack) => const SliverToBoxAdapter(
        child: Center(child: Text(ErrorStrings.errorLoadMedicines)),
      ),
    );
  }
}
