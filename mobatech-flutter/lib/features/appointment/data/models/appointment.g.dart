// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Appointment _$AppointmentFromJson(Map<String, dynamic> json) => _Appointment(
  id: (json['ID'] as num?)?.toInt() ?? 0,
  userId: (json['user_id'] as num?)?.toInt() ?? 0,
  doctorId: (json['doctor_id'] as num?)?.toInt() ?? 0,
  doctorScheduleId: (json['doctor_schedule_id'] as num?)?.toInt() ?? 0,
  status: json['status'] as String? ?? '',
  notes: json['notes'] as String? ?? '',
  doctor: json['doctor'] == null
      ? null
      : Doctor.fromJson(json['doctor'] as Map<String, dynamic>),
  schedule: json['schedule'] == null
      ? null
      : DoctorSchedule.fromJson(json['schedule'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppointmentToJson(_Appointment instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'user_id': instance.userId,
      'doctor_id': instance.doctorId,
      'doctor_schedule_id': instance.doctorScheduleId,
      'status': instance.status,
      'notes': instance.notes,
    };
