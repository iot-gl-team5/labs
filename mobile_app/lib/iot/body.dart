part of 'metrics_page.dart';

final _provider = metricsStateProvider;

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_provider);
    final controller = ref.watch(_provider.notifier);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          children: [
            TextFormField(
              onChanged: controller.onHostChanged,
              autocorrect: false,
              autofocus: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(hintText: 'Host'),
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
            ),
            const SizedBox(height: 16),
            TextFormField(
              onChanged: controller.onPortChanged,
              autocorrect: false,
              autofocus: true,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(hintText: 'Port'),
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
            ),
            const SizedBox(height: 32),
            _Metrics(state: state),
            const Spacer(),
            _Actions(controller: controller),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  label: Text(
                      'Turn ${(state.isBadRoad ?? false) ? 'off' : 'on'} bad road'),
                  onPressed: controller.turnOnBadRoad,
                  icon: const Icon(Icons.warning),
                ),
                Text('${state.isBadRoad ?? false}')
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _Metrics extends StatelessWidget {
  const _Metrics({required this.state});

  final MetricsState state;

  @override
  Widget build(BuildContext context) {
    final accelerometer = Text(
      '\nx: ${state.accelerometer?.x}\ny: ${state.accelerometer?.y}\nz: ${state.accelerometer?.z}',
    );
    final coordinates = Text(
      '\nlon: ${state.location?.longitude ?? 'fetching'}\nlat: ${state.location?.latitude ?? 'fetching'}',
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(children: [const Text(_accelerometerMetricText), accelerometer]),
        const SizedBox(height: 16),
        Column(children: [const Text(_locationMetricText), coordinates])
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.controller});

  final MetricsController controller;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton.icon(
            onPressed: controller.connect,
            icon: const Icon(Icons.connect_without_contact_sharp),
            label: const Text(_connectText),
          ),
          TextButton.icon(
            onPressed: controller.disconnect,
            icon: const Icon(Icons.cancel_rounded),
            label: const Text(_disconnectText),
          ),
        ],
      );
}

const _accelerometerMetricText = 'Accelerometer Data';
const _locationMetricText = 'Location Data';
const _disconnectText = 'Disconnect';
const _connectText = 'Connect';
