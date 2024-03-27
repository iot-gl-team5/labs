import 'dart:async';

/// Encapsulates management of [StreamSubscription]s.
mixin SubscriptionManager {
  final List<StreamSubscription> _subscriptions = [];

  /// Cancel all [StreamSubscription]s managed by this manager.
  void cancelSubscriptions() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }

  /// Manage the given [subscription].
  void addSubscription(StreamSubscription subscription) {
    _subscriptions.add(subscription);
  }
}
