import 'package:dio/dio.dart';
import '../models/medicine_category.dart';
import '../models/medicine.dart';

class MedicineRepository {
  final Dio _dio;

  MedicineRepository(this._dio);

  Future<List<MedicineCategory>> getCategories() async {
    final response = await _dio.get('/pharmacy/categories');
    final data = response.data as List;
    return data.map((e) => MedicineCategory.fromJson(e)).toList();
  }

  Future<List<Medicine>> getMedicines({int? categoryId, String? search}) async {
    final response = await _dio.get(
      '/pharmacy/medicines',
      queryParameters: {
        if (categoryId != null) 'category_id': categoryId,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    final data = response.data as List;
    return data.map((e) => Medicine.fromJson(e)).toList();
  }
}
