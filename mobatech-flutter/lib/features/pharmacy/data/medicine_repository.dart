import 'package:dio/dio.dart';
import '../models/medicine_category.dart';
import '../models/medicine.dart';

class MedicineRepository {
  final Dio _dio;

  MedicineRepository(this._dio);

  Future<List<MedicineCategory>> getCategories({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _dio.get(
      '/pharmacy/categories',
      queryParameters: {'page': page, 'limit': limit},
    );
    final payload = response.data;
    final List<dynamic> data = payload is Map && payload.containsKey('data')
        ? payload['data']
        : (payload as List? ?? []);
    return data.map((e) => MedicineCategory.fromBackendJson(e)).toList();
  }

  Future<(List<Medicine>, bool)> getMedicines({
    int? categoryId,
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _dio.get(
      '/pharmacy/medicines',
      queryParameters: {
        if (categoryId != null) 'category_id': categoryId,
        if (search != null && search.isNotEmpty) 'search': search,
        'page': page,
        'limit': limit,
      },
    );
    final dynamic payload = response.data;
    final List<dynamic> data = payload is Map && payload.containsKey('data')
        ? payload['data']
        : (payload as List? ?? []);

    final meta = payload is Map && payload.containsKey('meta')
        ? payload['meta'] as Map<String, dynamic>?
        : response.extra['meta'] as Map<String, dynamic>?;

    final medicines = data.map((e) => Medicine.fromBackendJson(e)).toList();

    final currentPage = meta?['current_page'] as int? ?? 1;
    final totalPages = meta?['total_pages'] as int? ?? 1;

    return (medicines, currentPage < totalPages);
  }
}
