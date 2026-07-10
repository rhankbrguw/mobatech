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
    final responseData = response.data;
    final List<dynamic> data =
        responseData is Map && responseData.containsKey('data')
        ? responseData['data']
        : (responseData as List? ?? []);
    return data.map((e) => MedicineCategory.fromJson(e)).toList();
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
    final dynamic responseData = response.data;
    final List<dynamic> data =
        responseData is Map && responseData.containsKey('data')
        ? responseData['data']
        : (responseData as List? ?? []);
        
    final meta = responseData is Map && responseData.containsKey('meta')
        ? responseData['meta'] as Map<String, dynamic>?
        : response.extra['meta'] as Map<String, dynamic>?;

    final medicines = data.map((e) => Medicine.fromJson(e)).toList();
    
    final currentPage = meta?['current_page'] as int? ?? 1;
    final totalPages = meta?['total_pages'] as int? ?? 1;

    return (medicines, currentPage < totalPages);
  }
}
