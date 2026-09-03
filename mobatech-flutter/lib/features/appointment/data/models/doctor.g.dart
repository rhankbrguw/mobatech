// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Doctor _$DoctorFromJson(Map<String, dynamic> json) => _Doctor(
  id: (json['ID'] as num?)?.toInt() ?? 0,
  userId: (json['user_id'] as num?)?.toInt(),
  polyclinicId: (json['polyclinic_id'] as num?)?.toInt(),
  polyclinicName: json['polyclinic_name'] as String?,
  name: json['name'] as String? ?? '',
  specialization: json['specialization'] as String? ?? '',
  contactInfo: json['contact_info'] as String? ?? '',
  description: json['description'] as String? ?? '',
  imageUrl: json['image_url'] as String? ?? '',
  isActive: json['is_active'] as bool? ?? true,
  isAvailableToday: json['is_available_today'] as bool? ?? false,
);

Map<String, dynamic> _$DoctorToJson(_Doctor instance) => <String, dynamic>{
  'ID': instance.id,
  'user_id': instance.userId,
  'polyclinic_id': instance.polyclinicId,
  'polyclinic_name': instance.polyclinicName,
  'name': instance.name,
  'specialization': instance.specialization,
  'contact_info': instance.contactInfo,
  'description': instance.description,
  'image_url': instance.imageUrl,
  'is_active': instance.isActive,
  'is_available_today': instance.isAvailableToday,
};
