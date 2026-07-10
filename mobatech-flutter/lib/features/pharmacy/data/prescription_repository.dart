import 'package:dio/dio.dart';
import '../models/prescription.dart';

class PrescriptionRepository {
  final Dio _dio;

  PrescriptionRepository(this._dio);

  Future<(List<Prescription>, bool)> getMyPrescriptions({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/pharmacy/prescriptions',
        queryParameters: {'page': page, 'limit': limit},
      );
      final dynamic responseData = response.data;
      final List<dynamic> data =
          responseData is Map && responseData.containsKey('data')
          ? responseData['data']
          : (responseData as List? ?? []);
          
      final meta = responseData is Map && responseData.containsKey('meta')
          ? responseData['meta'] as Map<String, dynamic>?
          : response.extra['meta'] as Map<String, dynamic>?;

      final prescriptions = data.map((e) => Prescription.fromJson(e)).toList();
      
      final currentPage = meta?['current_page'] as int? ?? 1;
      final totalPages = meta?['total_pages'] as int? ?? 1;

      return (prescriptions, currentPage < totalPages);
    } catch (e) {
      return (<Prescription>[], false);
    }
  }

  Future<void> deletePrescription(int id) async {
    await _dio.delete('/pharmacy/prescriptions/$id');
  }
}
