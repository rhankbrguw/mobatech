// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'polyclinic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PolyclinicSchedule _$PolyclinicScheduleFromJson(Map<String, dynamic> json) =>
    _PolyclinicSchedule(
      id: (json['ID'] as num?)?.toInt() ?? 0,
      polyclinicId: (json['polyclinic_id'] as num?)?.toInt() ?? 0,
      dayOfWeek: json['day_of_week'] as String? ?? '',
      startTime: json['start_time'] as String? ?? '',
      endTime: json['end_time'] as String? ?? '',
      isAvailable: json['is_available'] as bool? ?? false,
    );

Map<String, dynamic> _$PolyclinicScheduleToJson(_PolyclinicSchedule instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'polyclinic_id': instance.polyclinicId,
      'day_of_week': instance.dayOfWeek,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'is_available': instance.isAvailable,
    };

_Polyclinic _$PolyclinicFromJson(Map<String, dynamic> json) => _Polyclinic(
  id: (json['ID'] as num?)?.toInt() ?? 0,
  name: json['name'] as String? ?? '',
  description: json['description'] as String? ?? '',
  imageUrl: json['image_url'] as String? ?? '',
  isActive: json['is_active'] as bool? ?? false,
  schedules:
      (json['schedules'] as List<dynamic>?)
          ?.map((e) => PolyclinicSchedule.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$PolyclinicToJson(_Polyclinic instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'is_active': instance.isActive,
      'schedules': instance.schedules,
    };
