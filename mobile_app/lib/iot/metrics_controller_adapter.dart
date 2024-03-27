import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';
import 'package:mobile_app/iot/accelerometer.dart';
import 'package:mobile_app/iot/agent_data.dart';
import 'package:mobile_app/iot/location.dart';
import 'package:mobile_app/iot/metrics_controller.dart';
import 'package:mobile_app/iot/mqtt_model.dart';
import 'package:mobile_app/utils/extensions/subscription_extension.dart';
import 'package:mobile_app/utils/subscription_manager.dart';
import 'package:sensors_plus/sensors_plus.dart' as sensors;
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

const _userId = int.fromEnvironment(
  'USER_ID',
  defaultValue: 777,
);
const _topic = String.fromEnvironment(
  'TOPIC',
  defaultValue: 'processed_agent_data_topic',
);
const _port = int.fromEnvironment(
  'PORT',
  defaultValue: 1883,
);

const _host = String.fromEnvironment(
  'HOST',
  defaultValue: 'localhost',
);

class MetricsControllerAdapter extends MetricsController
    with SubscriptionManager {
  MetricsControllerAdapter(
    super.state, {
    required this.logger,
  }) {
    Geolocator.requestPermission();
    startDataStreaming();
  }

  @override
  void dispose() {
    cancelSubscriptions();
    super.dispose();
  }

  @protected
  final Logger logger;

  @protected
  late MqttClient mqttClient;

  @protected
  void startDataStreaming() => CombineLatestStream(
        [positionStream(), sensorsStream()],
        combine,
      )
          .where(_isLocationFetched)
          .where((_) => state.host != null)
          .where((_) => _isConnected)
          .delay(const Duration(seconds: 1))
          .listen(_handleData, onError: _handleError)
          .addToList(this);

  bool get _isConnected {
    return mqttClient.connectionStatus?.state == MqttConnectionState.connected;
  }

  bool _isLocationFetched(List event) {
    final location = event.elementAt(0) as Location;
    return location.latitude != null && location.longitude != null;
  }

  void _handleData(List<dynamic> data) {
    final location = data.elementAt(0) as Location;
    final accelerometer = data.elementAt(1) as Accelerometer;

    final agentData = AgentData(
      userId: _userId,
      accelerometer: accelerometer,
      gps: location,
      timestamp: DateTime.now(),
    );

    // TODO: analyse road state using custom ML model.
    final model = MqttModel(roadState: 'small pits', agentData: agentData);

    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addUTF8String(model.toJson().toString());

    mqttClient.publishMessage(_topic, MqttQos.atLeastOnce, builder.payload!);
  }

  @protected
  Stream<Accelerometer> sensorsStream() => sensors
      .accelerometerEventStream(samplingPeriod: SensorInterval.gameInterval)
      .distinct()
      .map(_mapToAccelerometerState)
      .doOnData(_handleAccelerometerData);

  @protected
  Stream<Location> positionStream() {
    final settings = _configureLocationSettings();
    return Geolocator.getPositionStream(locationSettings: settings)
        .distinct()
        .map(_mapToLocationState)
        .doOnData(_handleLocationData);
  }

  @protected
  List<dynamic> combine(Iterable<Object?> values) => [
        values.elementAt(0),
        values.elementAt(1),
      ];

  Future<void> _connect() async {
    mqttClient = MqttServerClient(state.host ?? _host, '');
    mqttClient.port = state.port ?? _port;

    mqttClient.logging(on: true);

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier('$_userId')
        .startClean()
        .keepAliveFor(60)
        .withWillQos(MqttQos.atLeastOnce);

    mqttClient.connectionMessage = connMess;

    try {
      await mqttClient.connect();
    } catch (e, stack) {
      logger.e('Something went wrong: ', error: e, stackTrace: stack);
      mqttClient.disconnect();
    }
  }

  AndroidSettings _configureLocationSettings() => AndroidSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 100,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 1),
      );

  Location _mapToLocationState(Position? position) => Location(
        latitude: position?.longitude,
        longitude: position?.longitude,
      );

  Accelerometer _mapToAccelerometerState(AccelerometerEvent event) =>
      Accelerometer(
        x: event.x,
        y: event.y,
        z: event.z,
      );

  void _handleAccelerometerData(Accelerometer event) {
    state = state.copyWith(accelerometer: event);
  }

  void _handleLocationData(Location event) {
    state = state.copyWith(location: event);
  }

  void _handleError(Object error, StackTrace stack) {
    logger.e("$this something went wrong.", error: error, stackTrace: stack);
  }

  @override
  Future<void> connect() => _connect();

  @override
  void disconnect() => mqttClient.disconnect();

  @override
  void onHostChanged(String text) {
    state = state.copyWith(host: text);
  }

  @override
  void onPortChanged(String text) {
    state = state.copyWith(port: int.tryParse(text));
  }
}
