import 'package:freezed_annotation/freezed_annotation.dart';
import 'doctor.dart';
import 'doctor_schedule.dart';

part 'appointment.freezed.dart';
part 'appointment.g.dart';

@freezed
abstract class Appointment with _$Appointment {
  const factory Appointment({
    @JsonKey(name: 'ID') @Default(0) int id,
    @JsonKey(name: 'user_id') @Default(0) int userId,
    @JsonKey(name: 'doctor_id') @Default(0) int doctorId,
    @JsonKey(name: 'doctor_schedule_id') @Default(0) int doctorScheduleId,
    @Default('') String status,
    @Default('') String notes,
    @JsonKey(includeToJson: false) Doctor? doctor,
    @JsonKey(includeToJson: false) DoctorSchedule? schedule,
  }) = _Appointment;

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);
}
