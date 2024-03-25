import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';

import 'iot/metrics_page.dart';

void main() {
  final logger = Logger();

  runZonedGuarded(() {
    final app = _createApp();
    runApp(app);
  }, (error, stack) {
    logger.e('Something went wrong: ', error: error, stackTrace: stack);
  });
}

Widget _createApp() => const MainApp();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        home: MetricsPage(),
        debugShowCheckedModeBanner: kDebugMode,
      );
}
