import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../data/repositories/appointment_repository.dart';

export 'doctor_provider.dart';
export 'user_appointment_provider.dart';

final appointmentRepositoryProvider = Provider((ref) {
  return AppointmentRepository(ref.watch(dioProvider));
});

final selectedPolyclinicIdProvider = StateProvider<int?>((ref) => null);

final searchQueryProvider = StateProvider<String>((ref) => '');
