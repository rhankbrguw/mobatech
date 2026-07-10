import 'package:dio/dio.dart';
import '../models/pharmacy_order.dart';

class PharmacyOrderRepository {
  final Dio _dio;

  PharmacyOrderRepository(this._dio);

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> data) async {
    final response = await _dio.post('/pharmacy/orders', data: data);
    return response.data;
  }

  Future<(List<PharmacyOrder>, bool)> getMyOrders({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _dio.get(
      '/pharmacy/orders',
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

    final orders = data.map((e) => PharmacyOrder.fromJson(e)).toList();
    
    final currentPage = meta?['current_page'] as int? ?? 1;
    final totalPages = meta?['total_pages'] as int? ?? 1;

    return (orders, currentPage < totalPages);
  }
}

