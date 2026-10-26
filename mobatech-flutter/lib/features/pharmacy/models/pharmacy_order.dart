import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/constants/strings/pharmacy_strings.dart';
import 'medicine.dart';

part 'pharmacy_order.freezed.dart';
part 'pharmacy_order.g.dart';

@freezed
abstract class OrderItem with _$OrderItem {
  const OrderItem._();

  const factory OrderItem({
    required Medicine medicine,
    @Default(1) int quantity,
    @Default(0.0) double price,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
  static OrderItem fromBackendJson(Map<String, dynamic> json) =>
      OrderItem.fromJson(_mapJson(json));

  Map<String, dynamic> toSafeJson() {
    final json = toJson();
    json['medicine'] = medicine.toSafeJson();
    return json;
  }

  static Map<String, dynamic> _mapJson(Map<String, dynamic> json) {
    final modifiedJson = Map<String, dynamic>.from(json);
    modifiedJson['quantity'] = modifiedJson['quantity'] as int? ?? 1;
    modifiedJson['price'] = (modifiedJson['price'] as num?)?.toDouble() ?? 0.0;
    if (modifiedJson['medicine'] != null) {
      modifiedJson['medicine'] = Medicine.fromBackendJson(
        modifiedJson['medicine'] as Map<String, dynamic>,
      ).toSafeJson();
    } else {
      modifiedJson['medicine'] = Medicine.fromBackendJson({
        'id': 0,
        'name': PharmacyStrings.deletedMedicine,
        'price': modifiedJson['price'],
        'image_url': '',
      }).toSafeJson();
    }
    return modifiedJson;
  }
}

@freezed
abstract class PharmacyOrder with _$PharmacyOrder {
  const PharmacyOrder._();

  const factory PharmacyOrder({
    required int id,
    @JsonKey(name: 'order_number') @Default('') String orderNumber,
    @Default('') String status,
    @JsonKey(name: 'total_price') @Default(0.0) double totalPrice,
    @JsonKey(name: 'payment_method') @Default('') String paymentMethod,
    @JsonKey(name: 'pickup_method') @Default('') String pickupMethod,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @Default([]) List<OrderItem> items,
  }) = _PharmacyOrder;

  factory PharmacyOrder.fromJson(Map<String, dynamic> json) =>
      _$PharmacyOrderFromJson(json);
  static PharmacyOrder fromBackendJson(Map<String, dynamic> json) =>
      PharmacyOrder.fromJson(_mapOrderJson(json));

  static Map<String, dynamic> _mapOrderJson(Map<String, dynamic> json) {
    final modifiedJson = Map<String, dynamic>.from(json);
    modifiedJson['id'] = (modifiedJson['ID'] ?? modifiedJson['id']) as int;
    modifiedJson['order_number'] =
        modifiedJson['order_number'] as String? ?? '';
    modifiedJson['status'] = modifiedJson['status'] as String? ?? '';
    modifiedJson['total_price'] =
        (modifiedJson['total_price'] as num?)?.toDouble() ?? 0.0;
    modifiedJson['payment_method'] =
        modifiedJson['payment_method'] as String? ?? '';
    modifiedJson['pickup_method'] =
        modifiedJson['pickup_method'] as String? ?? '';

    if (modifiedJson['CreatedAt'] != null ||
        modifiedJson['created_at'] != null) {
      modifiedJson['created_at'] =
          (modifiedJson['CreatedAt'] ?? modifiedJson['created_at']).toString();
    }
    if (modifiedJson['UpdatedAt'] != null ||
        modifiedJson['updated_at'] != null) {
      modifiedJson['updated_at'] =
          (modifiedJson['UpdatedAt'] ?? modifiedJson['updated_at']).toString();
    }

    if (modifiedJson['items'] == null) {
      modifiedJson['items'] = [];
    } else {
      modifiedJson['items'] = (modifiedJson['items'] as List)
          .map(
            (e) => OrderItem.fromBackendJson(
              e as Map<String, dynamic>,
            ).toSafeJson(),
          )
          .toList();
    }

    return modifiedJson;
  }
}
