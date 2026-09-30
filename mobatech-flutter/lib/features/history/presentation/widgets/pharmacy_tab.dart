import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobatech_app/core/constants/strings/pharmacy_strings.dart';
import 'package:mobatech_app/core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';
import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:mobatech_app/core/utils/error_handler.dart';
import 'package:mobatech_app/core/utils/formatters.dart';
import 'package:mobatech_app/core/widgets/skeleton_loader.dart';
import 'package:mobatech_app/features/pharmacy/models/pharmacy_order.dart';
import 'package:mobatech_app/features/pharmacy/providers/pharmacy_provider.dart';
import 'history_card.dart';

class PharmacyTab extends ConsumerStatefulWidget {
  const PharmacyTab({super.key});

  @override
  ConsumerState<PharmacyTab> createState() => _PharmacyTabState();
}

class _PharmacyTabState extends ConsumerState<PharmacyTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final pos = _scrollController.position;
      if (pos.pixels >= pos.maxScrollExtent - 200) {
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
        if (orders.isEmpty) return _buildEmptyState();
        final isFetching =
            ref.read(ordersProvider.notifier).isFetchingNextPage;
        return _buildListView(orders, isFetching);
      },
      loading: () => const CardSkeletonLoader(count: 3),
      error: (e, _) => _buildErrorState(ErrorHandler.getMessage(e)),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.medication_outlined, size: 64, color: AppColors.TEXT_LIGHT_GREY),
          SizedBox(height: AppSpacing.md),
          Text(
            PharmacyStrings.noPharmacyHistory,
            style: TextStyle(color: AppColors.TEXT_GREY, fontSize: AppTypography.md15),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<PharmacyOrder> orders, bool isFetchingNextPage) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md20,
          ),
          itemCount: orders.length + (isFetchingNextPage ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm12),
          itemBuilder: (context, index) {
            if (index == orders.length) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Center(child: CupertinoActivityIndicator(radius: 14)),
              );
            }
            return _buildOrderItem(context, orders[index]);
          },
        ),
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, PharmacyOrder order) {
    final date = order.createdAt?.toLocal() ?? DateTime.now();
    return HistoryCard(
      title: '${PharmacyStrings.orderPrefix}${order.orderNumber}',
      status: order.status,
      date: Formatters.formatDateID(date),
      icon: Icons.local_pharmacy_rounded,
      onTap: () => context.push('/pharmacy/tracking', extra: order),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 64, color: AppColors.TEXT_LIGHT_GREY),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.TEXT_GREY, fontSize: AppTypography.lg),
            ),
          ],
        ),
      ),
    );
  }
}
