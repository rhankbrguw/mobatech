// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pharmacy_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderItem {

 Medicine get medicine; int get quantity; double get price;
/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderItemCopyWith<OrderItem> get copyWith => _$OrderItemCopyWithImpl<OrderItem>(this as OrderItem, _$identity);

  /// Serializes this OrderItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderItem&&(identical(other.medicine, medicine) || other.medicine == medicine)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicine,quantity,price);

@override
String toString() {
  return 'OrderItem(medicine: $medicine, quantity: $quantity, price: $price)';
}


}

/// @nodoc
abstract mixin class $OrderItemCopyWith<$Res>  {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) _then) = _$OrderItemCopyWithImpl;
@useResult
$Res call({
 Medicine medicine, int quantity, double price
});


$MedicineCopyWith<$Res> get medicine;

}
/// @nodoc
class _$OrderItemCopyWithImpl<$Res>
    implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._self, this._then);

  final OrderItem _self;
  final $Res Function(OrderItem) _then;

/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicine = null,Object? quantity = null,Object? price = null,}) {
  return _then(_self.copyWith(
medicine: null == medicine ? _self.medicine : medicine // ignore: cast_nullable_to_non_nullable
as Medicine,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicineCopyWith<$Res> get medicine {
  
  return $MedicineCopyWith<$Res>(_self.medicine, (value) {
    return _then(_self.copyWith(medicine: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderItem].
extension OrderItemPatterns on OrderItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderItem value)  $default,){
final _that = this;
switch (_that) {
case _OrderItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderItem value)?  $default,){
final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Medicine medicine,  int quantity,  double price)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
return $default(_that.medicine,_that.quantity,_that.price);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Medicine medicine,  int quantity,  double price)  $default,) {final _that = this;
switch (_that) {
case _OrderItem():
return $default(_that.medicine,_that.quantity,_that.price);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Medicine medicine,  int quantity,  double price)?  $default,) {final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
return $default(_that.medicine,_that.quantity,_that.price);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderItem extends OrderItem {
  const _OrderItem({required this.medicine, this.quantity = 1, this.price = 0.0}): super._();
  factory _OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);

@override final  Medicine medicine;
@override@JsonKey() final  int quantity;
@override@JsonKey() final  double price;

/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderItemCopyWith<_OrderItem> get copyWith => __$OrderItemCopyWithImpl<_OrderItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderItem&&(identical(other.medicine, medicine) || other.medicine == medicine)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicine,quantity,price);

@override
String toString() {
  return 'OrderItem(medicine: $medicine, quantity: $quantity, price: $price)';
}


}

/// @nodoc
abstract mixin class _$OrderItemCopyWith<$Res> implements $OrderItemCopyWith<$Res> {
  factory _$OrderItemCopyWith(_OrderItem value, $Res Function(_OrderItem) _then) = __$OrderItemCopyWithImpl;
@override @useResult
$Res call({
 Medicine medicine, int quantity, double price
});


@override $MedicineCopyWith<$Res> get medicine;

}
/// @nodoc
class __$OrderItemCopyWithImpl<$Res>
    implements _$OrderItemCopyWith<$Res> {
  __$OrderItemCopyWithImpl(this._self, this._then);

  final _OrderItem _self;
  final $Res Function(_OrderItem) _then;

/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicine = null,Object? quantity = null,Object? price = null,}) {
  return _then(_OrderItem(
medicine: null == medicine ? _self.medicine : medicine // ignore: cast_nullable_to_non_nullable
as Medicine,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicineCopyWith<$Res> get medicine {
  
  return $MedicineCopyWith<$Res>(_self.medicine, (value) {
    return _then(_self.copyWith(medicine: value));
  });
}
}


/// @nodoc
mixin _$PharmacyOrder {

 int get id;@JsonKey(name: 'order_number') String get orderNumber; String get status;@JsonKey(name: 'total_price') double get totalPrice;@JsonKey(name: 'payment_method') String get paymentMethod;@JsonKey(name: 'pickup_method') String get pickupMethod;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt; List<OrderItem> get items;
/// Create a copy of PharmacyOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PharmacyOrderCopyWith<PharmacyOrder> get copyWith => _$PharmacyOrderCopyWithImpl<PharmacyOrder>(this as PharmacyOrder, _$identity);

  /// Serializes this PharmacyOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PharmacyOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.pickupMethod, pickupMethod) || other.pickupMethod == pickupMethod)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderNumber,status,totalPrice,paymentMethod,pickupMethod,createdAt,updatedAt,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'PharmacyOrder(id: $id, orderNumber: $orderNumber, status: $status, totalPrice: $totalPrice, paymentMethod: $paymentMethod, pickupMethod: $pickupMethod, createdAt: $createdAt, updatedAt: $updatedAt, items: $items)';
}


}

/// @nodoc
abstract mixin class $PharmacyOrderCopyWith<$Res>  {
  factory $PharmacyOrderCopyWith(PharmacyOrder value, $Res Function(PharmacyOrder) _then) = _$PharmacyOrderCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'order_number') String orderNumber, String status,@JsonKey(name: 'total_price') double totalPrice,@JsonKey(name: 'payment_method') String paymentMethod,@JsonKey(name: 'pickup_method') String pickupMethod,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt, List<OrderItem> items
});




}
/// @nodoc
class _$PharmacyOrderCopyWithImpl<$Res>
    implements $PharmacyOrderCopyWith<$Res> {
  _$PharmacyOrderCopyWithImpl(this._self, this._then);

  final PharmacyOrder _self;
  final $Res Function(PharmacyOrder) _then;

/// Create a copy of PharmacyOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderNumber = null,Object? status = null,Object? totalPrice = null,Object? paymentMethod = null,Object? pickupMethod = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,pickupMethod: null == pickupMethod ? _self.pickupMethod : pickupMethod // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [PharmacyOrder].
extension PharmacyOrderPatterns on PharmacyOrder {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PharmacyOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PharmacyOrder() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PharmacyOrder value)  $default,){
final _that = this;
switch (_that) {
case _PharmacyOrder():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PharmacyOrder value)?  $default,){
final _that = this;
switch (_that) {
case _PharmacyOrder() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'order_number')  String orderNumber,  String status, @JsonKey(name: 'total_price')  double totalPrice, @JsonKey(name: 'payment_method')  String paymentMethod, @JsonKey(name: 'pickup_method')  String pickupMethod, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt,  List<OrderItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PharmacyOrder() when $default != null:
return $default(_that.id,_that.orderNumber,_that.status,_that.totalPrice,_that.paymentMethod,_that.pickupMethod,_that.createdAt,_that.updatedAt,_that.items);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'order_number')  String orderNumber,  String status, @JsonKey(name: 'total_price')  double totalPrice, @JsonKey(name: 'payment_method')  String paymentMethod, @JsonKey(name: 'pickup_method')  String pickupMethod, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt,  List<OrderItem> items)  $default,) {final _that = this;
switch (_that) {
case _PharmacyOrder():
return $default(_that.id,_that.orderNumber,_that.status,_that.totalPrice,_that.paymentMethod,_that.pickupMethod,_that.createdAt,_that.updatedAt,_that.items);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'order_number')  String orderNumber,  String status, @JsonKey(name: 'total_price')  double totalPrice, @JsonKey(name: 'payment_method')  String paymentMethod, @JsonKey(name: 'pickup_method')  String pickupMethod, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt,  List<OrderItem> items)?  $default,) {final _that = this;
switch (_that) {
case _PharmacyOrder() when $default != null:
return $default(_that.id,_that.orderNumber,_that.status,_that.totalPrice,_that.paymentMethod,_that.pickupMethod,_that.createdAt,_that.updatedAt,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PharmacyOrder extends PharmacyOrder {
  const _PharmacyOrder({required this.id, @JsonKey(name: 'order_number') this.orderNumber = '', this.status = '', @JsonKey(name: 'total_price') this.totalPrice = 0.0, @JsonKey(name: 'payment_method') this.paymentMethod = '', @JsonKey(name: 'pickup_method') this.pickupMethod = '', @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, final  List<OrderItem> items = const []}): _items = items,super._();
  factory _PharmacyOrder.fromJson(Map<String, dynamic> json) => _$PharmacyOrderFromJson(json);

@override final  int id;
@override@JsonKey(name: 'order_number') final  String orderNumber;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'total_price') final  double totalPrice;
@override@JsonKey(name: 'payment_method') final  String paymentMethod;
@override@JsonKey(name: 'pickup_method') final  String pickupMethod;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;
 final  List<OrderItem> _items;
@override@JsonKey() List<OrderItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of PharmacyOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PharmacyOrderCopyWith<_PharmacyOrder> get copyWith => __$PharmacyOrderCopyWithImpl<_PharmacyOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PharmacyOrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PharmacyOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.pickupMethod, pickupMethod) || other.pickupMethod == pickupMethod)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderNumber,status,totalPrice,paymentMethod,pickupMethod,createdAt,updatedAt,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'PharmacyOrder(id: $id, orderNumber: $orderNumber, status: $status, totalPrice: $totalPrice, paymentMethod: $paymentMethod, pickupMethod: $pickupMethod, createdAt: $createdAt, updatedAt: $updatedAt, items: $items)';
}


}

/// @nodoc
abstract mixin class _$PharmacyOrderCopyWith<$Res> implements $PharmacyOrderCopyWith<$Res> {
  factory _$PharmacyOrderCopyWith(_PharmacyOrder value, $Res Function(_PharmacyOrder) _then) = __$PharmacyOrderCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'order_number') String orderNumber, String status,@JsonKey(name: 'total_price') double totalPrice,@JsonKey(name: 'payment_method') String paymentMethod,@JsonKey(name: 'pickup_method') String pickupMethod,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt, List<OrderItem> items
});




}
/// @nodoc
class __$PharmacyOrderCopyWithImpl<$Res>
    implements _$PharmacyOrderCopyWith<$Res> {
  __$PharmacyOrderCopyWithImpl(this._self, this._then);

  final _PharmacyOrder _self;
  final $Res Function(_PharmacyOrder) _then;

/// Create a copy of PharmacyOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderNumber = null,Object? status = null,Object? totalPrice = null,Object? paymentMethod = null,Object? pickupMethod = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? items = null,}) {
  return _then(_PharmacyOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,pickupMethod: null == pickupMethod ? _self.pickupMethod : pickupMethod // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItem>,
  ));
}


}

// dart format on
