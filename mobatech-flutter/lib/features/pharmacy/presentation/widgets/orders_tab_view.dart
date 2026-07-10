import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/error_strings.dart';
import 'package:mobatech_app/core/constants/strings/appointment_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/pharmacy_provider.dart';
import '../widgets/shimmer_loading.dart';
import 'order_card.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class OrdersTabView extends ConsumerStatefulWidget {
  const OrdersTabView({super.key});

  @override
  ConsumerState<OrdersTabView> createState() => _OrdersTabViewState();
}

class _OrdersTabViewState extends ConsumerState<OrdersTabView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        ref.read(ordersProvider.notifier).fetchNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(ordersProvider);

    return ordersAsync.when(
      data: (orders) {
        if (orders.isEmpty) {
          return const Center(child: Text(AppointmentStrings.noOrders));
        }
        final isFetchingNextPage = ref.read(ordersProvider.notifier).isFetchingNextPage;
        
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(ordersProvider);
            await ref.read(ordersProvider.future);
          },
          child: ListView.separated(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            itemCount: orders.length + (isFetchingNextPage ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              if (index == orders.length) {
                return const Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Center(child: CupertinoActivityIndicator(radius: 14)),
                );
              }
              return OrderCard(order: orders[index]);
            },
          ),
        );
      },
      loading: () => ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) => const ShimmerLoading(
          width: double.infinity,
          height: 140,
          borderRadius: 16,
        ),
      ),
      error: (err, stack) =>
          const Center(child: Text(ErrorStrings.errorLoadOrders)),
    );
  }
}
