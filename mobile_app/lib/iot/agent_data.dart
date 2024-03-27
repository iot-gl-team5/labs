import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_app/iot/accelerometer.dart';
import 'package:mobile_app/iot/location.dart';

import '../utils/serializable.dart';

part 'agent_data.freezed.dart';
part 'agent_data.g.dart';

@freezed
class AgentData with _$AgentData implements Serializable<AgentData> {
  const factory AgentData({
    @JsonKey(name: 'user_id') required int userId,
    required Accelerometer accelerometer,
    required Location gps,
    required DateTime timestamp,
  }) = _AgentData;

  factory AgentData.fromJson(Map<String, dynamic> json) = _AgentData.fromJson;
}
