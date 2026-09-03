// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prescription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PrescriptionItem {

@JsonKey(name: 'medicine_id') int? get medicineId;@JsonKey(name: 'medicine_name') String get medicineName;@JsonKey(name: 'custom_medicine') String get customMedicine;@JsonKey(name: 'dosage_instruction') String get dosageInstruction; String get duration; int get quantity;
/// Create a copy of PrescriptionItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrescriptionItemCopyWith<PrescriptionItem> get copyWith => _$PrescriptionItemCopyWithImpl<PrescriptionItem>(this as PrescriptionItem, _$identity);

  /// Serializes this PrescriptionItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrescriptionItem&&(identical(other.medicineId, medicineId) || other.medicineId == medicineId)&&(identical(other.medicineName, medicineName) || other.medicineName == medicineName)&&(identical(other.customMedicine, customMedicine) || other.customMedicine == customMedicine)&&(identical(other.dosageInstruction, dosageInstruction) || other.dosageInstruction == dosageInstruction)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicineId,medicineName,customMedicine,dosageInstruction,duration,quantity);

@override
String toString() {
  return 'PrescriptionItem(medicineId: $medicineId, medicineName: $medicineName, customMedicine: $customMedicine, dosageInstruction: $dosageInstruction, duration: $duration, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $PrescriptionItemCopyWith<$Res>  {
  factory $PrescriptionItemCopyWith(PrescriptionItem value, $Res Function(PrescriptionItem) _then) = _$PrescriptionItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'medicine_id') int? medicineId,@JsonKey(name: 'medicine_name') String medicineName,@JsonKey(name: 'custom_medicine') String customMedicine,@JsonKey(name: 'dosage_instruction') String dosageInstruction, String duration, int quantity
});




}
/// @nodoc
class _$PrescriptionItemCopyWithImpl<$Res>
    implements $PrescriptionItemCopyWith<$Res> {
  _$PrescriptionItemCopyWithImpl(this._self, this._then);

  final PrescriptionItem _self;
  final $Res Function(PrescriptionItem) _then;

/// Create a copy of PrescriptionItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicineId = freezed,Object? medicineName = null,Object? customMedicine = null,Object? dosageInstruction = null,Object? duration = null,Object? quantity = null,}) {
  return _then(_self.copyWith(
medicineId: freezed == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as int?,medicineName: null == medicineName ? _self.medicineName : medicineName // ignore: cast_nullable_to_non_nullable
as String,customMedicine: null == customMedicine ? _self.customMedicine : customMedicine // ignore: cast_nullable_to_non_nullable
as String,dosageInstruction: null == dosageInstruction ? _self.dosageInstruction : dosageInstruction // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PrescriptionItem].
extension PrescriptionItemPatterns on PrescriptionItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrescriptionItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrescriptionItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrescriptionItem value)  $default,){
final _that = this;
switch (_that) {
case _PrescriptionItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrescriptionItem value)?  $default,){
final _that = this;
switch (_that) {
case _PrescriptionItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'medicine_id')  int? medicineId, @JsonKey(name: 'medicine_name')  String medicineName, @JsonKey(name: 'custom_medicine')  String customMedicine, @JsonKey(name: 'dosage_instruction')  String dosageInstruction,  String duration,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrescriptionItem() when $default != null:
return $default(_that.medicineId,_that.medicineName,_that.customMedicine,_that.dosageInstruction,_that.duration,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'medicine_id')  int? medicineId, @JsonKey(name: 'medicine_name')  String medicineName, @JsonKey(name: 'custom_medicine')  String customMedicine, @JsonKey(name: 'dosage_instruction')  String dosageInstruction,  String duration,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _PrescriptionItem():
return $default(_that.medicineId,_that.medicineName,_that.customMedicine,_that.dosageInstruction,_that.duration,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'medicine_id')  int? medicineId, @JsonKey(name: 'medicine_name')  String medicineName, @JsonKey(name: 'custom_medicine')  String customMedicine, @JsonKey(name: 'dosage_instruction')  String dosageInstruction,  String duration,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _PrescriptionItem() when $default != null:
return $default(_that.medicineId,_that.medicineName,_that.customMedicine,_that.dosageInstruction,_that.duration,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrescriptionItem extends PrescriptionItem {
  const _PrescriptionItem({@JsonKey(name: 'medicine_id') this.medicineId, @JsonKey(name: 'medicine_name') required this.medicineName, @JsonKey(name: 'custom_medicine') required this.customMedicine, @JsonKey(name: 'dosage_instruction') required this.dosageInstruction, required this.duration, required this.quantity}): super._();
  factory _PrescriptionItem.fromJson(Map<String, dynamic> json) => _$PrescriptionItemFromJson(json);

@override@JsonKey(name: 'medicine_id') final  int? medicineId;
@override@JsonKey(name: 'medicine_name') final  String medicineName;
@override@JsonKey(name: 'custom_medicine') final  String customMedicine;
@override@JsonKey(name: 'dosage_instruction') final  String dosageInstruction;
@override final  String duration;
@override final  int quantity;

/// Create a copy of PrescriptionItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrescriptionItemCopyWith<_PrescriptionItem> get copyWith => __$PrescriptionItemCopyWithImpl<_PrescriptionItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrescriptionItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrescriptionItem&&(identical(other.medicineId, medicineId) || other.medicineId == medicineId)&&(identical(other.medicineName, medicineName) || other.medicineName == medicineName)&&(identical(other.customMedicine, customMedicine) || other.customMedicine == customMedicine)&&(identical(other.dosageInstruction, dosageInstruction) || other.dosageInstruction == dosageInstruction)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicineId,medicineName,customMedicine,dosageInstruction,duration,quantity);

@override
String toString() {
  return 'PrescriptionItem(medicineId: $medicineId, medicineName: $medicineName, customMedicine: $customMedicine, dosageInstruction: $dosageInstruction, duration: $duration, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$PrescriptionItemCopyWith<$Res> implements $PrescriptionItemCopyWith<$Res> {
  factory _$PrescriptionItemCopyWith(_PrescriptionItem value, $Res Function(_PrescriptionItem) _then) = __$PrescriptionItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'medicine_id') int? medicineId,@JsonKey(name: 'medicine_name') String medicineName,@JsonKey(name: 'custom_medicine') String customMedicine,@JsonKey(name: 'dosage_instruction') String dosageInstruction, String duration, int quantity
});




}
/// @nodoc
class __$PrescriptionItemCopyWithImpl<$Res>
    implements _$PrescriptionItemCopyWith<$Res> {
  __$PrescriptionItemCopyWithImpl(this._self, this._then);

  final _PrescriptionItem _self;
  final $Res Function(_PrescriptionItem) _then;

/// Create a copy of PrescriptionItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicineId = freezed,Object? medicineName = null,Object? customMedicine = null,Object? dosageInstruction = null,Object? duration = null,Object? quantity = null,}) {
  return _then(_PrescriptionItem(
medicineId: freezed == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as int?,medicineName: null == medicineName ? _self.medicineName : medicineName // ignore: cast_nullable_to_non_nullable
as String,customMedicine: null == customMedicine ? _self.customMedicine : customMedicine // ignore: cast_nullable_to_non_nullable
as String,dosageInstruction: null == dosageInstruction ? _self.dosageInstruction : dosageInstruction // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Prescription {

 int get id;@JsonKey(name: 'appointment_id') int? get appointmentId;@JsonKey(name: 'doctor_name') String get doctorName; String get diagnosis; List<PrescriptionItem> get items;@JsonKey(name: 'user_id') int get userId;@JsonKey(name: 'image_url') String get imageUrl; String get notes; String get status;@JsonKey(name: 'CreatedAt') DateTime get createdAt;
/// Create a copy of Prescription
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrescriptionCopyWith<Prescription> get copyWith => _$PrescriptionCopyWithImpl<Prescription>(this as Prescription, _$identity);

  /// Serializes this Prescription to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Prescription&&(identical(other.id, id) || other.id == id)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.doctorName, doctorName) || other.doctorName == doctorName)&&(identical(other.diagnosis, diagnosis) || other.diagnosis == diagnosis)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,appointmentId,doctorName,diagnosis,const DeepCollectionEquality().hash(items),userId,imageUrl,notes,status,createdAt);

@override
String toString() {
  return 'Prescription(id: $id, appointmentId: $appointmentId, doctorName: $doctorName, diagnosis: $diagnosis, items: $items, userId: $userId, imageUrl: $imageUrl, notes: $notes, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PrescriptionCopyWith<$Res>  {
  factory $PrescriptionCopyWith(Prescription value, $Res Function(Prescription) _then) = _$PrescriptionCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'appointment_id') int? appointmentId,@JsonKey(name: 'doctor_name') String doctorName, String diagnosis, List<PrescriptionItem> items,@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'image_url') String imageUrl, String notes, String status,@JsonKey(name: 'CreatedAt') DateTime createdAt
});




}
/// @nodoc
class _$PrescriptionCopyWithImpl<$Res>
    implements $PrescriptionCopyWith<$Res> {
  _$PrescriptionCopyWithImpl(this._self, this._then);

  final Prescription _self;
  final $Res Function(Prescription) _then;

/// Create a copy of Prescription
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? appointmentId = freezed,Object? doctorName = null,Object? diagnosis = null,Object? items = null,Object? userId = null,Object? imageUrl = null,Object? notes = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,appointmentId: freezed == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as int?,doctorName: null == doctorName ? _self.doctorName : doctorName // ignore: cast_nullable_to_non_nullable
as String,diagnosis: null == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<PrescriptionItem>,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Prescription].
extension PrescriptionPatterns on Prescription {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Prescription value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Prescription() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Prescription value)  $default,){
final _that = this;
switch (_that) {
case _Prescription():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Prescription value)?  $default,){
final _that = this;
switch (_that) {
case _Prescription() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'appointment_id')  int? appointmentId, @JsonKey(name: 'doctor_name')  String doctorName,  String diagnosis,  List<PrescriptionItem> items, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'image_url')  String imageUrl,  String notes,  String status, @JsonKey(name: 'CreatedAt')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Prescription() when $default != null:
return $default(_that.id,_that.appointmentId,_that.doctorName,_that.diagnosis,_that.items,_that.userId,_that.imageUrl,_that.notes,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'appointment_id')  int? appointmentId, @JsonKey(name: 'doctor_name')  String doctorName,  String diagnosis,  List<PrescriptionItem> items, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'image_url')  String imageUrl,  String notes,  String status, @JsonKey(name: 'CreatedAt')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Prescription():
return $default(_that.id,_that.appointmentId,_that.doctorName,_that.diagnosis,_that.items,_that.userId,_that.imageUrl,_that.notes,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'appointment_id')  int? appointmentId, @JsonKey(name: 'doctor_name')  String doctorName,  String diagnosis,  List<PrescriptionItem> items, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'image_url')  String imageUrl,  String notes,  String status, @JsonKey(name: 'CreatedAt')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Prescription() when $default != null:
return $default(_that.id,_that.appointmentId,_that.doctorName,_that.diagnosis,_that.items,_that.userId,_that.imageUrl,_that.notes,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Prescription extends Prescription {
  const _Prescription({required this.id, @JsonKey(name: 'appointment_id') this.appointmentId, @JsonKey(name: 'doctor_name') required this.doctorName, required this.diagnosis, required final  List<PrescriptionItem> items, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'image_url') required this.imageUrl, required this.notes, required this.status, @JsonKey(name: 'CreatedAt') required this.createdAt}): _items = items,super._();
  factory _Prescription.fromJson(Map<String, dynamic> json) => _$PrescriptionFromJson(json);

@override final  int id;
@override@JsonKey(name: 'appointment_id') final  int? appointmentId;
@override@JsonKey(name: 'doctor_name') final  String doctorName;
@override final  String diagnosis;
 final  List<PrescriptionItem> _items;
@override List<PrescriptionItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'user_id') final  int userId;
@override@JsonKey(name: 'image_url') final  String imageUrl;
@override final  String notes;
@override final  String status;
@override@JsonKey(name: 'CreatedAt') final  DateTime createdAt;

