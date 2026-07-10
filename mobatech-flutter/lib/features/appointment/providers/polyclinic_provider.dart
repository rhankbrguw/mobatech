import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../data/repositories/polyclinic_repository.dart';
import '../data/models/polyclinic.dart';

final polyclinicRepositoryProvider = Provider((ref) {
  return PolyclinicRepository(ref.watch(dioProvider));
});

class PolyclinicsNotifier extends AutoDisposeAsyncNotifier<List<Polyclinic>> {
  int _page = 1;
  bool _hasMore = true;
  bool _isFetchingNextPage = false;

  bool get hasMore => _hasMore;
  bool get isFetchingNextPage => _isFetchingNextPage;

  @override
  FutureOr<List<Polyclinic>> build() async {
    _page = 1;
    _hasMore = true;
    _isFetchingNextPage = false;

    final repository = ref.watch(polyclinicRepositoryProvider);
    final (newPolyclinics, hasMoreData) = await repository.getPolyclinics(
      page: 1,
      limit: 10,
    );

    _hasMore = hasMoreData;
    return newPolyclinics;
  }

  Future<void> fetchNextPage() async {
    if (_isFetchingNextPage || !_hasMore) return;

    _isFetchingNextPage = true;
    state = AsyncData(state.value ?? []);

    try {
      final repository = ref.read(polyclinicRepositoryProvider);

      final (newPolyclinics, hasMoreData) = await repository.getPolyclinics(
        page: _page + 1,
        limit: 10,
      );

      _page++;
      _hasMore = hasMoreData;

      final currentPolyclinics = state.value ?? [];
      state = AsyncData([...currentPolyclinics, ...newPolyclinics]);
    } catch (e) {
      state = AsyncData(state.value ?? []);
    } finally {
      _isFetchingNextPage = false;
    }
  }
}

final polyclinicsProvider =
    AsyncNotifierProvider.autoDispose<PolyclinicsNotifier, List<Polyclinic>>(
        PolyclinicsNotifier.new);


final polyclinicDetailProvider = FutureProvider.family<Polyclinic, int>((
  ref,
  id,
) async {
  final repository = ref.watch(polyclinicRepositoryProvider);
  return repository.getPolyclinicById(id);
});
