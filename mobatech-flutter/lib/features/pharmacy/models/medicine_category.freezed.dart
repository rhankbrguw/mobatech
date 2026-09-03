// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medicine_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedicineCategory {

 int get id; String get name; String get icon;
/// Create a copy of MedicineCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicineCategoryCopyWith<MedicineCategory> get copyWith => _$MedicineCategoryCopyWithImpl<MedicineCategory>(this as MedicineCategory, _$identity);

  /// Serializes this MedicineCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicineCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,icon);

@override
String toString() {
  return 'MedicineCategory(id: $id, name: $name, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $MedicineCategoryCopyWith<$Res>  {
  factory $MedicineCategoryCopyWith(MedicineCategory value, $Res Function(MedicineCategory) _then) = _$MedicineCategoryCopyWithImpl;
@useResult
$Res call({
 int id, String name, String icon
});




}
/// @nodoc
class _$MedicineCategoryCopyWithImpl<$Res>
    implements $MedicineCategoryCopyWith<$Res> {
  _$MedicineCategoryCopyWithImpl(this._self, this._then);

  final MedicineCategory _self;
  final $Res Function(MedicineCategory) _then;

/// Create a copy of MedicineCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? icon = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicineCategory].
extension MedicineCategoryPatterns on MedicineCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicineCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicineCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicineCategory value)  $default,){
final _that = this;
switch (_that) {
case _MedicineCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicineCategory value)?  $default,){
final _that = this;
switch (_that) {
case _MedicineCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String icon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicineCategory() when $default != null:
return $default(_that.id,_that.name,_that.icon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String icon)  $default,) {final _that = this;
switch (_that) {
case _MedicineCategory():
return $default(_that.id,_that.name,_that.icon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String icon)?  $default,) {final _that = this;
switch (_that) {
case _MedicineCategory() when $default != null:
return $default(_that.id,_that.name,_that.icon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicineCategory extends MedicineCategory {
  const _MedicineCategory({required this.id, required this.name, required this.icon}): super._();
  factory _MedicineCategory.fromJson(Map<String, dynamic> json) => _$MedicineCategoryFromJson(json);

@override final  int id;
@override final  String name;
@override final  String icon;

/// Create a copy of MedicineCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicineCategoryCopyWith<_MedicineCategory> get copyWith => __$MedicineCategoryCopyWithImpl<_MedicineCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicineCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicineCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,icon);

@override
String toString() {
  return 'MedicineCategory(id: $id, name: $name, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$MedicineCategoryCopyWith<$Res> implements $MedicineCategoryCopyWith<$Res> {
  factory _$MedicineCategoryCopyWith(_MedicineCategory value, $Res Function(_MedicineCategory) _then) = __$MedicineCategoryCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String icon
});




}
/// @nodoc
class __$MedicineCategoryCopyWithImpl<$Res>
    implements _$MedicineCategoryCopyWith<$Res> {
  __$MedicineCategoryCopyWithImpl(this._self, this._then);

  final _MedicineCategory _self;
  final $Res Function(_MedicineCategory) _then;

/// Create a copy of MedicineCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? icon = null,}) {
  return _then(_MedicineCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
