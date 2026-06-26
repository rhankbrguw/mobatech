import 'package:dio/dio.dart';
import '../models/prescription.dart';


class PrescriptionRepository {
  final Dio _dio;

  PrescriptionRepository(this._dio);

  Future<List<Prescription>> getMyPrescriptions() async {
    try {
      final response = await _dio.get('/pharmacy/prescriptions');
      final data = response.data as List;
      return data.map((e) => Prescription.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> deletePrescription(int id) async {
    await _dio.delete('/pharmacy/prescriptions/$id');
  }
}
