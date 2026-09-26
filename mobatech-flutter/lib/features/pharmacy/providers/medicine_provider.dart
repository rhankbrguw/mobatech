import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_client.dart';
import '../data/medicine_repository.dart';
import '../models/medicine_category.dart';
import '../models/medicine.dart';

part 'medicine_provider.g.dart';

final medicineRepositoryProvider = Provider<MedicineRepository>((ref) {
  return MedicineRepository(ref.watch(dioProvider));
});

final categoriesProvider = FutureProvider<List<MedicineCategory>>((ref) async {
  final repo = ref.watch(medicineRepositoryProvider);
  return repo.getCategories(page: 1, limit: 10);
});

typedef MedicineFilter = ({int? categoryId, String? search});

@riverpod
class Medicines extends _$Medicines {
  int _page = 1;
  bool _hasMore = true;
  bool _isFetchingNextPage = false;

  bool get hasMore => _hasMore;
  bool get isFetchingNextPage => _isFetchingNextPage;

  @override
  FutureOr<List<Medicine>> build(MedicineFilter arg) async {
    _page = 1;
    _hasMore = true;
    _isFetchingNextPage = false;

    final repo = ref.watch(medicineRepositoryProvider);
    final (newMedicines, hasMoreData) = await repo.getMedicines(
      categoryId: arg.categoryId,
      search: arg.search,
      page: 1,
      limit: 10,
    );

    _hasMore = hasMoreData;
    return newMedicines;
  }

  Future<void> fetchNextPage() async {
    if (_isFetchingNextPage || !_hasMore) return;

    _isFetchingNextPage = true;
    state = AsyncData(state.value ?? []);

    try {
      final repo = ref.read(medicineRepositoryProvider);
      final (newMedicines, hasMoreData) = await repo.getMedicines(
        categoryId: arg.categoryId,
        search: arg.search,
        page: _page + 1,
        limit: 10,
      );

      _page++;
      _hasMore = hasMoreData;

      final current = state.value ?? [];
      state = AsyncData([...current, ...newMedicines]);
    } catch (e) {
      state = AsyncData(state.value ?? []);
    } finally {
      _isFetchingNextPage = false;
    }
  }
}
