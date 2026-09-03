// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'doctor_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DoctorSchedule {

@JsonKey(name: 'ID') int get id;@JsonKey(name: 'doctor_id') int get doctorId; DateTime? get date;@JsonKey(name: 'start_time') String get startTime;@JsonKey(name: 'end_time') String get endTime; int get quota; int get booked;@JsonKey(name: 'is_available') bool get isAvailable;
/// Create a copy of DoctorSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoctorScheduleCopyWith<DoctorSchedule> get copyWith => _$DoctorScheduleCopyWithImpl<DoctorSchedule>(this as DoctorSchedule, _$identity);

  /// Serializes this DoctorSchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoctorSchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.doctorId, doctorId) || other.doctorId == doctorId)&&(identical(other.date, date) || other.date == date)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.quota, quota) || other.quota == quota)&&(identical(other.booked, booked) || other.booked == booked)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,doctorId,date,startTime,endTime,quota,booked,isAvailable);

@override
String toString() {
  return 'DoctorSchedule(id: $id, doctorId: $doctorId, date: $date, startTime: $startTime, endTime: $endTime, quota: $quota, booked: $booked, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class $DoctorScheduleCopyWith<$Res>  {
  factory $DoctorScheduleCopyWith(DoctorSchedule value, $Res Function(DoctorSchedule) _then) = _$DoctorScheduleCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'ID') int id,@JsonKey(name: 'doctor_id') int doctorId, DateTime? date,@JsonKey(name: 'start_time') String startTime,@JsonKey(name: 'end_time') String endTime, int quota, int booked,@JsonKey(name: 'is_available') bool isAvailable
});




}
/// @nodoc
class _$DoctorScheduleCopyWithImpl<$Res>
    implements $DoctorScheduleCopyWith<$Res> {
  _$DoctorScheduleCopyWithImpl(this._self, this._then);

  final DoctorSchedule _self;
  final $Res Function(DoctorSchedule) _then;

/// Create a copy of DoctorSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? doctorId = null,Object? date = freezed,Object? startTime = null,Object? endTime = null,Object? quota = null,Object? booked = null,Object? isAvailable = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,doctorId: null == doctorId ? _self.doctorId : doctorId // ignore: cast_nullable_to_non_nullable
as int,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,quota: null == quota ? _self.quota : quota // ignore: cast_nullable_to_non_nullable
as int,booked: null == booked ? _self.booked : booked // ignore: cast_nullable_to_non_nullable
as int,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DoctorSchedule].
extension DoctorSchedulePatterns on DoctorSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DoctorSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DoctorSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DoctorSchedule value)  $default,){
final _that = this;
switch (_that) {
case _DoctorSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DoctorSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _DoctorSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'ID')  int id, @JsonKey(name: 'doctor_id')  int doctorId,  DateTime? date, @JsonKey(name: 'start_time')  String startTime, @JsonKey(name: 'end_time')  String endTime,  int quota,  int booked, @JsonKey(name: 'is_available')  bool isAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DoctorSchedule() when $default != null:
return $default(_that.id,_that.doctorId,_that.date,_that.startTime,_that.endTime,_that.quota,_that.booked,_that.isAvailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'ID')  int id, @JsonKey(name: 'doctor_id')  int doctorId,  DateTime? date, @JsonKey(name: 'start_time')  String startTime, @JsonKey(name: 'end_time')  String endTime,  int quota,  int booked, @JsonKey(name: 'is_available')  bool isAvailable)  $default,) {final _that = this;
switch (_that) {
case _DoctorSchedule():
return $default(_that.id,_that.doctorId,_that.date,_that.startTime,_that.endTime,_that.quota,_that.booked,_that.isAvailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'ID')  int id, @JsonKey(name: 'doctor_id')  int doctorId,  DateTime? date, @JsonKey(name: 'start_time')  String startTime, @JsonKey(name: 'end_time')  String endTime,  int quota,  int booked, @JsonKey(name: 'is_available')  bool isAvailable)?  $default,) {final _that = this;
switch (_that) {
case _DoctorSchedule() when $default != null:
return $default(_that.id,_that.doctorId,_that.date,_that.startTime,_that.endTime,_that.quota,_that.booked,_that.isAvailable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DoctorSchedule implements DoctorSchedule {
  const _DoctorSchedule({@JsonKey(name: 'ID') this.id = 0, @JsonKey(name: 'doctor_id') this.doctorId = 0, this.date, @JsonKey(name: 'start_time') this.startTime = '', @JsonKey(name: 'end_time') this.endTime = '', this.quota = 0, this.booked = 0, @JsonKey(name: 'is_available') this.isAvailable = true});
  factory _DoctorSchedule.fromJson(Map<String, dynamic> json) => _$DoctorScheduleFromJson(json);

@override@JsonKey(name: 'ID') final  int id;
@override@JsonKey(name: 'doctor_id') final  int doctorId;
@override final  DateTime? date;
@override@JsonKey(name: 'start_time') final  String startTime;
@override@JsonKey(name: 'end_time') final  String endTime;
@override@JsonKey() final  int quota;
@override@JsonKey() final  int booked;
@override@JsonKey(name: 'is_available') final  bool isAvailable;

/// Create a copy of DoctorSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoctorScheduleCopyWith<_DoctorSchedule> get copyWith => __$DoctorScheduleCopyWithImpl<_DoctorSchedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DoctorScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DoctorSchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.doctorId, doctorId) || other.doctorId == doctorId)&&(identical(other.date, date) || other.date == date)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.quota, quota) || other.quota == quota)&&(identical(other.booked, booked) || other.booked == booked)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,doctorId,date,startTime,endTime,quota,booked,isAvailable);

@override
String toString() {
  return 'DoctorSchedule(id: $id, doctorId: $doctorId, date: $date, startTime: $startTime, endTime: $endTime, quota: $quota, booked: $booked, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class _$DoctorScheduleCopyWith<$Res> implements $DoctorScheduleCopyWith<$Res> {
  factory _$DoctorScheduleCopyWith(_DoctorSchedule value, $Res Function(_DoctorSchedule) _then) = __$DoctorScheduleCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'ID') int id,@JsonKey(name: 'doctor_id') int doctorId, DateTime? date,@JsonKey(name: 'start_time') String startTime,@JsonKey(name: 'end_time') String endTime, int quota, int booked,@JsonKey(name: 'is_available') bool isAvailable
});




}
/// @nodoc
class __$DoctorScheduleCopyWithImpl<$Res>
    implements _$DoctorScheduleCopyWith<$Res> {
  __$DoctorScheduleCopyWithImpl(this._self, this._then);

  final _DoctorSchedule _self;
  final $Res Function(_DoctorSchedule) _then;

/// Create a copy of DoctorSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? doctorId = null,Object? date = freezed,Object? startTime = null,Object? endTime = null,Object? quota = null,Object? booked = null,Object? isAvailable = null,}) {
  return _then(_DoctorSchedule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,doctorId: null == doctorId ? _self.doctorId : doctorId // ignore: cast_nullable_to_non_nullable
as int,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,quota: null == quota ? _self.quota : quota // ignore: cast_nullable_to_non_nullable
as int,booked: null == booked ? _self.booked : booked // ignore: cast_nullable_to_non_nullable
as int,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
