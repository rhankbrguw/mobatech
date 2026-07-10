import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/pharmacy_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../../core/utils/error_handler.dart';
import 'package:mobatech_app/features/pharmacy/providers/pharmacy_provider.dart';
import 'history_card.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

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
          return const Center(
            child: Text(
              PharmacyStrings.noPharmacyHistory,
              style: TextStyle(color: AppColors.textGrey),
            ),
          );
        }
        final isFetchingNextPage = ref.read(ordersProvider.notifier).isFetchingNextPage;
        return ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md20),
          itemCount: orders.length + (isFetchingNextPage ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == orders.length) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Center(child: CupertinoActivityIndicator(radius: 14)),
              );
            }
            final order = orders[index];
            final date = order.createdAt?.toLocal() ?? DateTime.now();
            return HistoryCard(
              title: 'Pesanan #${order.orderNumber}',
              status: order.status,
              date: '${date.day}-${date.month}-${date.year}',
              onTap: () => context.push('/pharmacy/tracking', extra: order),
            );
          },
        );
      },
      loading: () => const CardSkeletonLoader(count: 3),
      error: (e, stack) => _buildErrorState(ErrorHandler.getMessage(e)),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off,
              size: 64,
              color: AppColors.textLightGrey,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
