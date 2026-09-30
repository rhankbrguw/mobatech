// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'polyclinic.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PolyclinicSchedule {

@JsonKey(name: 'ID') int get id;@JsonKey(name: 'polyclinic_id') int get polyclinicId;@JsonKey(name: 'day_of_week') String get dayOfWeek;@JsonKey(name: 'start_time') String get startTime;@JsonKey(name: 'end_time') String get endTime;@JsonKey(name: 'is_available') bool get isAvailable;
/// Create a copy of PolyclinicSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PolyclinicScheduleCopyWith<PolyclinicSchedule> get copyWith => _$PolyclinicScheduleCopyWithImpl<PolyclinicSchedule>(this as PolyclinicSchedule, _$identity);

  /// Serializes this PolyclinicSchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PolyclinicSchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.polyclinicId, polyclinicId) || other.polyclinicId == polyclinicId)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,polyclinicId,dayOfWeek,startTime,endTime,isAvailable);

@override
String toString() {
  return 'PolyclinicSchedule(id: $id, polyclinicId: $polyclinicId, dayOfWeek: $dayOfWeek, startTime: $startTime, endTime: $endTime, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class $PolyclinicScheduleCopyWith<$Res>  {
  factory $PolyclinicScheduleCopyWith(PolyclinicSchedule value, $Res Function(PolyclinicSchedule) _then) = _$PolyclinicScheduleCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'ID') int id,@JsonKey(name: 'polyclinic_id') int polyclinicId,@JsonKey(name: 'day_of_week') String dayOfWeek,@JsonKey(name: 'start_time') String startTime,@JsonKey(name: 'end_time') String endTime,@JsonKey(name: 'is_available') bool isAvailable
});




}
/// @nodoc
class _$PolyclinicScheduleCopyWithImpl<$Res>
    implements $PolyclinicScheduleCopyWith<$Res> {
  _$PolyclinicScheduleCopyWithImpl(this._self, this._then);

  final PolyclinicSchedule _self;
  final $Res Function(PolyclinicSchedule) _then;

/// Create a copy of PolyclinicSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? polyclinicId = null,Object? dayOfWeek = null,Object? startTime = null,Object? endTime = null,Object? isAvailable = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,polyclinicId: null == polyclinicId ? _self.polyclinicId : polyclinicId // ignore: cast_nullable_to_non_nullable
as int,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PolyclinicSchedule].
extension PolyclinicSchedulePatterns on PolyclinicSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PolyclinicSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PolyclinicSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PolyclinicSchedule value)  $default,){
final _that = this;
switch (_that) {
case _PolyclinicSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PolyclinicSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _PolyclinicSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'ID')  int id, @JsonKey(name: 'polyclinic_id')  int polyclinicId, @JsonKey(name: 'day_of_week')  String dayOfWeek, @JsonKey(name: 'start_time')  String startTime, @JsonKey(name: 'end_time')  String endTime, @JsonKey(name: 'is_available')  bool isAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PolyclinicSchedule() when $default != null:
return $default(_that.id,_that.polyclinicId,_that.dayOfWeek,_that.startTime,_that.endTime,_that.isAvailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'ID')  int id, @JsonKey(name: 'polyclinic_id')  int polyclinicId, @JsonKey(name: 'day_of_week')  String dayOfWeek, @JsonKey(name: 'start_time')  String startTime, @JsonKey(name: 'end_time')  String endTime, @JsonKey(name: 'is_available')  bool isAvailable)  $default,) {final _that = this;
switch (_that) {
case _PolyclinicSchedule():
return $default(_that.id,_that.polyclinicId,_that.dayOfWeek,_that.startTime,_that.endTime,_that.isAvailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'ID')  int id, @JsonKey(name: 'polyclinic_id')  int polyclinicId, @JsonKey(name: 'day_of_week')  String dayOfWeek, @JsonKey(name: 'start_time')  String startTime, @JsonKey(name: 'end_time')  String endTime, @JsonKey(name: 'is_available')  bool isAvailable)?  $default,) {final _that = this;
switch (_that) {
case _PolyclinicSchedule() when $default != null:
return $default(_that.id,_that.polyclinicId,_that.dayOfWeek,_that.startTime,_that.endTime,_that.isAvailable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PolyclinicSchedule implements PolyclinicSchedule {
  const _PolyclinicSchedule({@JsonKey(name: 'ID') this.id = 0, @JsonKey(name: 'polyclinic_id') this.polyclinicId = 0, @JsonKey(name: 'day_of_week') this.dayOfWeek = '', @JsonKey(name: 'start_time') this.startTime = '', @JsonKey(name: 'end_time') this.endTime = '', @JsonKey(name: 'is_available') this.isAvailable = false});
  factory _PolyclinicSchedule.fromJson(Map<String, dynamic> json) => _$PolyclinicScheduleFromJson(json);

@override@JsonKey(name: 'ID') final  int id;
@override@JsonKey(name: 'polyclinic_id') final  int polyclinicId;
@override@JsonKey(name: 'day_of_week') final  String dayOfWeek;
@override@JsonKey(name: 'start_time') final  String startTime;
@override@JsonKey(name: 'end_time') final  String endTime;
@override@JsonKey(name: 'is_available') final  bool isAvailable;

/// Create a copy of PolyclinicSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PolyclinicScheduleCopyWith<_PolyclinicSchedule> get copyWith => __$PolyclinicScheduleCopyWithImpl<_PolyclinicSchedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PolyclinicScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PolyclinicSchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.polyclinicId, polyclinicId) || other.polyclinicId == polyclinicId)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,polyclinicId,dayOfWeek,startTime,endTime,isAvailable);

@override
String toString() {
  return 'PolyclinicSchedule(id: $id, polyclinicId: $polyclinicId, dayOfWeek: $dayOfWeek, startTime: $startTime, endTime: $endTime, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class _$PolyclinicScheduleCopyWith<$Res> implements $PolyclinicScheduleCopyWith<$Res> {
  factory _$PolyclinicScheduleCopyWith(_PolyclinicSchedule value, $Res Function(_PolyclinicSchedule) _then) = __$PolyclinicScheduleCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'ID') int id,@JsonKey(name: 'polyclinic_id') int polyclinicId,@JsonKey(name: 'day_of_week') String dayOfWeek,@JsonKey(name: 'start_time') String startTime,@JsonKey(name: 'end_time') String endTime,@JsonKey(name: 'is_available') bool isAvailable
});




}
/// @nodoc
class __$PolyclinicScheduleCopyWithImpl<$Res>
    implements _$PolyclinicScheduleCopyWith<$Res> {
  __$PolyclinicScheduleCopyWithImpl(this._self, this._then);

  final _PolyclinicSchedule _self;
  final $Res Function(_PolyclinicSchedule) _then;

/// Create a copy of PolyclinicSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? polyclinicId = null,Object? dayOfWeek = null,Object? startTime = null,Object? endTime = null,Object? isAvailable = null,}) {
  return _then(_PolyclinicSchedule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,polyclinicId: null == polyclinicId ? _self.polyclinicId : polyclinicId // ignore: cast_nullable_to_non_nullable
as int,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Polyclinic {

@JsonKey(name: 'ID') int get id; String get name; String get description;@JsonKey(name: 'image_url') String get imageUrl;@JsonKey(name: 'is_active') bool get isActive; List<PolyclinicSchedule> get schedules;
/// Create a copy of Polyclinic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PolyclinicCopyWith<Polyclinic> get copyWith => _$PolyclinicCopyWithImpl<Polyclinic>(this as Polyclinic, _$identity);

  /// Serializes this Polyclinic to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Polyclinic&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other.schedules, schedules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,imageUrl,isActive,const DeepCollectionEquality().hash(schedules));

@override
String toString() {
  return 'Polyclinic(id: $id, name: $name, description: $description, imageUrl: $imageUrl, isActive: $isActive, schedules: $schedules)';
}


}

/// @nodoc
abstract mixin class $PolyclinicCopyWith<$Res>  {
  factory $PolyclinicCopyWith(Polyclinic value, $Res Function(Polyclinic) _then) = _$PolyclinicCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'ID') int id, String name, String description,@JsonKey(name: 'image_url') String imageUrl,@JsonKey(name: 'is_active') bool isActive, List<PolyclinicSchedule> schedules
});




}
/// @nodoc
class _$PolyclinicCopyWithImpl<$Res>
    implements $PolyclinicCopyWith<$Res> {
  _$PolyclinicCopyWithImpl(this._self, this._then);

  final Polyclinic _self;
  final $Res Function(Polyclinic) _then;

/// Create a copy of Polyclinic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? imageUrl = null,Object? isActive = null,Object? schedules = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,schedules: null == schedules ? _self.schedules : schedules // ignore: cast_nullable_to_non_nullable
as List<PolyclinicSchedule>,
  ));
}

}


