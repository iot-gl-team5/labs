import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';
import 'package:mobile_app/iot/accelerometer.dart';
import 'package:mobile_app/iot/location.dart';
import 'package:mobile_app/iot/metrics_controller.dart';
import 'package:mobile_app/utils/extensions/subscription_extension.dart';
import 'package:mobile_app/utils/subscription_manager.dart';
import 'package:sensors_plus/sensors_plus.dart' as sensors;
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';

class MetricsControllerAdapter extends MetricsController
    with SubscriptionManager {
  MetricsControllerAdapter(
    super.state, {
    required this.logger,
  }) {
    sensors
        .accelerometerEventStream(samplingPeriod: SensorInterval.gameInterval)
        .distinct()
        .map(_mapToAccelerometerState)
        .listen(_handleAccelerometerData, onError: _handleError)
        .addToList(this);

    Geolocator.requestPermission();
    final settings = _configureLocationSettings();
    Geolocator.getPositionStream(locationSettings: settings)
        .distinct()
        .map(_mapToLocationState)
        .listen(_handleLocationData, onError: _handleError)
        .addToList(this);
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

  @protected
  final Logger logger;

  @override
  void dispose() {
    cancelSubscriptions();
    super.dispose();
  }

  @override
  void connect() {
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  void disconnect() {
    // TODO: implement disconnect
    throw UnimplementedError();
  }
}
