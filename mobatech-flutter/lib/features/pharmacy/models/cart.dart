import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/constants/strings/pharmacy_strings.dart';
import 'medicine.dart';

part 'cart.freezed.dart';
part 'cart.g.dart';

@freezed
abstract class CartItem with _$CartItem {
  const CartItem._();

  const factory CartItem({
    required int id,
    required Medicine medicine,
    required int quantity,
    @JsonKey(name: 'total_price') required double totalPrice,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
  static CartItem fromBackendJson(Map<String, dynamic> json) =>
      CartItem.fromJson(_mapJson(json));

  Map<String, dynamic> toSafeJson() {
    final json = toJson();
    json['medicine'] = medicine.toSafeJson();
    return json;
  }

  static Map<String, dynamic> _mapJson(Map<String, dynamic> json) {
    final Map<String, dynamic> fallbackMed = {
      'id': 0,
      'name': PharmacyStrings.deletedMedicine,
      'price': 0.0,
      'image_url': '',
    };
    final medJson = json['medicine'] as Map<String, dynamic>? ?? fallbackMed;
    final med = Medicine.fromBackendJson(medJson);
    final qty = json['quantity'] as int;

    final modifiedJson = Map<String, dynamic>.from(json);
    modifiedJson['id'] = (modifiedJson['ID'] ?? modifiedJson['id']) as int;
    modifiedJson['total_price'] = modifiedJson['total_price'] != null
        ? (modifiedJson['total_price'] as num).toDouble()
        : med.price * qty;
    modifiedJson['medicine'] = med.toSafeJson();

    return modifiedJson;
  }
}

@freezed
abstract class Cart with _$Cart {
  const Cart._();

  const factory Cart({
    required List<CartItem> items,
    @JsonKey(name: 'total_price') required double totalPrice,
  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
  static Cart fromBackendJson(Map<String, dynamic> json) =>
      Cart.fromJson(_mapCartJson(json));

  static Map<String, dynamic> _mapCartJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List? ?? [];
    final cartItems = itemsList
        .map((i) => CartItem.fromBackendJson(i as Map<String, dynamic>))
        .toList();

    double computedTotal = 0.0;
    for (var item in cartItems) {
      computedTotal += item.totalPrice;
    }

    final modifiedJson = Map<String, dynamic>.from(json);
    modifiedJson['items'] = cartItems.map((e) => e.toSafeJson()).toList();
    modifiedJson['total_price'] = modifiedJson['total_price'] != null
        ? (modifiedJson['total_price'] as num).toDouble()
        : computedTotal;

    return modifiedJson;
  }
}
