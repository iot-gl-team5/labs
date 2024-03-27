import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/web.dart';
import 'package:mobile_app/iot/metrics_controller.dart';
import 'package:mobile_app/iot/metrics_controller_adapter.dart';
import 'package:mobile_app/iot/metrics_state.dart';

final metricsStateProvider =
    StateNotifierProvider.autoDispose<MetricsController, MetricsState>(
  (ref) => MetricsControllerAdapter(
    const MetricsState(),
    logger: Logger(),
  ),
);
