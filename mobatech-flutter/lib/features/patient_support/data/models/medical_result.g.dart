// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MedicalResult _$MedicalResultFromJson(Map<String, dynamic> json) =>
    _MedicalResult(
      id: json['id'] as String,
      testName: json['test_name'] as String,
      date: json['date'] as String,
      status: json['status'] as String,
      hospitalName: json['hospital_name'] as String,
      doctorName: json['doctor_name'] as String?,
      resultDetails: json['result_details'] as String?,
      documentUrl: json['document_url'] as String?,
    );

Map<String, dynamic> _$MedicalResultToJson(_MedicalResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'test_name': instance.testName,
      'date': instance.date,
      'status': instance.status,
      'hospital_name': instance.hospitalName,
      'doctor_name': instance.doctorName,
      'result_details': instance.resultDetails,
      'document_url': instance.documentUrl,
    };