/// Adds pattern-matching-related methods to [Polyclinic].
extension PolyclinicPatterns on Polyclinic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Polyclinic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Polyclinic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Polyclinic value)  $default,){
final _that = this;
switch (_that) {
case _Polyclinic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Polyclinic value)?  $default,){
final _that = this;
switch (_that) {
case _Polyclinic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'ID')  int id,  String name,  String description, @JsonKey(name: 'image_url')  String imageUrl, @JsonKey(name: 'is_active')  bool isActive,  List<PolyclinicSchedule> schedules)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Polyclinic() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.imageUrl,_that.isActive,_that.schedules);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'ID')  int id,  String name,  String description, @JsonKey(name: 'image_url')  String imageUrl, @JsonKey(name: 'is_active')  bool isActive,  List<PolyclinicSchedule> schedules)  $default,) {final _that = this;
switch (_that) {
case _Polyclinic():
return $default(_that.id,_that.name,_that.description,_that.imageUrl,_that.isActive,_that.schedules);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'ID')  int id,  String name,  String description, @JsonKey(name: 'image_url')  String imageUrl, @JsonKey(name: 'is_active')  bool isActive,  List<PolyclinicSchedule> schedules)?  $default,) {final _that = this;
switch (_that) {
case _Polyclinic() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.imageUrl,_that.isActive,_that.schedules);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Polyclinic extends Polyclinic {
  const _Polyclinic({@JsonKey(name: 'ID') this.id = 0, this.name = '', this.description = '', @JsonKey(name: 'image_url') this.imageUrl = '', @JsonKey(name: 'is_active') this.isActive = false, final  List<PolyclinicSchedule> schedules = const []}): _schedules = schedules,super._();
  factory _Polyclinic.fromJson(Map<String, dynamic> json) => _$PolyclinicFromJson(json);

@override@JsonKey(name: 'ID') final  int id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String description;
@override@JsonKey(name: 'image_url') final  String imageUrl;
@override@JsonKey(name: 'is_active') final  bool isActive;
 final  List<PolyclinicSchedule> _schedules;
@override@JsonKey() List<PolyclinicSchedule> get schedules {
  if (_schedules is EqualUnmodifiableListView) return _schedules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_schedules);
}


/// Create a copy of Polyclinic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PolyclinicCopyWith<_Polyclinic> get copyWith => __$PolyclinicCopyWithImpl<_Polyclinic>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PolyclinicToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Polyclinic&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other._schedules, _schedules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,imageUrl,isActive,const DeepCollectionEquality().hash(_schedules));

@override
String toString() {
  return 'Polyclinic(id: $id, name: $name, description: $description, imageUrl: $imageUrl, isActive: $isActive, schedules: $schedules)';
}


}

/// @nodoc
abstract mixin class _$PolyclinicCopyWith<$Res> implements $PolyclinicCopyWith<$Res> {
  factory _$PolyclinicCopyWith(_Polyclinic value, $Res Function(_Polyclinic) _then) = __$PolyclinicCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'ID') int id, String name, String description,@JsonKey(name: 'image_url') String imageUrl,@JsonKey(name: 'is_active') bool isActive, List<PolyclinicSchedule> schedules
});




}
/// @nodoc
class __$PolyclinicCopyWithImpl<$Res>
    implements _$PolyclinicCopyWith<$Res> {
  __$PolyclinicCopyWithImpl(this._self, this._then);

  final _Polyclinic _self;
  final $Res Function(_Polyclinic) _then;

/// Create a copy of Polyclinic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? imageUrl = null,Object? isActive = null,Object? schedules = null,}) {
  return _then(_Polyclinic(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,schedules: null == schedules ? _self._schedules : schedules // ignore: cast_nullable_to_non_nullable
as List<PolyclinicSchedule>,
  ));
}


}

// dart format on
