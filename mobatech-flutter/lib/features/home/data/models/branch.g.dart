// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Branch _$BranchFromJson(Map<String, dynamic> json) => _Branch(
  id: (json['ID'] as num?)?.toInt() ?? 0,
  name: json['name'] as String? ?? '',
  address: json['address'] as String? ?? '',
  latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
  longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
  imageUrl: json['image_url'] as String? ?? '',
  gmapsLink: json['gmaps_link'] as String? ?? '',
);

Map<String, dynamic> _$BranchToJson(_Branch instance) => <String, dynamic>{
  'ID': instance.id,
  'name': instance.name,
  'address': instance.address,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'image_url': instance.imageUrl,
  'gmaps_link': instance.gmapsLink,
};
