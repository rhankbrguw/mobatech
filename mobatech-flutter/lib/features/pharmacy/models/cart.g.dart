// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItem _$CartItemFromJson(Map<String, dynamic> json) => _CartItem(
  id: (json['id'] as num).toInt(),
  medicine: Medicine.fromJson(json['medicine'] as Map<String, dynamic>),
  quantity: (json['quantity'] as num).toInt(),
  totalPrice: (json['total_price'] as num).toDouble(),
);

Map<String, dynamic> _$CartItemToJson(_CartItem instance) => <String, dynamic>{
  'id': instance.id,
  'medicine': instance.medicine,
  'quantity': instance.quantity,
  'total_price': instance.totalPrice,
};

_Cart _$CartFromJson(Map<String, dynamic> json) => _Cart(
  items: (json['items'] as List<dynamic>)
      .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalPrice: (json['total_price'] as num).toDouble(),
);

Map<String, dynamic> _$CartToJson(_Cart instance) => <String, dynamic>{
  'items': instance.items,
  'total_price': instance.totalPrice,
};
