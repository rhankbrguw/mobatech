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
          .map((e) => MedicalResult.fromBackendJson(e))
          .toList();
    }
    return [];
  }

  Future<List<Reminder>> getReminders({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get(
        '/notifications',
        queryParameters: {'page': page, 'limit': limit},
      );
      if (response.data != null && response.data is Map && response.data['notifications'] != null) {
        final list = response.data['notifications'] as List;
        return list.map((e) => Reminder.fromBackendJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}

    try {
      final response = await _dio.get('/reminders');
      if (response.data != null && response.data is List) {
        return (response.data as List)
            .map((e) => Reminder.fromBackendJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  Future<void> markReminderAsRead(String id) async {
    try {
      await _dio.put('/notifications/$id/read', data: {});
    } catch (_) {
      try {
        await _dio.put('/reminders/$id/read', data: {});
      } catch (_) {}
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _dio.put('/notifications/read-all', data: {});
    } catch (_) {}
  }

  Future<int> getUnreadReminderCount() async {
    try {
      final response = await _dio.get('/notifications/unread-count');
      if (response.data != null && response.data is Map && response.data['count'] != null) {
        return (response.data['count'] as num).toInt();
      }
    } catch (_) {}

    try {
      final response = await _dio.get('/reminders/unread-count');
      if (response.data != null && response.data is Map && response.data['count'] != null) {
        return (response.data['count'] as num).toInt();
      }
    } catch (_) {}
    return 0;
  }
}
