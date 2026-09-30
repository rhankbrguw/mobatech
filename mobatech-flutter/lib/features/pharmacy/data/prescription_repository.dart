import 'package:dio/dio.dart';
import '../../../core/constants/strings/error_strings.dart';
import '../../../core/constants/strings/pharmacy_strings.dart';
import '../models/prescription.dart';

class PrescriptionRepository {
  final Dio _dio;

  PrescriptionRepository(this._dio);

  Future<(List<Prescription>, bool)> getMyPrescriptions({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _dio.get(
      '/pharmacy/prescriptions',
      queryParameters: {'page': page, 'limit': limit},
    );
    final dynamic payload = response.data;
    final List<dynamic> data = payload is Map && payload.containsKey('data')
        ? payload['data']
        : (payload as List? ?? []);

    final meta = payload is Map && payload.containsKey('meta')
        ? payload['meta'] as Map<String, dynamic>?
        : response.extra['meta'] as Map<String, dynamic>?;

    final prescriptions = data
        .map((e) => Prescription.fromBackendJson(e))
        .toList();

    final currentPage = meta?['current_page'] as int? ?? 1;
    final totalPages = meta?['total_pages'] as int? ?? 1;

    return (prescriptions, currentPage < totalPages);
  }

  Future<void> deletePrescription(int id) async {
    await _dio.delete('/pharmacy/prescriptions/$id');
  }

  Future<void> redeemPrescription(int id) async {
    await _dio.post('/pharmacy/prescriptions/$id/redeem');
  }

  Future<String> uploadImage(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final response = await _dio.post('/upload', data: formData);
    final data = response.data;
    if (data is Map && data.containsKey('url')) {
      return data['url'] as String;
    } else if (data is String) {
      return data;
    }
    throw Exception(ErrorStrings.errUploadImageFailed);
  }

  Future<void> createPrescription({
    required String imageUrl,
    String? notes,
  }) async {
    final defaultNotes = notes ?? PharmacyStrings.prescriptionFromCustomer;
    await _dio.post(
      '/pharmacy/prescriptions',
      data: {'image_url': imageUrl, 'notes': defaultNotes},
    );
  }

  Future<void> uploadPrescription(String filePath, {String? notes}) async {
    final defaultNotes = notes ?? PharmacyStrings.prescriptionFromCustomer;
    final imageUrl = await uploadImage(filePath);
    await createPrescription(imageUrl: imageUrl, notes: defaultNotes);
  }
}
