// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branch.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Branch {

@JsonKey(name: 'ID', defaultValue: 0) int get id;@JsonKey(defaultValue: '') String get name;@JsonKey(defaultValue: '') String get address;@JsonKey(defaultValue: 0.0) double get latitude;@JsonKey(defaultValue: 0.0) double get longitude;@JsonKey(name: 'image_url', defaultValue: '') String get imageUrl;@JsonKey(name: 'gmaps_link', defaultValue: '') String get gmapsLink;
/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BranchCopyWith<Branch> get copyWith => _$BranchCopyWithImpl<Branch>(this as Branch, _$identity);

  /// Serializes this Branch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Branch&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.gmapsLink, gmapsLink) || other.gmapsLink == gmapsLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,latitude,longitude,imageUrl,gmapsLink);

@override
String toString() {
  return 'Branch(id: $id, name: $name, address: $address, latitude: $latitude, longitude: $longitude, imageUrl: $imageUrl, gmapsLink: $gmapsLink)';
}


}

/// @nodoc
abstract mixin class $BranchCopyWith<$Res>  {
  factory $BranchCopyWith(Branch value, $Res Function(Branch) _then) = _$BranchCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'ID', defaultValue: 0) int id,@JsonKey(defaultValue: '') String name,@JsonKey(defaultValue: '') String address,@JsonKey(defaultValue: 0.0) double latitude,@JsonKey(defaultValue: 0.0) double longitude,@JsonKey(name: 'image_url', defaultValue: '') String imageUrl,@JsonKey(name: 'gmaps_link', defaultValue: '') String gmapsLink
});




}
/// @nodoc
class _$BranchCopyWithImpl<$Res>
    implements $BranchCopyWith<$Res> {
  _$BranchCopyWithImpl(this._self, this._then);

  final Branch _self;
  final $Res Function(Branch) _then;

/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = null,Object? latitude = null,Object? longitude = null,Object? imageUrl = null,Object? gmapsLink = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,gmapsLink: null == gmapsLink ? _self.gmapsLink : gmapsLink // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Branch].
extension BranchPatterns on Branch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Branch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Branch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Branch value)  $default,){
final _that = this;
switch (_that) {
case _Branch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Branch value)?  $default,){
final _that = this;
switch (_that) {
case _Branch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'ID', defaultValue: 0)  int id, @JsonKey(defaultValue: '')  String name, @JsonKey(defaultValue: '')  String address, @JsonKey(defaultValue: 0.0)  double latitude, @JsonKey(defaultValue: 0.0)  double longitude, @JsonKey(name: 'image_url', defaultValue: '')  String imageUrl, @JsonKey(name: 'gmaps_link', defaultValue: '')  String gmapsLink)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Branch() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.latitude,_that.longitude,_that.imageUrl,_that.gmapsLink);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'ID', defaultValue: 0)  int id, @JsonKey(defaultValue: '')  String name, @JsonKey(defaultValue: '')  String address, @JsonKey(defaultValue: 0.0)  double latitude, @JsonKey(defaultValue: 0.0)  double longitude, @JsonKey(name: 'image_url', defaultValue: '')  String imageUrl, @JsonKey(name: 'gmaps_link', defaultValue: '')  String gmapsLink)  $default,) {final _that = this;
switch (_that) {
case _Branch():
return $default(_that.id,_that.name,_that.address,_that.latitude,_that.longitude,_that.imageUrl,_that.gmapsLink);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'ID', defaultValue: 0)  int id, @JsonKey(defaultValue: '')  String name, @JsonKey(defaultValue: '')  String address, @JsonKey(defaultValue: 0.0)  double latitude, @JsonKey(defaultValue: 0.0)  double longitude, @JsonKey(name: 'image_url', defaultValue: '')  String imageUrl, @JsonKey(name: 'gmaps_link', defaultValue: '')  String gmapsLink)?  $default,) {final _that = this;
switch (_that) {
case _Branch() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.latitude,_that.longitude,_that.imageUrl,_that.gmapsLink);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Branch implements Branch {
   _Branch({@JsonKey(name: 'ID', defaultValue: 0) required this.id, @JsonKey(defaultValue: '') required this.name, @JsonKey(defaultValue: '') required this.address, @JsonKey(defaultValue: 0.0) required this.latitude, @JsonKey(defaultValue: 0.0) required this.longitude, @JsonKey(name: 'image_url', defaultValue: '') required this.imageUrl, @JsonKey(name: 'gmaps_link', defaultValue: '') required this.gmapsLink});
  factory _Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);

@override@JsonKey(name: 'ID', defaultValue: 0) final  int id;
@override@JsonKey(defaultValue: '') final  String name;
@override@JsonKey(defaultValue: '') final  String address;
@override@JsonKey(defaultValue: 0.0) final  double latitude;
@override@JsonKey(defaultValue: 0.0) final  double longitude;
@override@JsonKey(name: 'image_url', defaultValue: '') final  String imageUrl;
@override@JsonKey(name: 'gmaps_link', defaultValue: '') final  String gmapsLink;

/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BranchCopyWith<_Branch> get copyWith => __$BranchCopyWithImpl<_Branch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BranchToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Branch&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.gmapsLink, gmapsLink) || other.gmapsLink == gmapsLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,latitude,longitude,imageUrl,gmapsLink);

@override
String toString() {
  return 'Branch(id: $id, name: $name, address: $address, latitude: $latitude, longitude: $longitude, imageUrl: $imageUrl, gmapsLink: $gmapsLink)';
}


}

/// @nodoc
abstract mixin class _$BranchCopyWith<$Res> implements $BranchCopyWith<$Res> {
  factory _$BranchCopyWith(_Branch value, $Res Function(_Branch) _then) = __$BranchCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'ID', defaultValue: 0) int id,@JsonKey(defaultValue: '') String name,@JsonKey(defaultValue: '') String address,@JsonKey(defaultValue: 0.0) double latitude,@JsonKey(defaultValue: 0.0) double longitude,@JsonKey(name: 'image_url', defaultValue: '') String imageUrl,@JsonKey(name: 'gmaps_link', defaultValue: '') String gmapsLink
});




}
/// @nodoc
class __$BranchCopyWithImpl<$Res>
    implements _$BranchCopyWith<$Res> {
  __$BranchCopyWithImpl(this._self, this._then);

  final _Branch _self;
  final $Res Function(_Branch) _then;

/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = null,Object? latitude = null,Object? longitude = null,Object? imageUrl = null,Object? gmapsLink = null,}) {
  return _then(_Branch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,gmapsLink: null == gmapsLink ? _self.gmapsLink : gmapsLink // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
