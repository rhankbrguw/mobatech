import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/dio_client.dart';

part 'doctor.freezed.dart';
part 'doctor.g.dart';

@freezed
abstract class Doctor with _$Doctor {
  const Doctor._();

  const factory Doctor({
    @JsonKey(name: 'ID') @Default(0) int id,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'polyclinic_id') int? polyclinicId,
    @JsonKey(name: 'polyclinic_name') String? polyclinicName,
    @Default('') String name,
    @Default('') String specialization,
    @JsonKey(name: 'contact_info') @Default('') String contactInfo,
    @Default('') String description,
    @JsonKey(name: 'image_url') @Default('') String imageUrl,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'is_available_today') @Default(false) bool isAvailableToday,
  }) = _Doctor;

  factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);

  static Doctor fromBackendJson(Map<String, dynamic> json) {
    final poly = json['polyclinic'];
    String rawImageUrl = json['image_url'] ?? '';
    rawImageUrl = fixImageUrl(rawImageUrl);

    return Doctor.fromJson({
      ...json,
      'polyclinic_name': poly is Map<String, dynamic> ? poly['name'] : null,
      'image_url': rawImageUrl,
    });
  }
}
