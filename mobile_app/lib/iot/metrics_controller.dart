import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'metrics_state.dart';

abstract class MetricsController extends StateNotifier<MetricsState> {
  MetricsController(super.state);

  void connect();

  void disconnect();

  void onHostChanged(String text);

  void onPortChanged(String text);

  void turnOnBadRoad();
}
