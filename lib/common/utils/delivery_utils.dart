import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/enums/delivery_state.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/services/delivery_service.dart';

class DeliveryUtils {
  static final _deliveryService = GetIt.I<DeliveryService>();

  static Future<void> callACourier(BuildContext context) async {
    await _deliveryService.updateDeliveryStatus(
      context.read<DeliveryNotifier>().delivery!.id,
      DeliveryStateHelper.toValue(DeliveryState.confirmed, context),
    );
    if (context.mounted) {
      context.read<DeliveryNotifier>().updateDeliveryState(
          DeliveryStateHelper.toValue(DeliveryState.confirmed, context));
    }
  }
}
