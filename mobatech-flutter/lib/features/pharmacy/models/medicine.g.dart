// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Medicine _$MedicineFromJson(Map<String, dynamic> json) => _Medicine(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  genericName: json['generic_name'] as String? ?? '',
  price: (json['price'] as num).toDouble(),
  stock: (json['stock'] as num?)?.toInt() ?? 0,
  requiresPrescription: json['requires_prescription'] as bool? ?? false,
  imageUrl: json['image_url'] as String,
  category: json['category'] == null
      ? null
      : MedicineCategory.fromJson(json['category'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MedicineToJson(_Medicine instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'generic_name': instance.genericName,
  'price': instance.price,
  'stock': instance.stock,
  'requires_prescription': instance.requiresPrescription,
  'image_url': instance.imageUrl,
  'category': instance.category,
};
