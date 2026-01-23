import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:styled_text/styled_text.dart';
import 'package:zachranobed/common/domain/model/charity.dart';
import 'package:zachranobed/common/domain/model/delivery.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_outline_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_text_button.dart';
import 'package:zachranobed/common/presentation/widget/donation/ui_donation_status_card.dart';
import 'package:zachranobed/common/presentation/widget/donation/ui_donation_time_range_label.dart';
import 'package:zachranobed/common/presentation/widget/progress/ui_progress_stepper.dart';
import 'package:zachranobed/common/presentation/widget/ui_icon.dart';

class CharityDonationStatusCard extends StatelessWidget {
  final Charity charity;
  final Delivery? delivery;
  final VoidCallback onChangePairPressed;

  const CharityDonationStatusCard({
    super.key,
    required this.charity,
    required this.delivery,
    required this.onChangePairPressed,
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
        if (!delivery.hasMeals) {
          statusText = context.l10n.overviewCharityDonationStatusCardAcceptedLabel;
        } else {
          statusText = context.l10n.overviewCharityDonationStatusCardOfferedLabel;
        }
        break;
      case DeliveryState.inDelivery:
        statusText = context.l10n.overviewCharityDonationStatusCardOnWayToCustomerLabel;
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
      case DeliveryState.offered:
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

    final accepted = delivery.state == DeliveryState.accepted || delivery.state == DeliveryState.offered;
    if (accepted && delivery.hasMeals || delivery.state == DeliveryState.inDelivery) {
      final startTime = DateFormat('HH:mm').parse(charity.activePair.deliveryTimeStart);
      final endTime = DateFormat('HH:mm').parse(charity.activePair.deliveryTimeEnd);
      return UiDonationTimeRangeLabel(
        startTime: TimeOfDay(hour: startTime.hour, minute: startTime.minute),
        endTime: TimeOfDay(hour: endTime.hour, minute: endTime.minute),
        label: context.l10n.overviewDonationStatusCardTimerDeliveryLabel,
      );
    }

    return null;
  }

  Widget? _buildActionButton(BuildContext context, Delivery? delivery) {
    if (delivery == null) {
      return null;
    }

    final accepted = delivery.state == DeliveryState.accepted || delivery.state == DeliveryState.offered;
    if (accepted && delivery.hasMeals || delivery.state == DeliveryState.inDelivery) {
      // TODO: Add action button
      return UiOutlineButton(
        text: context.l10n.overviewDonationStatusCardDeliveryDetailsAction,
        icon: Icons.receipt_long,
        onPressed: () {},
      );
    }

    return null;
  }
}
