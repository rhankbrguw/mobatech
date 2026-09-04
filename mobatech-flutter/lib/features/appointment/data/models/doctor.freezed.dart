// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'doctor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Doctor {

@JsonKey(name: 'ID') int get id;@JsonKey(name: 'user_id') int? get userId;@JsonKey(name: 'polyclinic_id') int? get polyclinicId;@JsonKey(name: 'polyclinic_name') String? get polyclinicName; String get name; String get specialization;@JsonKey(name: 'contact_info') String get contactInfo; String get description;@JsonKey(name: 'image_url') String get imageUrl;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'is_available_today') bool get isAvailableToday;
/// Create a copy of Doctor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoctorCopyWith<Doctor> get copyWith => _$DoctorCopyWithImpl<Doctor>(this as Doctor, _$identity);

  /// Serializes this Doctor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Doctor&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.polyclinicId, polyclinicId) || other.polyclinicId == polyclinicId)&&(identical(other.polyclinicName, polyclinicName) || other.polyclinicName == polyclinicName)&&(identical(other.name, name) || other.name == name)&&(identical(other.specialization, specialization) || other.specialization == specialization)&&(identical(other.contactInfo, contactInfo) || other.contactInfo == contactInfo)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isAvailableToday, isAvailableToday) || other.isAvailableToday == isAvailableToday));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,polyclinicId,polyclinicName,name,specialization,contactInfo,description,imageUrl,isActive,isAvailableToday);

@override
String toString() {
  return 'Doctor(id: $id, userId: $userId, polyclinicId: $polyclinicId, polyclinicName: $polyclinicName, name: $name, specialization: $specialization, contactInfo: $contactInfo, description: $description, imageUrl: $imageUrl, isActive: $isActive, isAvailableToday: $isAvailableToday)';
}


}

/// @nodoc
abstract mixin class $DoctorCopyWith<$Res>  {
  factory $DoctorCopyWith(Doctor value, $Res Function(Doctor) _then) = _$DoctorCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'ID') int id,@JsonKey(name: 'user_id') int? userId,@JsonKey(name: 'polyclinic_id') int? polyclinicId,@JsonKey(name: 'polyclinic_name') String? polyclinicName, String name, String specialization,@JsonKey(name: 'contact_info') String contactInfo, String description,@JsonKey(name: 'image_url') String imageUrl,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'is_available_today') bool isAvailableToday
});




}
/// @nodoc
class _$DoctorCopyWithImpl<$Res>
    implements $DoctorCopyWith<$Res> {
  _$DoctorCopyWithImpl(this._self, this._then);

  final Doctor _self;
  final $Res Function(Doctor) _then;

/// Create a copy of Doctor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = freezed,Object? polyclinicId = freezed,Object? polyclinicName = freezed,Object? name = null,Object? specialization = null,Object? contactInfo = null,Object? description = null,Object? imageUrl = null,Object? isActive = null,Object? isAvailableToday = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,polyclinicId: freezed == polyclinicId ? _self.polyclinicId : polyclinicId // ignore: cast_nullable_to_non_nullable
as int?,polyclinicName: freezed == polyclinicName ? _self.polyclinicName : polyclinicName // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,specialization: null == specialization ? _self.specialization : specialization // ignore: cast_nullable_to_non_nullable
as String,contactInfo: null == contactInfo ? _self.contactInfo : contactInfo // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isAvailableToday: null == isAvailableToday ? _self.isAvailableToday : isAvailableToday // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Doctor].
extension DoctorPatterns on Doctor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Doctor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Doctor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Doctor value)  $default,){
final _that = this;
switch (_that) {
case _Doctor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Doctor value)?  $default,){
final _that = this;
switch (_that) {
case _Doctor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'ID')  int id, @JsonKey(name: 'user_id')  int? userId, @JsonKey(name: 'polyclinic_id')  int? polyclinicId, @JsonKey(name: 'polyclinic_name')  String? polyclinicName,  String name,  String specialization, @JsonKey(name: 'contact_info')  String contactInfo,  String description, @JsonKey(name: 'image_url')  String imageUrl, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'is_available_today')  bool isAvailableToday)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Doctor() when $default != null:
return $default(_that.id,_that.userId,_that.polyclinicId,_that.polyclinicName,_that.name,_that.specialization,_that.contactInfo,_that.description,_that.imageUrl,_that.isActive,_that.isAvailableToday);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'ID')  int id, @JsonKey(name: 'user_id')  int? userId, @JsonKey(name: 'polyclinic_id')  int? polyclinicId, @JsonKey(name: 'polyclinic_name')  String? polyclinicName,  String name,  String specialization, @JsonKey(name: 'contact_info')  String contactInfo,  String description, @JsonKey(name: 'image_url')  String imageUrl, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'is_available_today')  bool isAvailableToday)  $default,) {final _that = this;
switch (_that) {
case _Doctor():
return $default(_that.id,_that.userId,_that.polyclinicId,_that.polyclinicName,_that.name,_that.specialization,_that.contactInfo,_that.description,_that.imageUrl,_that.isActive,_that.isAvailableToday);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'ID')  int id, @JsonKey(name: 'user_id')  int? userId, @JsonKey(name: 'polyclinic_id')  int? polyclinicId, @JsonKey(name: 'polyclinic_name')  String? polyclinicName,  String name,  String specialization, @JsonKey(name: 'contact_info')  String contactInfo,  String description, @JsonKey(name: 'image_url')  String imageUrl, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'is_available_today')  bool isAvailableToday)?  $default,) {final _that = this;
switch (_that) {
case _Doctor() when $default != null:
return $default(_that.id,_that.userId,_that.polyclinicId,_that.polyclinicName,_that.name,_that.specialization,_that.contactInfo,_that.description,_that.imageUrl,_that.isActive,_that.isAvailableToday);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Doctor extends Doctor {
  const _Doctor({@JsonKey(name: 'ID') this.id = 0, @JsonKey(name: 'user_id') this.userId, @JsonKey(name: 'polyclinic_id') this.polyclinicId, @JsonKey(name: 'polyclinic_name') this.polyclinicName, this.name = '', this.specialization = '', @JsonKey(name: 'contact_info') this.contactInfo = '', this.description = '', @JsonKey(name: 'image_url') this.imageUrl = '', @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'is_available_today') this.isAvailableToday = false}): super._();
  factory _Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);

@override@JsonKey(name: 'ID') final  int id;
@override@JsonKey(name: 'user_id') final  int? userId;
@override@JsonKey(name: 'polyclinic_id') final  int? polyclinicId;
@override@JsonKey(name: 'polyclinic_name') final  String? polyclinicName;
@override@JsonKey() final  String name;
@override@JsonKey() final  String specialization;
@override@JsonKey(name: 'contact_info') final  String contactInfo;
@override@JsonKey() final  String description;
@override@JsonKey(name: 'image_url') final  String imageUrl;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'is_available_today') final  bool isAvailableToday;

