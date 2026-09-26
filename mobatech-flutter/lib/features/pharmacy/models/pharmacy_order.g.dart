// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharmacy_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => _OrderItem(
  medicine: Medicine.fromJson(json['medicine'] as Map<String, dynamic>),
  quantity: (json['quantity'] as num?)?.toInt() ?? 1,
  price: (json['price'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$OrderItemToJson(_OrderItem instance) =>
    <String, dynamic>{
      'medicine': instance.medicine,
      'quantity': instance.quantity,
      'price': instance.price,
    };

_PharmacyOrder _$PharmacyOrderFromJson(Map<String, dynamic> json) =>
    _PharmacyOrder(
      id: (json['id'] as num).toInt(),
      orderNumber: json['order_number'] as String? ?? '',
      status: json['status'] as String? ?? '',
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['payment_method'] as String? ?? '',
      pickupMethod: json['pickup_method'] as String? ?? '',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PharmacyOrderToJson(_PharmacyOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_number': instance.orderNumber,
      'status': instance.status,
      'total_price': instance.totalPrice,
      'payment_method': instance.paymentMethod,
      'pickup_method': instance.pickupMethod,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'items': instance.items,
    };
