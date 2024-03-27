import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/iot/metrics_controller.dart';
import 'package:mobile_app/iot/metrics_state.dart';
import 'package:mobile_app/iot/providers.dart';

part 'custom_app_bar.dart';
part 'body.dart';

class MetricsPage extends StatelessWidget {
  const MetricsPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        appBar: _CustomAppBar(),
        body: _Body(),
      );
}
