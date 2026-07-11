import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/prescription_repository.dart';
import '../models/prescription.dart';

final prescriptionRepositoryProvider = Provider<PrescriptionRepository>((ref) {
  return PrescriptionRepository(ref.watch(dioProvider));
});

class PrescriptionsNotifier extends AutoDisposeAsyncNotifier<List<Prescription>> {
  int _page = 1;
  bool _hasMore = true;
  bool _isFetchingNextPage = false;

  bool get hasMore => _hasMore;
  bool get isFetchingNextPage => _isFetchingNextPage;

  @override
  FutureOr<List<Prescription>> build() async {
    _page = 1;
    _hasMore = true;
    _isFetchingNextPage = false;

    final repo = ref.watch(prescriptionRepositoryProvider);
    final (newPrescriptions, hasMoreData) = await repo.getMyPrescriptions(
      page: 1,
      limit: 10,
    );

    _hasMore = hasMoreData;
    return newPrescriptions;
  }

  Future<void> fetchNextPage() async {
    if (_isFetchingNextPage || !_hasMore) return;

    _isFetchingNextPage = true;
    state = AsyncData(state.value ?? []);

    try {
      final repo = ref.read(prescriptionRepositoryProvider);
      final (newPrescriptions, hasMoreData) = await repo.getMyPrescriptions(
        page: _page + 1,
        limit: 10,
      );

      _page++;
      _hasMore = hasMoreData;

      final current = state.value ?? [];
      state = AsyncData([...current, ...newPrescriptions]);
    } catch (e) {
      state = AsyncData(state.value ?? []);
    } finally {
      _isFetchingNextPage = false;
    }
  }

  Future<bool> redeemPrescription(int id) async {
    try {
      final repo = ref.read(prescriptionRepositoryProvider);
      await repo.redeemPrescription(id);
      
      final current = state.value ?? [];
      final updated = current.map((p) {
        if (p.id == id) {
          return Prescription(
            id: p.id,
            appointmentId: p.appointmentId,
            doctorName: p.doctorName,
            diagnosis: p.diagnosis,
            items: p.items,
            userId: p.userId,
            imageUrl: p.imageUrl,
            notes: p.notes,
            status: 'Requested',
            createdAt: p.createdAt,
          );
        }
        return p;
      }).toList();
      state = AsyncData(updated);
      return true;
    } catch (e) {
      return false;
    }
  }
}

final prescriptionsProvider = AsyncNotifierProvider.autoDispose<
  PrescriptionsNotifier,
  List<Prescription>
>(PrescriptionsNotifier.new);