/// Create a copy of Doctor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoctorCopyWith<_Doctor> get copyWith => __$DoctorCopyWithImpl<_Doctor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DoctorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Doctor&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.polyclinicId, polyclinicId) || other.polyclinicId == polyclinicId)&&(identical(other.polyclinicName, polyclinicName) || other.polyclinicName == polyclinicName)&&(identical(other.name, name) || other.name == name)&&(identical(other.specialization, specialization) || other.specialization == specialization)&&(identical(other.contactInfo, contactInfo) || other.contactInfo == contactInfo)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isAvailableToday, isAvailableToday) || other.isAvailableToday == isAvailableToday));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,polyclinicId,polyclinicName,name,specialization,contactInfo,description,imageUrl,isActive,isAvailableToday);

@override
String toString() {
  return 'Doctor(id: $id, userId: $userId, polyclinicId: $polyclinicId, polyclinicName: $polyclinicName, name: $name, specialization: $specialization, contactInfo: $contactInfo, description: $description, imageUrl: $imageUrl, isActive: $isActive, isAvailableToday: $isAvailableToday)';
}


}

/// @nodoc
abstract mixin class _$DoctorCopyWith<$Res> implements $DoctorCopyWith<$Res> {
  factory _$DoctorCopyWith(_Doctor value, $Res Function(_Doctor) _then) = __$DoctorCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'ID') int id,@JsonKey(name: 'user_id') int? userId,@JsonKey(name: 'polyclinic_id') int? polyclinicId,@JsonKey(name: 'polyclinic_name') String? polyclinicName, String name, String specialization,@JsonKey(name: 'contact_info') String contactInfo, String description,@JsonKey(name: 'image_url') String imageUrl,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'is_available_today') bool isAvailableToday
});




}
/// @nodoc
class __$DoctorCopyWithImpl<$Res>
    implements _$DoctorCopyWith<$Res> {
  __$DoctorCopyWithImpl(this._self, this._then);

  final _Doctor _self;
  final $Res Function(_Doctor) _then;

/// Create a copy of Doctor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = freezed,Object? polyclinicId = freezed,Object? polyclinicName = freezed,Object? name = null,Object? specialization = null,Object? contactInfo = null,Object? description = null,Object? imageUrl = null,Object? isActive = null,Object? isAvailableToday = null,}) {
  return _then(_Doctor(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,polyclinicId: freezed == polyclinicId ? _self.polyclinicId : polyclinicId // ignore: cast_nullable_to_non_nullable
as int?,polyclinicName: freezed == polyclinicName ? _self.polyclinicName : polyclinicName // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,specialization: null == specialization ? _self.specialization : specialization // ignore: cast_nullable_to_non_nullable
as String,contactInfo: null == contactInfo ? _self.contactInfo : contactInfo // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isAvailableToday: null == isAvailableToday ? _self.isAvailableToday : isAvailableToday // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
