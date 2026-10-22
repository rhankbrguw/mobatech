// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PrescriptionItem _$PrescriptionItemFromJson(Map<String, dynamic> json) =>
    _PrescriptionItem(
      medicineId: (json['medicine_id'] as num?)?.toInt(),
      medicineName: json['medicine_name'] as String,
      customMedicine: json['custom_medicine'] as String,
      dosageInstruction: json['dosage_instruction'] as String,
      duration: json['duration'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$PrescriptionItemToJson(_PrescriptionItem instance) =>
    <String, dynamic>{
      'medicine_id': instance.medicineId,
      'medicine_name': instance.medicineName,
      'custom_medicine': instance.customMedicine,
      'dosage_instruction': instance.dosageInstruction,
      'duration': instance.duration,
      'quantity': instance.quantity,
    };

_Prescription _$PrescriptionFromJson(Map<String, dynamic> json) =>
    _Prescription(
      id: (json['id'] as num).toInt(),
      appointmentId: (json['appointment_id'] as num?)?.toInt(),
      doctorName: json['doctor_name'] as String,
      diagnosis: json['diagnosis'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => PrescriptionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      userId: (json['user_id'] as num).toInt(),
      imageUrl: json['image_url'] as String,
      notes: json['notes'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['CreatedAt'] as String),
    );

Map<String, dynamic> _$PrescriptionToJson(_Prescription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'appointment_id': instance.appointmentId,
      'doctor_name': instance.doctorName,
      'diagnosis': instance.diagnosis,
      'items': instance.items,
      'user_id': instance.userId,
      'image_url': instance.imageUrl,
      'notes': instance.notes,
      'status': instance.status,
      'CreatedAt': instance.createdAt.toIso8601String(),
    };
