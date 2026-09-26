// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appointment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Appointment {

@JsonKey(name: 'ID') int get id;@JsonKey(name: 'user_id') int get userId;@JsonKey(name: 'doctor_id') int get doctorId;@JsonKey(name: 'doctor_schedule_id') int get doctorScheduleId; String get status; String get notes;@JsonKey(includeToJson: false) Doctor? get doctor;@JsonKey(includeToJson: false) DoctorSchedule? get schedule;
/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentCopyWith<Appointment> get copyWith => _$AppointmentCopyWithImpl<Appointment>(this as Appointment, _$identity);

  /// Serializes this Appointment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Appointment&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.doctorId, doctorId) || other.doctorId == doctorId)&&(identical(other.doctorScheduleId, doctorScheduleId) || other.doctorScheduleId == doctorScheduleId)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.doctor, doctor) || other.doctor == doctor)&&(identical(other.schedule, schedule) || other.schedule == schedule));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,doctorId,doctorScheduleId,status,notes,doctor,schedule);

@override
String toString() {
  return 'Appointment(id: $id, userId: $userId, doctorId: $doctorId, doctorScheduleId: $doctorScheduleId, status: $status, notes: $notes, doctor: $doctor, schedule: $schedule)';
}


}

/// @nodoc
abstract mixin class $AppointmentCopyWith<$Res>  {
  factory $AppointmentCopyWith(Appointment value, $Res Function(Appointment) _then) = _$AppointmentCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'ID') int id,@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'doctor_id') int doctorId,@JsonKey(name: 'doctor_schedule_id') int doctorScheduleId, String status, String notes,@JsonKey(includeToJson: false) Doctor? doctor,@JsonKey(includeToJson: false) DoctorSchedule? schedule
});


$DoctorCopyWith<$Res>? get doctor;$DoctorScheduleCopyWith<$Res>? get schedule;

}
/// @nodoc
class _$AppointmentCopyWithImpl<$Res>
    implements $AppointmentCopyWith<$Res> {
  _$AppointmentCopyWithImpl(this._self, this._then);

  final Appointment _self;
  final $Res Function(Appointment) _then;

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? doctorId = null,Object? doctorScheduleId = null,Object? status = null,Object? notes = null,Object? doctor = freezed,Object? schedule = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,doctorId: null == doctorId ? _self.doctorId : doctorId // ignore: cast_nullable_to_non_nullable
as int,doctorScheduleId: null == doctorScheduleId ? _self.doctorScheduleId : doctorScheduleId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,doctor: freezed == doctor ? _self.doctor : doctor // ignore: cast_nullable_to_non_nullable
as Doctor?,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as DoctorSchedule?,
  ));
}
/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DoctorCopyWith<$Res>? get doctor {
    if (_self.doctor == null) {
    return null;
  }

  return $DoctorCopyWith<$Res>(_self.doctor!, (value) {
    return _then(_self.copyWith(doctor: value));
  });
}/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DoctorScheduleCopyWith<$Res>? get schedule {
    if (_self.schedule == null) {
    return null;
  }

  return $DoctorScheduleCopyWith<$Res>(_self.schedule!, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}


/// Adds pattern-matching-related methods to [Appointment].
extension AppointmentPatterns on Appointment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Appointment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Appointment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Appointment value)  $default,){
final _that = this;
switch (_that) {
case _Appointment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Appointment value)?  $default,){
final _that = this;
switch (_that) {
case _Appointment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'ID')  int id, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'doctor_id')  int doctorId, @JsonKey(name: 'doctor_schedule_id')  int doctorScheduleId,  String status,  String notes, @JsonKey(includeToJson: false)  Doctor? doctor, @JsonKey(includeToJson: false)  DoctorSchedule? schedule)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Appointment() when $default != null:
return $default(_that.id,_that.userId,_that.doctorId,_that.doctorScheduleId,_that.status,_that.notes,_that.doctor,_that.schedule);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'ID')  int id, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'doctor_id')  int doctorId, @JsonKey(name: 'doctor_schedule_id')  int doctorScheduleId,  String status,  String notes, @JsonKey(includeToJson: false)  Doctor? doctor, @JsonKey(includeToJson: false)  DoctorSchedule? schedule)  $default,) {final _that = this;
switch (_that) {
case _Appointment():
return $default(_that.id,_that.userId,_that.doctorId,_that.doctorScheduleId,_that.status,_that.notes,_that.doctor,_that.schedule);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'ID')  int id, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'doctor_id')  int doctorId, @JsonKey(name: 'doctor_schedule_id')  int doctorScheduleId,  String status,  String notes, @JsonKey(includeToJson: false)  Doctor? doctor, @JsonKey(includeToJson: false)  DoctorSchedule? schedule)?  $default,) {final _that = this;
switch (_that) {
case _Appointment() when $default != null:
return $default(_that.id,_that.userId,_that.doctorId,_that.doctorScheduleId,_that.status,_that.notes,_that.doctor,_that.schedule);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Appointment implements Appointment {
  const _Appointment({@JsonKey(name: 'ID') this.id = 0, @JsonKey(name: 'user_id') this.userId = 0, @JsonKey(name: 'doctor_id') this.doctorId = 0, @JsonKey(name: 'doctor_schedule_id') this.doctorScheduleId = 0, this.status = '', this.notes = '', @JsonKey(includeToJson: false) this.doctor, @JsonKey(includeToJson: false) this.schedule});
  factory _Appointment.fromJson(Map<String, dynamic> json) => _$AppointmentFromJson(json);

@override@JsonKey(name: 'ID') final  int id;
@override@JsonKey(name: 'user_id') final  int userId;
@override@JsonKey(name: 'doctor_id') final  int doctorId;
@override@JsonKey(name: 'doctor_schedule_id') final  int doctorScheduleId;
@override@JsonKey() final  String status;
@override@JsonKey() final  String notes;
@override@JsonKey(includeToJson: false) final  Doctor? doctor;
@override@JsonKey(includeToJson: false) final  DoctorSchedule? schedule;

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentCopyWith<_Appointment> get copyWith => __$AppointmentCopyWithImpl<_Appointment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppointmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Appointment&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.doctorId, doctorId) || other.doctorId == doctorId)&&(identical(other.doctorScheduleId, doctorScheduleId) || other.doctorScheduleId == doctorScheduleId)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.doctor, doctor) || other.doctor == doctor)&&(identical(other.schedule, schedule) || other.schedule == schedule));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,doctorId,doctorScheduleId,status,notes,doctor,schedule);

