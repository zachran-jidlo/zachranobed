import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:styled_text/styled_text.dart';
import 'package:zachranobed/app/presentation/widget/ticking_donation_countdown_label.dart';
import 'package:zachranobed/common/domain/model/canteen.dart';
import 'package:zachranobed/common/domain/model/delivery.dart';
import 'package:zachranobed/common/domain/utils/date_time_utils.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_text_button.dart';
import 'package:zachranobed/common/presentation/widget/donation/ui_donation_status_card.dart';
import 'package:zachranobed/common/presentation/widget/donation/ui_donation_time_range_label.dart';
import 'package:zachranobed/common/presentation/widget/progress/ui_progress_stepper.dart';
import 'package:zachranobed/common/presentation/widget/ui_icon.dart';

class CanteenDonationStatusCard extends StatelessWidget {
  final Canteen canteen;
  final Delivery? delivery;
  final VoidCallback onChangePairPressed;
  final VoidCallback onAcceptDeliveryPressed;
  final VoidCallback onOfferFoodPressed;
  final VoidCallback onCountdownTimeout;

  const CanteenDonationStatusCard({
    super.key,
    required this.canteen,
    required this.delivery,
    required this.onChangePairPressed,
    required this.onAcceptDeliveryPressed,
    required this.onOfferFoodPressed,
    required this.onCountdownTimeout,
  });

  @override
  Widget build(BuildContext context) {
    return UiDonationStatusCard(
      label: context.l10n.overviewCanteenDonationStatusCardLabel,
      title: canteen.activePair.recipientEstablishmentName,
      headerAction: _buildHeaderAction(context),
      progressBar: _buildProgressBar(context, delivery),
      statusSection: _buildStatusSection(context, delivery),
      actionInfo: _buildActionInfo(context, delivery),
      actionButton: _buildActionButton(context, delivery),
    );
  }

  Widget? _buildHeaderAction(BuildContext context) {
    if (!canteen.hasMultiplePairs) {
      return null;
    }

    return UiTextButton(
      text: context.l10n.overviewDonationStatusCardChangeAction,
      icon: Icons.sync,
      onPressed: onChangePairPressed,
    );
  }

  Widget _buildStatusSection(BuildContext context, Delivery? delivery) {
    if (delivery == null || !_canDonate(delivery)) {
      return Text(
        context.l10n.overviewCanteenDonationStatusCardNotDeliveryDayLabel,
        style: context.textStyles.bodyMedium.copyWith(
          color: context.uiColors.textSecondary,
        ),
      );
    }

    if (delivery.state == DeliveryState.delivered) {
      return StyledText(
        text: context.l10n.overviewDonationStatusCardDoneLabel,
        style: context.textStyles.bodyMedium,
        tags: {
          "success": StyledTextTag(
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: context.uiColors.success,
            ),
          ),
        },
      );
    }

    var statusText = "";

    switch (delivery.state) {
      case DeliveryState.prepared:
        statusText = context.l10n.overviewDonationStatusCardDeliveryDayLabel;
        break;
      case DeliveryState.accepted:
      case DeliveryState.offered:
        // TODO: Set correct status text
        statusText = context.l10n.overviewCanteenDonationStatusCardAcceptedLabel;
        break;
      case DeliveryState.inDelivery:
        statusText = context.l10n.overviewCanteenDonationStatusCardOnWayToCustomerLabel;
        break;
      case DeliveryState.delivered:
      case DeliveryState.notUsed:
        // No-op, handled above
        break;
    }

