import 'package:flutter/material.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';

enum DeliveryState {
  pending,
  confirmed,
  canceled,
}

abstract class DeliveryStateHelper {
  /// Converts a [state] enum value to its corresponding localized string
  /// representation.
  static String toValue(DeliveryState state, BuildContext context) {
    switch (state) {
      case DeliveryState.pending:
        return context.l10n!.deliveryPendingState;
      case DeliveryState.confirmed:
        return context.l10n!.deliveryConfirmedState;
      case DeliveryState.canceled:
        return context.l10n!.deliveryCancelledState;
      default:
        return '';
    }
  }
}
