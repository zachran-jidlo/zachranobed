import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';

import '../../common/constants.dart';
import '../../common/helper_service.dart';
import '../../models/canteen.dart';
import '../../models/delivery.dart';
import '../../models/user_data.dart';
import '../../notifiers/delivery_notifier.dart';
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

    if (user is! Canteen || !HelperService.canDonate(context)) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    switch (delivery?.state) {
      case DeliveryState.accepted:
      case DeliveryState.offered:
        if (user.isCurrentTimeWithinPickupRange()) {
          return _buildDeliveryConfirmedBanner(context, user);
        } else {
          return const SliverToBoxAdapter(child: SizedBox());
        }
      default:
        return _buildDonationCountdownBanner(context);
    }
  }

  Widget _buildDeliveryConfirmedBanner(BuildContext context, Canteen user) {
    return SliverToBoxAdapter(
      child: InfoBanner(
        infoText: context.l10n!.courierWillCome,
        infoValue: Text(
          '${user.pickUpFrom} a ${user.pickUpWithin}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: FontSize.s,
            color: ZOColors.onPrimaryLight,
          ),
        ),
        backgroundColor: ZOColors.successLight,
      ),
    );
  }

  Widget _buildDonationCountdownBanner(BuildContext context) {
    return SliverToBoxAdapter(
      child: InfoBanner(
        infoText: context.l10n!.youCanDonate,
        infoValue: const DonationCountdownTimer(),
        button: ZOButton(
          text: context.l10n!.callACourier,
          fullWidth: false,
          type: ZOButtonType.success,
          onPressed: () {
            context
                .read<DeliveryNotifier>()
                .updateDeliveryState(DeliveryState.accepted);
          },
        ),
        backgroundColor: ZOColors.successLight,
      ),
    );
  }
}
