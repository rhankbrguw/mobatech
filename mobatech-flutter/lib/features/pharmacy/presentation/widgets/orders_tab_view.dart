import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/error_strings.dart';
import 'package:mobatech_app/core/constants/strings/appointment_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/pharmacy_provider.dart';
import '../widgets/shimmer_loading.dart';
import 'order_card.dart';

class OrdersTabView extends ConsumerWidget {
  const OrdersTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);

    return ordersAsync.when(
      data: (orders) {
        if (orders.isEmpty) {
          return const Center(child: Text(AppointmentStrings.noOrders));
        }
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(ordersProvider);
            await ref.read(ordersProvider.future);
          },
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            itemCount: orders.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return OrderCard(order: orders[index]);
            },
          ),
        );
      },
      loading: () => ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
