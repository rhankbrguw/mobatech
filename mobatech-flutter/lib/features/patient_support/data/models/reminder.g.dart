// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Reminder _$ReminderFromJson(Map<String, dynamic> json) => _Reminder(
  id: json['id'] as String,
  title: json['title'] as String,
  message: json['message'] as String,
  dateTime: json['date_time'] as String,
  type: json['type'] as String,
  isRead: json['is_read'] as bool? ?? false,
);

Map<String, dynamic> _$ReminderToJson(_Reminder instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'message': instance.message,
  'date_time': instance.dateTime,
  'type': instance.type,
  'is_read': _isReadToJson(instance.isRead),
};
