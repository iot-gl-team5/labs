import 'package:freezed_annotation/freezed_annotation.dart';

import 'accelerometer.dart';
import 'location.dart';

part 'metrics_state.freezed.dart';

@freezed
class MetricsState with _$MetricsState {
  const factory MetricsState({
    Accelerometer? accelerometer,
    Location? location,
    int? port,
    String? host,
  }) = _MetricsState;
}
