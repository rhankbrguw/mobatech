import 'package:freezed_annotation/freezed_annotation.dart';

part 'doctor_schedule.freezed.dart';
part 'doctor_schedule.g.dart';

@freezed
abstract class DoctorSchedule with _$DoctorSchedule {
  const factory DoctorSchedule({
    @JsonKey(name: 'ID') @Default(0) int id,
    @JsonKey(name: 'doctor_id') @Default(0) int doctorId,
    DateTime? date,
    @JsonKey(name: 'start_time') @Default('') String startTime,
    @JsonKey(name: 'end_time') @Default('') String endTime,
    @Default(0) int quota,
    @Default(0) int booked,
    @JsonKey(name: 'is_available') @Default(true) bool isAvailable,
  }) = _DoctorSchedule;

  factory DoctorSchedule.fromJson(Map<String, dynamic> json) =>
      _$DoctorScheduleFromJson(json);
}
