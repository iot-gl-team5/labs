import 'dart:async';

import '../subscription_manager.dart';

/// Extension on [StreamSubscription] to add a subscription to a
/// [SubscriptionManager].
extension SubscriptionExtension on StreamSubscription {
  /// Adds the current subscription to the given [SubscriptionManager].
  ///
  /// The subscription will be removed from the manager automatically when it is
  ///  canceled or paused.
  void addToList(SubscriptionManager manager) => manager.addSubscription(this);
}
