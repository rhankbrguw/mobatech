import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../data/repositories/appointment_repository.dart';

export 'doctor_provider.dart';
export 'user_appointment_provider.dart';

final appointmentRepositoryProvider = Provider((ref) {
  return AppointmentRepository(ref.watch(dioProvider));
});

class SelectedPolyclinicId extends Notifier<int?> {
  @override
  int? build() => null;
  @override
  set state(int? val) => super.state = val;
}

final selectedPolyclinicIdProvider =
    NotifierProvider<SelectedPolyclinicId, int?>(SelectedPolyclinicId.new);

class SearchQuery extends Notifier<String> {
  @override
  String build() => '';
  @override
  set state(String val) => super.state = val;
}

final searchQueryProvider = NotifierProvider<SearchQuery, String>(
  SearchQuery.new,
);
