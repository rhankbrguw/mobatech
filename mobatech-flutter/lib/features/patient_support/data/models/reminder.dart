import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder.freezed.dart';
part 'reminder.g.dart';

int _isReadToJson(bool isRead) => isRead ? 1 : 0;

@freezed
abstract class Reminder with _$Reminder {
  const Reminder._();

  const factory Reminder({
    required String id,
    required String title,
    required String message,
    @JsonKey(name: 'date_time') required String dateTime,
    required String type, // e.g., medication, appointment, result
    @JsonKey(name: 'is_read', toJson: _isReadToJson)
    @Default(false)
    bool isRead,
  }) = _Reminder;

  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);
  static Reminder fromBackendJson(Map<String, dynamic> json) =>
      Reminder.fromJson(_mapJson(json));

  static Map<String, dynamic> _mapJson(Map<String, dynamic> json) {
    final mappedJson = {
      'id': json['id']?.toString() ?? '',
      'title': json['title']?.toString() ?? '',
      'message': json['message']?.toString() ?? '',
      'date_time':
          json['reminder_date']?.toString() ??
          json['date_time']?.toString() ??
          json['dateTime']?.toString() ??
          '',
      'type': json['type']?.toString() ?? '',
      'is_read':
          json['is_read'] == 1 ||
          json['is_read'] == true ||
          json['isRead'] == true,
    };

    return mappedJson;
  }
}
