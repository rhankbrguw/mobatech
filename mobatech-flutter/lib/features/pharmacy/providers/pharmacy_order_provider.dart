import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/pharmacy_order_repository.dart';
import '../models/pharmacy_order.dart';

final pharmacyOrderRepositoryProvider = Provider<PharmacyOrderRepository>((
  ref,
) {
  return PharmacyOrderRepository(ref.watch(dioProvider));
});

class OrdersNotifier extends AutoDisposeAsyncNotifier<List<PharmacyOrder>> {
  int _page = 1;
  bool _hasMore = true;
  bool _isFetchingNextPage = false;

  bool get hasMore => _hasMore;
  bool get isFetchingNextPage => _isFetchingNextPage;

  @override
  FutureOr<List<PharmacyOrder>> build() async {
    _page = 1;
    _hasMore = true;
    _isFetchingNextPage = false;

    final repo = ref.watch(pharmacyOrderRepositoryProvider);
    final (newOrders, hasMoreData) = await repo.getMyOrders(
      page: 1,
      limit: 10,
    );

    _hasMore = hasMoreData;
    return newOrders;
  }

  Future<void> fetchNextPage() async {
    if (_isFetchingNextPage || !_hasMore) return;

    _isFetchingNextPage = true;
    state = AsyncData(state.value ?? []);

    try {
      final repo = ref.read(pharmacyOrderRepositoryProvider);
      final (newOrders, hasMoreData) = await repo.getMyOrders(
        page: _page + 1,
        limit: 10,
      );

      _page++;
      _hasMore = hasMoreData;

      final current = state.value ?? [];
      state = AsyncData([...current, ...newOrders]);
    } catch (e) {
      state = AsyncData(state.value ?? []);
    } finally {
      _isFetchingNextPage = false;
    }
  }
}

final ordersProvider = AsyncNotifierProvider.autoDispose<
  OrdersNotifier,
  List<PharmacyOrder>
>(OrdersNotifier.new);
