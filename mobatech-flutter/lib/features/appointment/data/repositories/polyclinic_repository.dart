import 'package:dio/dio.dart';
import '../models/polyclinic.dart';

class PolyclinicRepository {
  final Dio _dio;

  PolyclinicRepository(this._dio);

  Future<(List<Polyclinic>, bool)> getPolyclinics({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/polyclinics',
        queryParameters: {'page': page, 'limit': limit},
      );
      final dynamic payload = response.data;
      final List<dynamic> data = payload is Map && payload.containsKey('data')
          ? payload['data']
          : (payload as List? ?? []);

      final meta = payload is Map && payload.containsKey('meta')
          ? payload['meta'] as Map<String, dynamic>?
          : response.extra['meta'] as Map<String, dynamic>?;

      final polyclinics = data
          .map((json) => Polyclinic.fromJson(json))
          .toList();

      final currentPage = meta?['current_page'] as int? ?? 1;
      final totalPages = meta?['total_pages'] as int? ?? 1;

      return (polyclinics, currentPage < totalPages);
    } catch (e) {
      rethrow;
    }
  }

  Future<Polyclinic> getPolyclinicById(int id) async {
    try {
      final response = await _dio.get('/polyclinics/$id');
      return Polyclinic.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
