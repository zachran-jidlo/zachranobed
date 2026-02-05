import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:zachranobed/app/presentation/widget/ticking_donation_countdown_label.dart';
import 'package:zachranobed/common/domain/model/delivery.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_outline_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_text_button.dart';
import 'package:zachranobed/common/presentation/widget/donation/ui_donation_status_card.dart';
import 'package:zachranobed/common/presentation/widget/donation/ui_donation_time_range_label.dart';
import 'package:zachranobed/common/presentation/widget/progress/ui_progress_stepper.dart';
import 'package:zachranobed/common/presentation/widget/ui_icon.dart';

/// A status card widget displaying the current donation state for canteen users.
///
/// Shows the delivery progress, status text, countdown timer (when applicable),
/// and action buttons based on the current [delivery] state. The card displays
/// the paired charity name and allows switching pairs if multiple are available.
///
/// Delivery states and their UI:
/// - **prepared**: Shows countdown timer and "Accept" button
/// - **accepted/offered**: Shows pickup time range and "Offer Food" button
/// - **inDelivery**: Shows delivery time range
/// - **delivered**: Shows completion message
/// - **null/notUsed**: Shows "not a delivery day" message
class CanteenDonationStatusCard extends StatelessWidget {
  /// The canteen user data containing pair information and pickup times.
  final Canteen canteen;

  /// The current delivery for today, or null if no delivery is scheduled.
  final Delivery? delivery;

  /// Called when the user taps the "Change" button to switch active pair.
  final VoidCallback onChangePairPressed;

  /// Called when the user accepts the delivery in "prepared" state.
  final VoidCallback onAcceptDeliveryPressed;

  /// Called when the user wants to offer food after accepting delivery.
  final VoidCallback onOfferFoodPressed;

  /// Called when the user wants to open delivery detail with already donated meals.
  final Function(String) onDeliveryDetailPressed;

  /// Called when the confirmation countdown timer reaches zero.
  final VoidCallback onCountdownTimeout;

  /// Creates a [CanteenDonationStatusCard].
  const CanteenDonationStatusCard({
    super.key,
    required this.canteen,
    required this.delivery,
    required this.onChangePairPressed,
    required this.onAcceptDeliveryPressed,
    required this.onOfferFoodPressed,
    required this.onDeliveryDetailPressed,
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
      final pickupEndTime = canteen.activePair.pickupTimeStart.atToday();
      final deadline = pickupEndTime.subtract(delivery.confirmationTime);
      return TickingDonationCountdownLabel(
        deadline: deadline,
        label: context.l10n.overviewDonationStatusCardTimerCountdownLabel,
        onTimeout: onCountdownTimeout,
      );
    }

    if (delivery.state == DeliveryState.accepted || delivery.state == DeliveryState.offered) {
      return UiDonationTimeRangeLabel(
        label: context.l10n.overviewDonationStatusCardTimerPickUpLabel,
        startTime: TimeOfDay(
          hour: canteen.activePair.pickupTimeStart.hour,
          minute: canteen.activePair.pickupTimeStart.minute,
        ),
        endTime: TimeOfDay(
          hour: canteen.activePair.pickupTimeEnd.hour,
          minute: canteen.activePair.pickupTimeEnd.minute,
        ),
      );
    }

    return UiDonationTimeRangeLabel(
      label: context.l10n.overviewDonationStatusCardTimerDeliveryLabel,
      startTime: TimeOfDay(
        hour: canteen.activePair.deliveryTimeStart.hour,
        minute: canteen.activePair.deliveryTimeStart.minute,
      ),
      endTime: TimeOfDay(
        hour: canteen.activePair.deliveryTimeEnd.hour,
        minute: canteen.activePair.deliveryTimeEnd.minute,
      ),
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

    if (delivery.hasMeals) {
      return UiOutlineButton(
        text: context.l10n.overviewDonationStatusCardDeliveryDetailsAction,
        icon: Icons.receipt_long,
        onPressed: () {
          onDeliveryDetailPressed(delivery.id);
        },
      );
    }

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

    if (delivery.state == DeliveryState.prepared && !canteen.isCurrentTimeWithinPickupRange()) {
      return false;
    }

    return true;
  }
}
