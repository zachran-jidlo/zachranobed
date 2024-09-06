import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/models/canteen.dart';
import 'package:zachranobed/models/delivery.dart';
import 'package:zachranobed/models/user_data.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';

import 'button.dart';
import 'donation_countdown_timer.dart';
import 'info_banner.dart';

/// A widget that displays an information banner based on the current user and delivery state.
///
/// This widget is a [StatelessWidget], which means that it describes part of the user interface which can depend on
/// configuration information in the constructor and change over time as it's rebuilt.
///
/// The widget requires a [UserData] object as a parameter, which represents the current user.
class DeliveryInfoBanner extends StatelessWidget {
  final UserData user;

  const DeliveryInfoBanner({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final user = HelperService.getCurrentUser(context);
    final delivery = context.watch<DeliveryNotifier>().delivery;

    if (user is! Canteen ||
        delivery == null ||
        !HelperService.canDonate(context)) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    switch (delivery.state) {
      case DeliveryState.accepted:
      case DeliveryState.offered:
        if (user.isCurrentTimeWithinPickupRange()) {
          return _buildDeliveryConfirmedBanner(context, user);
        } else {
          return const SliverToBoxAdapter(child: SizedBox());
        }
      default:
        return _buildDonationCountdownBanner(context, delivery);
    }
  }

  Widget _buildDeliveryConfirmedBanner(BuildContext context, Canteen user) {
    return SliverToBoxAdapter(
      child: InfoBanner(
        backgroundColor: ZOColors.successLight,
        message: Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            text: '${context.l10n!.courierWillCome} ',
            style: const TextStyle(
              color: ZOColors.onPrimaryLight,
              fontSize: FontSize.s,
            ),
            children: <InlineSpan>[
              TextSpan(
                text: '${user.pickUpFrom} a ${user.pickUpWithin}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDonationCountdownBanner(
    BuildContext context,
    Delivery delivery,
  ) {
    return SliverToBoxAdapter(
      child: InfoBanner(
        backgroundColor: ZOColors.successLight,
        message: DonationCountdownTimer(delivery: delivery),
        button: ZOButton(
          text: context.l10n!.wantToDonate,
          minimumSize: ZOButtonSize.tiny(),
          type: ZOButtonType.success,
          onPressed: () {
            context
                .read<DeliveryNotifier>()
                .updateDeliveryState(DeliveryState.accepted);
          },
        ),
      ),
    );
  }
}
