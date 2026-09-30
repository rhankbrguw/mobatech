import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/appointment.dart';
import 'appointment_provider.dart';

part 'user_appointment_provider.g.dart';

@riverpod
class UserAppointments extends _$UserAppointments {
  int _page = 1;
  bool _hasMore = true;
  bool _isFetchingNextPage = false;

  bool get hasMore => _hasMore;
  bool get isFetchingNextPage => _isFetchingNextPage;

  @override
  FutureOr<List<Appointment>> build() async {
    _page = 1;
    _hasMore = true;
    _isFetchingNextPage = false;

    final repository = ref.watch(appointmentRepositoryProvider);
    final (newAppointments, hasMoreData) = await repository.getUserAppointments(
      page: 1,
      limit: 10,
    );

    _hasMore = hasMoreData;
    return newAppointments;
  }

  Future<void> fetchNextPage() async {
    if (_isFetchingNextPage || !_hasMore) return;

    _isFetchingNextPage = true;
    state = AsyncData(state.value ?? []);

    try {
      final repository = ref.read(appointmentRepositoryProvider);

      final (newAppointments, hasMoreData) = await repository
          .getUserAppointments(page: _page + 1, limit: 10);

      _page++;
      _hasMore = hasMoreData;

      final currentAppointments = state.value ?? [];
      state = AsyncData([...currentAppointments, ...newAppointments]);
    } catch (e) {
      state = AsyncData(state.value ?? []);
    } finally {
      _isFetchingNextPage = false;
    }
  }
}
