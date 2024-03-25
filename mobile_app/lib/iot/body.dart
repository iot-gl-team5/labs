part of 'metrics_page.dart';

final _provider = metricsStateProvider;

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_provider);
    final controller = ref.watch(_provider.notifier);

    return Center(
      child: Column(
        children: [
          Row(
            children: const [
              Text(_accelerometerMetricText),
              Text(_locationMetricText)
            ],
          ),
          Row(
            children: [
              TextButton.icon(
                onPressed: controller.connect,
                icon: const Icon(Icons.connect_without_contact_sharp),
                label: Text('connect'),
              ),
              TextButton.icon(
                onPressed: controller.disconnect,
                icon: const Icon(Icons.cancel_rounded),
                label: Text('disconnect'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

const _accelerometerMetricText = 'Accelerometer Data:';
const _locationMetricText = 'Location Data:';
