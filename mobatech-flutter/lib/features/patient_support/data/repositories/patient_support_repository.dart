import 'package:dio/dio.dart';
import '../models/medical_result.dart';
import '../models/reminder.dart';

class PatientSupportRepository {
  final Dio _dio;

  PatientSupportRepository(this._dio);

  Future<List<MedicalResult>> getMedicalResults() async {
    final response = await _dio.get('/medical-results');
    if (response.data != null) {
      return (response.data as List)
          .map((e) => MedicalResult.fromJson(e))
          .toList();
    }
    return [];
  }

  Future<List<Reminder>> getReminders() async {
    final response = await _dio.get('/reminders');
    if (response.data != null) {
      return (response.data as List).map((e) => Reminder.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> markReminderAsRead(String id) async {
    await _dio.put('/reminders/$id/read', data: {});
  }

  Future<int> getUnreadReminderCount() async {
    final response = await _dio.get('/reminders/unread-count');
    return response.data['count'] ?? 0;
  }
}
