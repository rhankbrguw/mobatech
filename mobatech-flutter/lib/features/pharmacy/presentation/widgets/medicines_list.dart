import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:mobatech_app/core/constants/strings/error_strings.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../providers/pharmacy_provider.dart';
import '../widgets/shimmer_loading.dart';
import 'catalog_widgets.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class MedicinesList extends ConsumerWidget {
  final AsyncValue<List<dynamic>> medicinesAsync;
  final MedicineFilter filter;
  const MedicinesList({super.key, required this.medicinesAsync, required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return medicinesAsync.when(
      data: (medicines) {
        final isFetchingNextPage = ref.read(medicinesProvider(filter).notifier).isFetchingNextPage;
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index == medicines.length) {
                return const Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Center(child: CupertinoActivityIndicator(radius: 14)),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
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
            }, childCount: medicines.length + (isFetchingNextPage ? 1 : 0)),
          ),
        );
      },
      loading: () => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md),
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
