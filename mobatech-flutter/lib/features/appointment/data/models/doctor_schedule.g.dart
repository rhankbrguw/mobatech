// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DoctorSchedule _$DoctorScheduleFromJson(Map<String, dynamic> json) =>
    _DoctorSchedule(
      id: (json['ID'] as num?)?.toInt() ?? 0,
      doctorId: (json['doctor_id'] as num?)?.toInt() ?? 0,
      date: json['date'] == null
          ? null
          : DateTime.parse(json['date'] as String),
      startTime: json['start_time'] as String? ?? '',
      endTime: json['end_time'] as String? ?? '',
      quota: (json['quota'] as num?)?.toInt() ?? 0,
      booked: (json['booked'] as num?)?.toInt() ?? 0,
      isAvailable: json['is_available'] as bool? ?? true,
    );

Map<String, dynamic> _$DoctorScheduleToJson(_DoctorSchedule instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'doctor_id': instance.doctorId,
      'date': instance.date?.toIso8601String(),
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'quota': instance.quota,
      'booked': instance.booked,
      'is_available': instance.isAvailable,
    };
