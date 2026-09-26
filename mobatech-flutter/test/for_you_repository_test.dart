import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mobatech_app/features/for_you/data/repositories/for_you_repository.dart';

void main() {
  group('ForYouRepository Tests', () {
    test('getRecommendations parses backend envelope correctly', () async {
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'success': true,
                  'code': 'OK',
                  'data': [
                    {
                      'id': 'cardio-1',
                      'title': 'Menjaga Kesehatan Jantung',
                      'category': 'Poli Jantung',
                      'readTime': '4 min',
                      'content': 'Aktivitas kardio 30 menit per hari.',
                      'tag': 'Berdasarkan Chat Keluhan Dada',
                      'actionText': 'Konsultasi dr. Gia',
                      'actionRoute': '/doctors',
                      'doctorName': 'dr. Gia Pratama Putra, Sp.JP',
                      'polyName': 'Poli Jantung',
                      'likesCount': 120,
                    },
                  ],
                },
              ),
            );
          },
        ),
      );

      final repo = ForYouRepository(dio);
      final articles = await repo.getRecommendations();

      expect(articles.length, 1);
      expect(articles[0].id, 'cardio-1');
      expect(articles[0].title, 'Menjaga Kesehatan Jantung');
      expect(articles[0].category, 'Poli Jantung');
      expect(articles[0].tag, 'Berdasarkan Chat Keluhan Dada');
      expect(articles[0].doctorName, 'dr. Gia Pratama Putra, Sp.JP');
      expect(articles[0].likesCount, 120);
    });

    test('getRecommendations returns empty list on empty data', () async {
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {'success': true, 'data': []},
              ),
            );
          },
        ),
      );

      final repo = ForYouRepository(dio);
      final articles = await repo.getRecommendations();
      expect(articles.isEmpty, true);
    });
  });
}
