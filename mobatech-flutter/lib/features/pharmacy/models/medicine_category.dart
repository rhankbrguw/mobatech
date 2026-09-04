import 'package:freezed_annotation/freezed_annotation.dart';

part 'medicine_category.freezed.dart';
part 'medicine_category.g.dart';

@freezed
abstract class MedicineCategory with _$MedicineCategory {
  const MedicineCategory._();

  const factory MedicineCategory({
    required int id,
    required String name,
    required String icon,
  }) = _MedicineCategory;

  factory MedicineCategory.fromJson(Map<String, dynamic> json) =>
      _$MedicineCategoryFromJson(json);
  static MedicineCategory fromBackendJson(Map<String, dynamic> json) =>
      MedicineCategory.fromJson(_mapJson(json));

  static Map<String, dynamic> _mapJson(Map<String, dynamic> json) {
    final modifiedJson = Map<String, dynamic>.from(json);
    modifiedJson['id'] = (modifiedJson['ID'] ?? modifiedJson['id']) as int;
    return modifiedJson;
  }
}
