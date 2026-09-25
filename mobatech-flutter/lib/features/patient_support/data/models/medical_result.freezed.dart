// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medical_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedicalResult {

 String get id;@JsonKey(name: 'test_name') String get testName; String get date; String get status;@JsonKey(name: 'hospital_name') String get hospitalName;@JsonKey(name: 'doctor_name') String? get doctorName;@JsonKey(name: 'result_details') String? get resultDetails;@JsonKey(name: 'document_url') String? get documentUrl;
/// Create a copy of MedicalResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicalResultCopyWith<MedicalResult> get copyWith => _$MedicalResultCopyWithImpl<MedicalResult>(this as MedicalResult, _$identity);

  /// Serializes this MedicalResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicalResult&&(identical(other.id, id) || other.id == id)&&(identical(other.testName, testName) || other.testName == testName)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.hospitalName, hospitalName) || other.hospitalName == hospitalName)&&(identical(other.doctorName, doctorName) || other.doctorName == doctorName)&&(identical(other.resultDetails, resultDetails) || other.resultDetails == resultDetails)&&(identical(other.documentUrl, documentUrl) || other.documentUrl == documentUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,testName,date,status,hospitalName,doctorName,resultDetails,documentUrl);

@override
String toString() {
  return 'MedicalResult(id: $id, testName: $testName, date: $date, status: $status, hospitalName: $hospitalName, doctorName: $doctorName, resultDetails: $resultDetails, documentUrl: $documentUrl)';
}


}

