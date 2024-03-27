import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/web.dart';

import 'iot/metrics_page.dart';

void main() {
  final logger = Logger();

  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final app = _createApp();
    runApp(app);
  }, (error, stack) {
    logger.e('Something went wrong: ', error: error, stackTrace: stack);
  });
}

Widget _createApp() => _enabledRiverpod(const MainApp());

/// Enables Riverpod for the entire application
Widget _enabledRiverpod(Widget widget) => ProviderScope(child: widget);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        home: MetricsPage(),
        debugShowCheckedModeBanner: kDebugMode,
      );
}
