import 'package:freezed_annotation/freezed_annotation.dart';

part 'medical_result.freezed.dart';
part 'medical_result.g.dart';

@freezed
abstract class MedicalResult with _$MedicalResult {
  const MedicalResult._();

  const factory MedicalResult({
    required String id,
    @JsonKey(name: 'test_name') required String testName,
    required String date,
    required String status,
    @JsonKey(name: 'hospital_name') required String hospitalName,
    @JsonKey(name: 'doctor_name') String? doctorName,
    @JsonKey(name: 'result_details') String? resultDetails,
    @JsonKey(name: 'document_url') String? documentUrl,
  }) = _MedicalResult;

  factory MedicalResult.fromJson(Map<String, dynamic> json) =>
      _$MedicalResultFromJson(json);
  static MedicalResult fromBackendJson(Map<String, dynamic> json) =>
      MedicalResult.fromJson(_mapJson(json));

  static Map<String, dynamic> _mapJson(Map<String, dynamic> json) {
    // Kombinasi result dan notes dari backend
    final backendResult = json['result']?.toString() ?? '';
    final backendNotes = json['notes']?.toString() ?? '';
    final combinedDetails = backendResult.isNotEmpty
        ? '$backendResult\n\nCatatan Dokter:\n$backendNotes'
        : json['result_details']?.toString();

    // Format date (Extract YYYY-MM-DD if 'T' is present)
    String dateStr =
        json['result_date']?.toString() ?? json['date']?.toString() ?? '';
    if (dateStr.contains('T')) {
      // Basic formatting, e.g. "2026-06-22T15:22:17Z" -> "22 Jun 2026" (or just keep YYYY-MM-DD)
      final parts = dateStr.split('T')[0].split('-');
      if (parts.length == 3) {
        dateStr = '${parts[2]}-${parts[1]}-${parts[0]}'; // DD-MM-YYYY
      }
    }

    final mappedJson = {
      'id': json['id']?.toString() ?? '',
      'test_name':
          json['test_name']?.toString() ?? json['testName']?.toString() ?? '',
      'date': dateStr,
      'status': json['status']?.toString() ?? 'Selesai',
      'hospital_name':
          json['hospital_name']?.toString() ?? 'RS Hermina Kemayoran',
      'doctor_name':
          json['doctor_name']?.toString() ?? json['doctorName']?.toString(),
      'result_details': combinedDetails,
      'document_url':
          json['file_url']?.toString() ?? json['document_url']?.toString(),
    };

    return mappedJson;
  }
}
