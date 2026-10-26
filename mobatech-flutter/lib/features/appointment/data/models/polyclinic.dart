import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/dio_client.dart';

part 'polyclinic.freezed.dart';
part 'polyclinic.g.dart';

@freezed
abstract class PolyclinicSchedule with _$PolyclinicSchedule {
  const factory PolyclinicSchedule({
    @JsonKey(name: 'ID') @Default(0) int id,
    @JsonKey(name: 'polyclinic_id') @Default(0) int polyclinicId,
    @JsonKey(name: 'day_of_week') @Default('') String dayOfWeek,
    @JsonKey(name: 'start_time') @Default('') String startTime,
    @JsonKey(name: 'end_time') @Default('') String endTime,
    @JsonKey(name: 'is_available') @Default(false) bool isAvailable,
  }) = _PolyclinicSchedule;

  factory PolyclinicSchedule.fromJson(Map<String, dynamic> json) =>
      _$PolyclinicScheduleFromJson(json);
}

@freezed
abstract class Polyclinic with _$Polyclinic {
  const Polyclinic._();

  const factory Polyclinic({
    @JsonKey(name: 'ID') @Default(0) int id,
    @Default('') String name,
    @Default('') String description,
    @JsonKey(name: 'image_url') @Default('') String imageUrl,
    @JsonKey(name: 'is_active') @Default(false) bool isActive,
    @Default([]) List<PolyclinicSchedule> schedules,
  }) = _Polyclinic;

  factory Polyclinic.fromJson(Map<String, dynamic> json) =>
      _$PolyclinicFromJson(json);

  static Polyclinic fromBackendJson(Map<String, dynamic> json) {
    String rawImageUrl = json['image_url'] ?? '';
    rawImageUrl = fixImageUrl(rawImageUrl);

    return Polyclinic.fromJson({...json, 'image_url': rawImageUrl});
  }
}
