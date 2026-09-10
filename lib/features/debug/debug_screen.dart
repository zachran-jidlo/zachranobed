import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/domain/usecase/create_food_delivery_use_case.dart';
import 'package:zachranobed/common/domain/utils/zo_logger.dart';
import 'package:zachranobed/common/presentation/notifiers/delivery_notifier.dart';
import 'package:zachranobed/common/presentation/notifiers/user_notifier.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_list_tile.dart';
import 'package:zachranobed/common/presentation/widget/layout/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/navigation/ui_app_bar.dart';

@RoutePage()
class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universal(
      appBar: const UiAppBar(
        title: "Debug Screen",
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 16.0,
            children: <Widget>[
              UiPrimaryButton(
                size: UiButtonSize.medium(),
                text: "Test log",
                icon: MaterialSymbols.bug_report,
                onPressed: () {
                  ZOLogger.logMessage("This is a debug message to the logger to verify, how the logger works");
                },
              ),
              UiPrimaryButton(
                size: UiButtonSize.medium(),
                text: "Components screen",
                onPressed: () {
                  context.router.push(const ComponentsRoute());
                },
              ),
              _buildDeliveryDebugTile(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryDebugTile(BuildContext context) {
    final user = context.watch<UserNotifier>().user;
    if (user == null || user is! Canteen) {
      return const SizedBox.shrink();
    }

    final deliveryNotifier = context.watch<DeliveryNotifier>();
    final delivery = deliveryNotifier.delivery;

    if (delivery == null) {
      return UiListTile(
        title: "No active delivery",
        supportingText: "Tap on 'Create' to create a new one",
        end: UiPrimaryButton(
          size: UiButtonSize.tiny(),
          text: "Create",
          onPressed: () async {
            final createDelivery = GetIt.I<CreateFoodDeliveryUseCase>();
            await createDelivery.invoke(user);
          },
        ),
      );
    }

    return UiListTile(
      title: "Delivery is created",
      supportingText: //
          "ID: ${delivery.id}\n\n"
          "State: ${delivery.state.name}\n\n"
          "Pick-up: ${user.activePair.pickupTimeStart}-${user.activePair.pickupTimeEnd}\n\n"
          "Delivery: ${user.activePair.deliveryTimeStart}-${user.activePair.deliveryTimeEnd}\n\n"
          "Must be confirmed until: ${user.activePair.pickupTimeStart.atToday().subtract(delivery.confirmationTime)}",
    );
  }
}
