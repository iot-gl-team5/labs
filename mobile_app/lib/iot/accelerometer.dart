import 'package:freezed_annotation/freezed_annotation.dart';
import '../utils/serializable.dart';

part 'accelerometer.freezed.dart';
part 'accelerometer.g.dart';

@freezed
class Accelerometer
    with _$Accelerometer
    implements Serializable<Accelerometer> {
  const factory Accelerometer({
    required double x,
    required double y,
    required double z,
  }) = _Accelerometer;

  factory Accelerometer.fromJson(Map<String, dynamic> json) =
      _Accelerometer.fromJson;
}
