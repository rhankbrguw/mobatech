import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/constants/strings/pharmacy_strings.dart';
import '../../../core/network/dio_client.dart';

part 'prescription.freezed.dart';
part 'prescription.g.dart';

@freezed
abstract class PrescriptionItem with _$PrescriptionItem {
  const PrescriptionItem._();

  const factory PrescriptionItem({
    @JsonKey(name: 'medicine_id') int? medicineId,
    @JsonKey(name: 'medicine_name') required String medicineName,
    @JsonKey(name: 'custom_medicine') required String customMedicine,
    @JsonKey(name: 'dosage_instruction') required String dosageInstruction,
    required String duration,
    required int quantity,
  }) = _PrescriptionItem;

  String get displayName {
    if (medicineName.isNotEmpty) return medicineName;
    if (customMedicine.isNotEmpty) return customMedicine;
    return PharmacyStrings.manualMedicine;
  }

  factory PrescriptionItem.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionItemFromJson(json);
  static PrescriptionItem fromBackendJson(Map<String, dynamic> json) =>
      PrescriptionItem.fromJson(_mapJson(json));

  static Map<String, dynamic> _mapJson(Map<String, dynamic> json) {
    final modifiedJson = Map<String, dynamic>.from(json);

    modifiedJson['medicine_name'] =
        (json['medicine'] != null ? json['medicine']['name'] : '') as String? ??
        '';
    modifiedJson['custom_medicine'] = json['custom_medicine'] as String? ?? '';
    modifiedJson['dosage_instruction'] =
        json['dosage_instruction'] as String? ?? '';
    modifiedJson['duration'] = json['duration'] as String? ?? '';
    modifiedJson['quantity'] = json['quantity'] as int? ?? 1;

    return modifiedJson;
  }
}

@freezed
abstract class Prescription with _$Prescription {
  const Prescription._();

  const factory Prescription({
    required int id,
    @JsonKey(name: 'appointment_id') int? appointmentId,
    @JsonKey(name: 'doctor_name') required String doctorName,
    required String diagnosis,
    required List<PrescriptionItem> items,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'image_url') required String imageUrl,
    required String notes,
    required String status,
    @JsonKey(name: 'CreatedAt') required DateTime createdAt,
  }) = _Prescription;

  factory Prescription.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionFromJson(json);
  static Prescription fromBackendJson(Map<String, dynamic> json) =>
      Prescription.fromJson(_mapPrescriptionJson(json));

  static Map<String, dynamic> _mapPrescriptionJson(Map<String, dynamic> json) {
    String rawImageUrl = json['image_url'] as String? ?? '';
    rawImageUrl = fixImageUrl(rawImageUrl);

    final modifiedJson = Map<String, dynamic>.from(json);
    modifiedJson['id'] = (modifiedJson['ID'] ?? modifiedJson['id']) as int;
    modifiedJson['doctor_name'] = modifiedJson['doctor_name'] as String? ?? '';
    modifiedJson['diagnosis'] = modifiedJson['diagnosis'] as String? ?? '';
    modifiedJson['user_id'] = modifiedJson['user_id'] as int? ?? 0;
    modifiedJson['image_url'] = rawImageUrl;
    modifiedJson['notes'] = modifiedJson['notes'] as String? ?? '';
    modifiedJson['status'] = modifiedJson['status'] as String? ?? 'Active';

    if (modifiedJson['CreatedAt'] != null) {
      modifiedJson['CreatedAt'] = modifiedJson['CreatedAt'].toString();
    } else {
      modifiedJson['CreatedAt'] = DateTime.now().toIso8601String();
    }

    if (modifiedJson['items'] == null) {
      modifiedJson['items'] = [];
    } else {
      modifiedJson['items'] = (modifiedJson['items'] as List)
          .map(
            (e) => PrescriptionItem.fromBackendJson(
              e as Map<String, dynamic>,
            ).toJson(),
          )
          .toList();
    }

    return modifiedJson;
  }
}