/// Create a copy of Prescription
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrescriptionCopyWith<_Prescription> get copyWith => __$PrescriptionCopyWithImpl<_Prescription>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrescriptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Prescription&&(identical(other.id, id) || other.id == id)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.doctorName, doctorName) || other.doctorName == doctorName)&&(identical(other.diagnosis, diagnosis) || other.diagnosis == diagnosis)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,appointmentId,doctorName,diagnosis,const DeepCollectionEquality().hash(_items),userId,imageUrl,notes,status,createdAt);

@override
String toString() {
  return 'Prescription(id: $id, appointmentId: $appointmentId, doctorName: $doctorName, diagnosis: $diagnosis, items: $items, userId: $userId, imageUrl: $imageUrl, notes: $notes, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PrescriptionCopyWith<$Res> implements $PrescriptionCopyWith<$Res> {
  factory _$PrescriptionCopyWith(_Prescription value, $Res Function(_Prescription) _then) = __$PrescriptionCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'appointment_id') int? appointmentId,@JsonKey(name: 'doctor_name') String doctorName, String diagnosis, List<PrescriptionItem> items,@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'image_url') String imageUrl, String notes, String status,@JsonKey(name: 'CreatedAt') DateTime createdAt
});




}
/// @nodoc
class __$PrescriptionCopyWithImpl<$Res>
    implements _$PrescriptionCopyWith<$Res> {
  __$PrescriptionCopyWithImpl(this._self, this._then);

  final _Prescription _self;
  final $Res Function(_Prescription) _then;

/// Create a copy of Prescription
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? appointmentId = freezed,Object? doctorName = null,Object? diagnosis = null,Object? items = null,Object? userId = null,Object? imageUrl = null,Object? notes = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_Prescription(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,appointmentId: freezed == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as int?,doctorName: null == doctorName ? _self.doctorName : doctorName // ignore: cast_nullable_to_non_nullable
as String,diagnosis: null == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PrescriptionItem>,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
