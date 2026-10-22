// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medicine.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Medicine {

 int get id; String get name;@JsonKey(name: 'generic_name') String get genericName; double get price; int get stock;@JsonKey(name: 'requires_prescription') bool get requiresPrescription;@JsonKey(name: 'image_url') String get imageUrl; MedicineCategory? get category;
/// Create a copy of Medicine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicineCopyWith<Medicine> get copyWith => _$MedicineCopyWithImpl<Medicine>(this as Medicine, _$identity);

  /// Serializes this Medicine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Medicine&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.genericName, genericName) || other.genericName == genericName)&&(identical(other.price, price) || other.price == price)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.requiresPrescription, requiresPrescription) || other.requiresPrescription == requiresPrescription)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,genericName,price,stock,requiresPrescription,imageUrl,category);

@override
String toString() {
  return 'Medicine(id: $id, name: $name, genericName: $genericName, price: $price, stock: $stock, requiresPrescription: $requiresPrescription, imageUrl: $imageUrl, category: $category)';
}


}

/// @nodoc
abstract mixin class $MedicineCopyWith<$Res>  {
  factory $MedicineCopyWith(Medicine value, $Res Function(Medicine) _then) = _$MedicineCopyWithImpl;
@useResult
$Res call({
 int id, String name,@JsonKey(name: 'generic_name') String genericName, double price, int stock,@JsonKey(name: 'requires_prescription') bool requiresPrescription,@JsonKey(name: 'image_url') String imageUrl, MedicineCategory? category
});


$MedicineCategoryCopyWith<$Res>? get category;

}
/// @nodoc
class _$MedicineCopyWithImpl<$Res>
    implements $MedicineCopyWith<$Res> {
  _$MedicineCopyWithImpl(this._self, this._then);

  final Medicine _self;
  final $Res Function(Medicine) _then;

/// Create a copy of Medicine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? genericName = null,Object? price = null,Object? stock = null,Object? requiresPrescription = null,Object? imageUrl = null,Object? category = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,genericName: null == genericName ? _self.genericName : genericName // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,requiresPrescription: null == requiresPrescription ? _self.requiresPrescription : requiresPrescription // ignore: cast_nullable_to_non_nullable
as bool,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MedicineCategory?,
  ));
}
/// Create a copy of Medicine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicineCategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $MedicineCategoryCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// Adds pattern-matching-related methods to [Medicine].
extension MedicinePatterns on Medicine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Medicine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Medicine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Medicine value)  $default,){
final _that = this;
switch (_that) {
case _Medicine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Medicine value)?  $default,){
final _that = this;
switch (_that) {
case _Medicine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'generic_name')  String genericName,  double price,  int stock, @JsonKey(name: 'requires_prescription')  bool requiresPrescription, @JsonKey(name: 'image_url')  String imageUrl,  MedicineCategory? category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Medicine() when $default != null:
return $default(_that.id,_that.name,_that.genericName,_that.price,_that.stock,_that.requiresPrescription,_that.imageUrl,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'generic_name')  String genericName,  double price,  int stock, @JsonKey(name: 'requires_prescription')  bool requiresPrescription, @JsonKey(name: 'image_url')  String imageUrl,  MedicineCategory? category)  $default,) {final _that = this;
switch (_that) {
case _Medicine():
return $default(_that.id,_that.name,_that.genericName,_that.price,_that.stock,_that.requiresPrescription,_that.imageUrl,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name, @JsonKey(name: 'generic_name')  String genericName,  double price,  int stock, @JsonKey(name: 'requires_prescription')  bool requiresPrescription, @JsonKey(name: 'image_url')  String imageUrl,  MedicineCategory? category)?  $default,) {final _that = this;
switch (_that) {
case _Medicine() when $default != null:
return $default(_that.id,_that.name,_that.genericName,_that.price,_that.stock,_that.requiresPrescription,_that.imageUrl,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Medicine extends Medicine {
  const _Medicine({required this.id, required this.name, @JsonKey(name: 'generic_name') this.genericName = '', required this.price, this.stock = 0, @JsonKey(name: 'requires_prescription') this.requiresPrescription = false, @JsonKey(name: 'image_url') required this.imageUrl, this.category}): super._();
  factory _Medicine.fromJson(Map<String, dynamic> json) => _$MedicineFromJson(json);

@override final  int id;
@override final  String name;
@override@JsonKey(name: 'generic_name') final  String genericName;
@override final  double price;
@override@JsonKey() final  int stock;
@override@JsonKey(name: 'requires_prescription') final  bool requiresPrescription;
@override@JsonKey(name: 'image_url') final  String imageUrl;
@override final  MedicineCategory? category;

/// Create a copy of Medicine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicineCopyWith<_Medicine> get copyWith => __$MedicineCopyWithImpl<_Medicine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Medicine&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.genericName, genericName) || other.genericName == genericName)&&(identical(other.price, price) || other.price == price)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.requiresPrescription, requiresPrescription) || other.requiresPrescription == requiresPrescription)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,genericName,price,stock,requiresPrescription,imageUrl,category);

@override
String toString() {
  return 'Medicine(id: $id, name: $name, genericName: $genericName, price: $price, stock: $stock, requiresPrescription: $requiresPrescription, imageUrl: $imageUrl, category: $category)';
}


}

/// @nodoc
abstract mixin class _$MedicineCopyWith<$Res> implements $MedicineCopyWith<$Res> {
  factory _$MedicineCopyWith(_Medicine value, $Res Function(_Medicine) _then) = __$MedicineCopyWithImpl;
@override @useResult
$Res call({
 int id, String name,@JsonKey(name: 'generic_name') String genericName, double price, int stock,@JsonKey(name: 'requires_prescription') bool requiresPrescription,@JsonKey(name: 'image_url') String imageUrl, MedicineCategory? category
});


@override $MedicineCategoryCopyWith<$Res>? get category;

}
/// @nodoc
class __$MedicineCopyWithImpl<$Res>
    implements _$MedicineCopyWith<$Res> {
  __$MedicineCopyWithImpl(this._self, this._then);

  final _Medicine _self;
  final $Res Function(_Medicine) _then;

/// Create a copy of Medicine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? genericName = null,Object? price = null,Object? stock = null,Object? requiresPrescription = null,Object? imageUrl = null,Object? category = freezed,}) {
  return _then(_Medicine(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,genericName: null == genericName ? _self.genericName : genericName // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,requiresPrescription: null == requiresPrescription ? _self.requiresPrescription : requiresPrescription // ignore: cast_nullable_to_non_nullable
as bool,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MedicineCategory?,
  ));
}

/// Create a copy of Medicine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicineCategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $MedicineCategoryCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}

// dart format on
