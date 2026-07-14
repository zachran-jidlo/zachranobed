import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:zachranobed/common/domain/model/delivery.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_outline_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_text_button.dart';
import 'package:zachranobed/common/presentation/widget/donation/ui_donation_status_card.dart';
import 'package:zachranobed/common/presentation/widget/donation/ui_donation_time_range_label.dart';
import 'package:zachranobed/common/presentation/widget/progress/ui_progress_stepper.dart';
import 'package:zachranobed/common/presentation/widget/graphics/ui_icon.dart';

/// A status card widget displaying the current donation state for charity users.
///
/// Shows the delivery progress, status text, delivery time range (when applicable),
/// and action buttons based on the current [delivery] state. The card displays
/// the paired canteen name and allows switching pairs if multiple are available.
///
/// Delivery states and their UI:
/// - **prepared**: Shows "delivery day" message
/// - **accepted/onWayToPickUp (no meals)**: Shows "accepted" message
/// - **accepted/onWayToPickUp (with meals)**: Shows delivery time range and details button
/// - **inDelivery**: Shows delivery time range and details button
/// - **delivered**: Shows completion message
/// - **done**: Shows completion message
/// - **null/notUsed**: Shows "not a delivery day" message
class CharityDonationStatusCard extends StatelessWidget {
  /// The charity user data containing pair information and delivery times.
  final Charity charity;

  /// The current delivery for today, or null if no delivery is scheduled.
  final Delivery? delivery;

  /// Called when the user taps the "Change" button to switch active pair.
  final VoidCallback onChangePairPressed;

  /// Called when the user wants to open delivery detail with already donated meals.
  final Function(String) onDeliveryDetailPressed;

  /// Called when the user confirms they will pick the donation up.
  final VoidCallback onConfirmPickupPressed;

  /// Creates a [CharityDonationStatusCard].
  const CharityDonationStatusCard({
    super.key,
    required this.charity,
    required this.delivery,
    required this.onChangePairPressed,
    required this.onDeliveryDetailPressed,
    required this.onConfirmPickupPressed,
  });

  @override
  Widget build(BuildContext context) {
    return UiDonationStatusCard(
      label: context.l10n.overviewCharityDonationStatusCardLabel,
      title: charity.activePair.donorEstablishmentName,
      headerAction: _buildHeaderAction(context),
      progressBar: _buildProgressBar(context, delivery),
      statusSection: _buildStatusSection(context, delivery),
      actionInfo: _buildActionInfo(context, delivery),
      actionButton: _buildActionButton(context, delivery),
    );
  }

  Widget? _buildHeaderAction(BuildContext context) {
    if (!charity.hasMultiplePairs) {
      return null;
    }

    return UiTextButton(
      text: context.l10n.overviewDonationStatusCardChangeAction,
      icon: Icons.sync,
      onPressed: onChangePairPressed,
    );
  }

  Widget _buildStatusSection(BuildContext context, Delivery? delivery) {
    if (delivery == null || delivery.state == DeliveryState.notUsed) {
      return Text(
        context.l10n.overviewCharityDonationStatusCardNotDeliveryDayLabel,
        style: context.textStyles.bodyMedium.copyWith(
          color: context.uiColors.textSecondary,
        ),
      );
    }

    if (delivery.state == DeliveryState.delivered || delivery.state == DeliveryState.done) {
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
      case DeliveryState.onWayToPickUp:
        if (!delivery.hasMeals) {
          if (delivery.isPickupConfirmationActive(charity) && delivery.isPickupConfirmed) {
            statusText = context.l10n.overviewCharityDonationStatusCardPickupConfirmedLabel;
          } else {
            statusText = context.l10n.overviewCharityDonationStatusCardAcceptedLabel;
          }
        } else {
          statusText = context.l10n.overviewCharityDonationStatusCardOfferedLabel;
        }
        break;
      case DeliveryState.inDelivery:
        statusText = context.l10n.overviewCharityDonationStatusCardOnWayToCustomerLabel;
        break;
      case DeliveryState.delivered:
      case DeliveryState.done:
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
    if (delivery == null || delivery.state == DeliveryState.notUsed) {
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
      case DeliveryState.onWayToPickUp:
        if (!delivery.hasMeals) {
          currentStep = 1;
          isCurrentStepActive = true;
        } else {
          currentStep = 2;
          isCurrentStepActive = true;
        }
        break;
      case DeliveryState.inDelivery:
        currentStep = 4;
        isCurrentStepActive = false;
        break;
      case DeliveryState.delivered:
      case DeliveryState.done:
      case DeliveryState.notUsed:
        currentStep = 5;
        isCurrentStepActive = true;
        break;
    }

    return UiProgressStepper(
      currentStep: currentStep,
      isCurrentStepActive: isCurrentStepActive,
      isProgressComplete: delivery.state == DeliveryState.delivered || delivery.state == DeliveryState.done,
      icons: const [
        UiIconSpec.data(Icons.today_rounded),
        UiIconSpec.data(Icons.food_bank_rounded),
        UiIconSpec.data(Icons.shopping_bag_rounded),
        UiIconSpec.data(Icons.moped_rounded),
        UiIconSpec.data(Icons.check_circle_rounded),
      ],
    );
  }

  Widget? _buildActionInfo(BuildContext context, Delivery? delivery) {
    if (delivery == null) {
      return null;
    }

    if (delivery.isPickupConfirmationActive(charity) && !delivery.isPickupConfirmed) {
      return Text(
        context.l10n.overviewCharityDonationStatusCardConfirmPickupInfoLabel,
        style: context.textStyles.bodyMedium,
      );
    }

    final accepted = delivery.state == DeliveryState.accepted || delivery.state == DeliveryState.onWayToPickUp;
    if (accepted && delivery.hasMeals || delivery.state == DeliveryState.inDelivery) {
      return UiDonationTimeRangeLabel(
        label: context.l10n.overviewDonationStatusCardTimerDeliveryLabel,
        startTime: TimeOfDay(
          hour: charity.activePair.deliveryTimeStart.hour,
          minute: charity.activePair.deliveryTimeStart.minute,
        ),
        endTime: TimeOfDay(
          hour: charity.activePair.deliveryTimeEnd.hour,
          minute: charity.activePair.deliveryTimeEnd.minute,
        ),
      );
    }

    return null;
  }

  Widget? _buildActionButton(BuildContext context, Delivery? delivery) {
    if (delivery == null) {
      return null;
    }

    if (delivery.isPickupConfirmationActive(charity) && !delivery.isPickupConfirmed) {
      return UiPrimaryButton(
        text: context.l10n.overviewCharityDonationStatusCardConfirmPickupAction,
        onPressed: onConfirmPickupPressed,
      );
    }

    final accepted = delivery.state == DeliveryState.accepted || delivery.state == DeliveryState.onWayToPickUp;
    if (accepted && delivery.hasMeals || delivery.state == DeliveryState.inDelivery) {
      return UiOutlineButton(
        text: context.l10n.overviewDonationStatusCardDeliveryDetailsAction,
        icon: Icons.receipt_long,
        onPressed: () {
          onDeliveryDetailPressed(delivery.id);
        },
      );
    }

    return null;
  }
}
