import 'package:dio/dio.dart';
import '../models/pharmacy_order.dart';

class PharmacyOrderRepository {
  final Dio _dio;

  PharmacyOrderRepository(this._dio);

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> data) async {
    final response = await _dio.post('/pharmacy/orders', data: data);
    return response.data;
  }

  Future<List<PharmacyOrder>> getMyOrders() async {
    final response = await _dio.get('/pharmacy/orders');
    final data = response.data as List;
    return data.map((e) => PharmacyOrder.fromJson(e)).toList();
  }
}