    return Text(
      statusText,
      style: context.textStyles.bodyMedium,
    );
  }

  Widget? _buildProgressBar(BuildContext context, Delivery? delivery) {
    if (delivery == null || !_canDonate(delivery)) {
      return null;
    }

    int currentStep;
    bool isCurrentStepActive;

    switch (delivery.state) {
      case DeliveryState.prepared:
        currentStep = 1;
        isCurrentStepActive = false;
        break;
      case DeliveryState.accepted:
      case DeliveryState.offered:
        currentStep = 2;
        isCurrentStepActive = false;
        break;
      case DeliveryState.inDelivery:
        currentStep = 3;
        isCurrentStepActive = true;
        break;
      case DeliveryState.delivered:
      case DeliveryState.notUsed:
        currentStep = 5;
        isCurrentStepActive = true;
        break;
    }

    return UiProgressStepper(
      currentStep: currentStep,
      isCurrentStepActive: isCurrentStepActive,
      isProgressComplete: delivery.state == DeliveryState.delivered,
      icons: const [
        UiIconSpec.data(Icons.today_rounded),
        UiIconSpec.svg(ImageAssets.iconDeliveryAccept),
        UiIconSpec.data(Icons.food_bank_rounded),
        UiIconSpec.svg(ImageAssets.iconDeliveryRun),
        UiIconSpec.data(Icons.check_circle_rounded),
      ],
    );
  }

  Widget? _buildActionInfo(BuildContext context, Delivery? delivery) {
    if (delivery == null || !_canDonate(delivery) || delivery.state == DeliveryState.delivered) {
      return null;
    }

    if (delivery.state == DeliveryState.prepared) {
      final pickupEndTime = DateTimeUtils.getDateTimeOfCurrentDelivery(canteen.activePair.pickupTimeStart);
      final deadline = pickupEndTime.subtract(Duration(minutes: delivery.confirmationTime));
      return TickingDonationCountdownLabel(
        deadline: deadline,
        label: context.l10n.overviewDonationStatusCardTimerCountdownLabel,
        onTimeout: onCountdownTimeout,
      );
    }

    if (delivery.state == DeliveryState.accepted || delivery.state == DeliveryState.offered) {
      final startTime = DateFormat('HH:mm').parse(canteen.activePair.pickupTimeStart);
      final endTime = DateFormat('HH:mm').parse(canteen.activePair.pickupTimeEnd);
      return UiDonationTimeRangeLabel(
        startTime: TimeOfDay(hour: startTime.hour, minute: startTime.minute),
        endTime: TimeOfDay(hour: endTime.hour, minute: endTime.minute),
        label: context.l10n.overviewDonationStatusCardTimerPickUpLabel,
      );
    }

    final startTime = DateFormat('HH:mm').parse(canteen.activePair.deliveryTimeStart);
    final endTime = DateFormat('HH:mm').parse(canteen.activePair.deliveryTimeEnd);
    return UiDonationTimeRangeLabel(
      startTime: TimeOfDay(hour: startTime.hour, minute: startTime.minute),
      endTime: TimeOfDay(hour: endTime.hour, minute: endTime.minute),
      label: context.l10n.overviewDonationStatusCardTimerDeliveryLabel,
    );
  }

  Widget? _buildActionButton(BuildContext context, Delivery? delivery) {
    if (delivery == null || !_canDonate(delivery) || delivery.state == DeliveryState.delivered) {
      return null;
    }

    if (delivery.state == DeliveryState.prepared) {
      return UiPrimaryButton(
        text: context.l10n.overviewCanteenDonationStatusCardAcceptAction,
        onPressed: onAcceptDeliveryPressed,
      );
    }

    // TODO: Add action button
    // if (delivery.hasMeals) {
    //   return UiOutlineButton(
    //     text: context.l10n.overviewDonationStatusCardDeliveryDetailsAction,
    //     icon: Icons.receipt_long,
    //     onPressed: () {},
    //   );
    // }

    return UiPrimaryButton(
      text: context.l10n.overviewCanteenDonationStatusCardOfferAction,
      onPressed: onOfferFoodPressed,
    );
  }

  bool _canDonate(Delivery delivery) {
    if (delivery.recipientId != canteen.activePair.recipientId) {
      return false;
    }

    if (delivery.state == DeliveryState.notUsed) {
      return false;
    }

    final time = DateTimeUtils.getDateTimeOfCurrentDelivery(canteen.activePair.pickupTimeStart);
    final pickupDuration = Duration(minutes: delivery.confirmationTime);
    final canDonateUntil = time.subtract(pickupDuration);
    if (delivery.state == DeliveryState.prepared && DateTime.now().isAfter(canDonateUntil)) {
      return false;
    }

    return true;
  }
}
