import 'package:freezed_annotation/freezed_annotation.dart';
import 'medicine_category.dart';
import '../../../core/network/dio_client.dart';

part 'medicine.freezed.dart';
part 'medicine.g.dart';

@freezed
abstract class Medicine with _$Medicine {
  const Medicine._();

  const factory Medicine({
    required int id,
    required String name,
    @JsonKey(name: 'generic_name') @Default('') String genericName,
    required double price,
    @Default(0) int stock,
    @JsonKey(name: 'requires_prescription')
    @Default(false)
    bool requiresPrescription,
    @JsonKey(name: 'image_url') required String imageUrl,
    MedicineCategory? category,
  }) = _Medicine;

  factory Medicine.fromJson(Map<String, dynamic> json) =>
      _$MedicineFromJson(json);
  static Medicine fromBackendJson(Map<String, dynamic> json) =>
      Medicine.fromJson(_mapJson(json));

  Map<String, dynamic> toSafeJson() {
    final json = toJson();
    final currentCategory = category;
    if (currentCategory != null) {
      // Safe to use non-null local variable instead of raw ! operator
      json['category'] = currentCategory.toJson();
    }
    return json;
  }

  static Map<String, dynamic> _mapJson(Map<String, dynamic> json) {
    String rawImageUrl = json['image_url'] as String? ?? '';
    rawImageUrl = fixImageUrl(rawImageUrl);

    final modifiedJson = Map<String, dynamic>.from(json);
    modifiedJson['id'] = (modifiedJson['ID'] ?? modifiedJson['id']) as int;
    modifiedJson['generic_name'] =
        modifiedJson['generic_name'] as String? ?? '';
    modifiedJson['price'] = (modifiedJson['price'] as num).toDouble();
    modifiedJson['stock'] = modifiedJson['stock'] as int? ?? 0;
    modifiedJson['requires_prescription'] =
        modifiedJson['requires_prescription'] as bool? ?? false;
    modifiedJson['image_url'] = rawImageUrl;

    if (modifiedJson['category'] != null) {
      final cat = modifiedJson['category'];
      modifiedJson['category'] = cat is Map<String, dynamic>
          ? MedicineCategory.fromBackendJson(cat).toJson()
          : null;
    }

    return modifiedJson;
  }
}