@override
String toString() {
  return 'Appointment(id: $id, userId: $userId, doctorId: $doctorId, doctorScheduleId: $doctorScheduleId, status: $status, notes: $notes, doctor: $doctor, schedule: $schedule)';
}


}

/// @nodoc
abstract mixin class _$AppointmentCopyWith<$Res> implements $AppointmentCopyWith<$Res> {
  factory _$AppointmentCopyWith(_Appointment value, $Res Function(_Appointment) _then) = __$AppointmentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'ID') int id,@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'doctor_id') int doctorId,@JsonKey(name: 'doctor_schedule_id') int doctorScheduleId, String status, String notes,@JsonKey(includeToJson: false) Doctor? doctor,@JsonKey(includeToJson: false) DoctorSchedule? schedule
});


@override $DoctorCopyWith<$Res>? get doctor;@override $DoctorScheduleCopyWith<$Res>? get schedule;

}
/// @nodoc
class __$AppointmentCopyWithImpl<$Res>
    implements _$AppointmentCopyWith<$Res> {
  __$AppointmentCopyWithImpl(this._self, this._then);

  final _Appointment _self;
  final $Res Function(_Appointment) _then;

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? doctorId = null,Object? doctorScheduleId = null,Object? status = null,Object? notes = null,Object? doctor = freezed,Object? schedule = freezed,}) {
  return _then(_Appointment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,doctorId: null == doctorId ? _self.doctorId : doctorId // ignore: cast_nullable_to_non_nullable
as int,doctorScheduleId: null == doctorScheduleId ? _self.doctorScheduleId : doctorScheduleId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,doctor: freezed == doctor ? _self.doctor : doctor // ignore: cast_nullable_to_non_nullable
as Doctor?,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as DoctorSchedule?,
  ));
}

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DoctorCopyWith<$Res>? get doctor {
    if (_self.doctor == null) {
    return null;
  }

  return $DoctorCopyWith<$Res>(_self.doctor!, (value) {
    return _then(_self.copyWith(doctor: value));
  });
}/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DoctorScheduleCopyWith<$Res>? get schedule {
    if (_self.schedule == null) {
    return null;
  }

  return $DoctorScheduleCopyWith<$Res>(_self.schedule!, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}

// dart format on