/// @nodoc
abstract mixin class $MedicalResultCopyWith<$Res>  {
  factory $MedicalResultCopyWith(MedicalResult value, $Res Function(MedicalResult) _then) = _$MedicalResultCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'test_name') String testName, String date, String status,@JsonKey(name: 'hospital_name') String hospitalName,@JsonKey(name: 'doctor_name') String? doctorName,@JsonKey(name: 'result_details') String? resultDetails,@JsonKey(name: 'document_url') String? documentUrl
});




}
/// @nodoc
class _$MedicalResultCopyWithImpl<$Res>
    implements $MedicalResultCopyWith<$Res> {
  _$MedicalResultCopyWithImpl(this._self, this._then);

  final MedicalResult _self;
  final $Res Function(MedicalResult) _then;

/// Create a copy of MedicalResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? testName = null,Object? date = null,Object? status = null,Object? hospitalName = null,Object? doctorName = freezed,Object? resultDetails = freezed,Object? documentUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,testName: null == testName ? _self.testName : testName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,hospitalName: null == hospitalName ? _self.hospitalName : hospitalName // ignore: cast_nullable_to_non_nullable
as String,doctorName: freezed == doctorName ? _self.doctorName : doctorName // ignore: cast_nullable_to_non_nullable
as String?,resultDetails: freezed == resultDetails ? _self.resultDetails : resultDetails // ignore: cast_nullable_to_non_nullable
as String?,documentUrl: freezed == documentUrl ? _self.documentUrl : documentUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicalResult].
extension MedicalResultPatterns on MedicalResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicalResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicalResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicalResult value)  $default,){
final _that = this;
switch (_that) {
case _MedicalResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicalResult value)?  $default,){
final _that = this;
switch (_that) {
case _MedicalResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'test_name')  String testName,  String date,  String status, @JsonKey(name: 'hospital_name')  String hospitalName, @JsonKey(name: 'doctor_name')  String? doctorName, @JsonKey(name: 'result_details')  String? resultDetails, @JsonKey(name: 'document_url')  String? documentUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicalResult() when $default != null:
return $default(_that.id,_that.testName,_that.date,_that.status,_that.hospitalName,_that.doctorName,_that.resultDetails,_that.documentUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'test_name')  String testName,  String date,  String status, @JsonKey(name: 'hospital_name')  String hospitalName, @JsonKey(name: 'doctor_name')  String? doctorName, @JsonKey(name: 'result_details')  String? resultDetails, @JsonKey(name: 'document_url')  String? documentUrl)  $default,) {final _that = this;
switch (_that) {
case _MedicalResult():
return $default(_that.id,_that.testName,_that.date,_that.status,_that.hospitalName,_that.doctorName,_that.resultDetails,_that.documentUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'test_name')  String testName,  String date,  String status, @JsonKey(name: 'hospital_name')  String hospitalName, @JsonKey(name: 'doctor_name')  String? doctorName, @JsonKey(name: 'result_details')  String? resultDetails, @JsonKey(name: 'document_url')  String? documentUrl)?  $default,) {final _that = this;
switch (_that) {
case _MedicalResult() when $default != null:
return $default(_that.id,_that.testName,_that.date,_that.status,_that.hospitalName,_that.doctorName,_that.resultDetails,_that.documentUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicalResult extends MedicalResult {
  const _MedicalResult({required this.id, @JsonKey(name: 'test_name') required this.testName, required this.date, required this.status, @JsonKey(name: 'hospital_name') required this.hospitalName, @JsonKey(name: 'doctor_name') this.doctorName, @JsonKey(name: 'result_details') this.resultDetails, @JsonKey(name: 'document_url') this.documentUrl}): super._();
  factory _MedicalResult.fromJson(Map<String, dynamic> json) => _$MedicalResultFromJson(json);

@override final  String id;
@override@JsonKey(name: 'test_name') final  String testName;
@override final  String date;
@override final  String status;
@override@JsonKey(name: 'hospital_name') final  String hospitalName;
@override@JsonKey(name: 'doctor_name') final  String? doctorName;
@override@JsonKey(name: 'result_details') final  String? resultDetails;
@override@JsonKey(name: 'document_url') final  String? documentUrl;

/// Create a copy of MedicalResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicalResultCopyWith<_MedicalResult> get copyWith => __$MedicalResultCopyWithImpl<_MedicalResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicalResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicalResult&&(identical(other.id, id) || other.id == id)&&(identical(other.testName, testName) || other.testName == testName)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.hospitalName, hospitalName) || other.hospitalName == hospitalName)&&(identical(other.doctorName, doctorName) || other.doctorName == doctorName)&&(identical(other.resultDetails, resultDetails) || other.resultDetails == resultDetails)&&(identical(other.documentUrl, documentUrl) || other.documentUrl == documentUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,testName,date,status,hospitalName,doctorName,resultDetails,documentUrl);

@override
String toString() {
  return 'MedicalResult(id: $id, testName: $testName, date: $date, status: $status, hospitalName: $hospitalName, doctorName: $doctorName, resultDetails: $resultDetails, documentUrl: $documentUrl)';
}


}

/// @nodoc
abstract mixin class _$MedicalResultCopyWith<$Res> implements $MedicalResultCopyWith<$Res> {
  factory _$MedicalResultCopyWith(_MedicalResult value, $Res Function(_MedicalResult) _then) = __$MedicalResultCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'test_name') String testName, String date, String status,@JsonKey(name: 'hospital_name') String hospitalName,@JsonKey(name: 'doctor_name') String? doctorName,@JsonKey(name: 'result_details') String? resultDetails,@JsonKey(name: 'document_url') String? documentUrl
});




}
/// @nodoc
class __$MedicalResultCopyWithImpl<$Res>
    implements _$MedicalResultCopyWith<$Res> {
  __$MedicalResultCopyWithImpl(this._self, this._then);

  final _MedicalResult _self;
  final $Res Function(_MedicalResult) _then;

/// Create a copy of MedicalResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? testName = null,Object? date = null,Object? status = null,Object? hospitalName = null,Object? doctorName = freezed,Object? resultDetails = freezed,Object? documentUrl = freezed,}) {
  return _then(_MedicalResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,testName: null == testName ? _self.testName : testName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,hospitalName: null == hospitalName ? _self.hospitalName : hospitalName // ignore: cast_nullable_to_non_nullable
as String,doctorName: freezed == doctorName ? _self.doctorName : doctorName // ignore: cast_nullable_to_non_nullable
as String?,resultDetails: freezed == resultDetails ? _self.resultDetails : resultDetails // ignore: cast_nullable_to_non_nullable
as String?,documentUrl: freezed == documentUrl ? _self.documentUrl : documentUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
