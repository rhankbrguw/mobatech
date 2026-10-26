import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mobatech_app/features/patient_support/data/repositories/patient_support_repository.dart';

void main() {
  group('PatientSupportRepository Notification Tests', () {
    test('getReminders parses paginated notifications correctly', () async {
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'notifications': [
                    {
                      'id': 10,
                      'title': 'Janji Temu Disetujui',
                      'message': 'Jadwal dokter telah dikonfirmasi.',
                      'created_at': '2026-09-22T10:00:00Z',
                      'type': 'appointment',
                      'is_read': false,
                    },
                  ],
                  'total': 1,
                  'unread_count': 1,
                },
              ),
            );
          },
        ),
      );

      final repo = PatientSupportRepository(dio);
      final list = await repo.getReminders(page: 1, limit: 10);
      expect(list.length, 1);
      expect(list[0].id, '10');
      expect(list[0].title, 'Janji Temu Disetujui');
      expect(list[0].isRead, false);
    });

    test('getUnreadReminderCount parses unread count', () async {
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {'count': 5},
              ),
            );
          },
        ),
      );

      final repo = PatientSupportRepository(dio);
      final count = await repo.getUnreadReminderCount();
      expect(count, 5);
    });

    test('markAllAsRead calls PUT /notifications/read-all', () async {
      late String lastPath;
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            lastPath = options.path;
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {'success': true},
              ),
            );
          },
        ),
      );

      final repo = PatientSupportRepository(dio);
      await repo.markAllAsRead();
      expect(lastPath, '/notifications/read-all');
    });
  });
}
