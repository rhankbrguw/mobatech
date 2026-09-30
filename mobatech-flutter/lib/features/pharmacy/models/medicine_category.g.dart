// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MedicineCategory _$MedicineCategoryFromJson(Map<String, dynamic> json) =>
    _MedicineCategory(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$MedicineCategoryToJson(_MedicineCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
    };
