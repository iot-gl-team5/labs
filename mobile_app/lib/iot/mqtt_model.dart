import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_app/iot/agent_data.dart';
import 'package:mobile_app/utils/serializable.dart';

part 'mqtt_model.freezed.dart';
part 'mqtt_model.g.dart';

@freezed
class MqttModel with _$MqttModel implements Serializable<MqttModel> {
  const factory MqttModel({
    @JsonKey(name: 'road_state') required String roadState,
    @JsonKey(name: 'agent_data') required AgentData agentData,
  }) = _MqttModel;

  factory MqttModel.fromJson(Map<String, dynamic> json) = _MqttModel.fromJson;
}
