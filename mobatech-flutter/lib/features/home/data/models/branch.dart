import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch.freezed.dart';
part 'branch.g.dart';

@freezed
abstract class Branch with _$Branch {
  factory Branch({
    @JsonKey(name: 'ID', defaultValue: 0) required int id,
    @JsonKey(defaultValue: '') required String name,
    @JsonKey(defaultValue: '') required String address,
    @JsonKey(defaultValue: 0.0) required double latitude,
    @JsonKey(defaultValue: 0.0) required double longitude,
    @JsonKey(name: 'image_url', defaultValue: '') required String imageUrl,
    @JsonKey(name: 'gmaps_link', defaultValue: '') required String gmapsLink,
  }) = _Branch;

  factory Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);
}
