import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_app/utils/serializable.dart';

part 'location.freezed.dart';
part 'location.g.dart';

@freezed
class Location with _$Location implements Serializable<Location> {
  const factory Location({
    double? longitude,
    double? latitude,
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) = _Location.fromJson;
}
