import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/domain/model/food_boxes_checkup_state.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/card/ui_notification_tile.dart';
import 'package:zachranobed/common/presentation/widget/layout/content_with_loading.dart';
import 'package:zachranobed/common/presentation/widget/overlay/ui_temporary_snackbar.dart';
import 'package:zachranobed/features/banners/domain/model/banner.dart';
import 'package:zachranobed/features/banners/presentation/widget/banner_tile.dart';
import 'package:zachranobed/features/food/domain/usecase/delay_food_boxes_checkup_use_case.dart';
import 'package:zachranobed/features/food/presentation/widget/checkup/food_boxes_checkup_tile_check_needed.dart';

/// A section that displays actionable messages and notifications to the user.
///
/// Shows dynamic banners on top, followed by the food boxes checkup tile when a
/// regular checkup is needed and the manual donation entry card.
class MessagesSection extends StatefulWidget {
  /// The user data to display messages for.
  final UserData user;

  /// Dynamic banners to show, already filtered and sorted by priority.
  final List<Banner> banners;

  /// Called with the banner ID when the user closes a closable banner.
  final void Function(String id) onBannerDismiss;

  /// The current state of the food boxes checkup.
  final FoodBoxesCheckupState checkupState;

  /// Refreshes the state of the food boxes checkup.
  final VoidCallback refreshCheckupState;

  /// Called when the user chooses to record a donation from the manual donation
  /// entry card, switching to the History tab.
  final VoidCallback onNavigateToHistoryPressed;

  /// Creates a [MessagesSection] widget.
  const MessagesSection({
    super.key,
    required this.user,
    required this.banners,
    required this.onBannerDismiss,
    required this.checkupState,
    required this.refreshCheckupState,
    required this.onNavigateToHistoryPressed,
  });

  @override
  State<MessagesSection> createState() => _MessagesSectionState();
}

class _MessagesSectionState extends State<MessagesSection> {
  late final DelayFoodBoxesCheckupUseCase _delayCheckup;
  bool _isFoodBoxesCheckupLoading = false;

  @override
  void initState() {
    super.initState();
    _delayCheckup = GetIt.I<DelayFoodBoxesCheckupUseCase>();
  }

  @override
  Widget build(BuildContext context) {
    final messages = _buildMessages(context, widget.user);

    if (messages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 8.0,
        children: messages,
      ),
    );
  }

  List<Widget> _buildMessages(BuildContext context, UserData user) {
    final messages = <Widget>[];

    for (final banner in widget.banners) {
      messages.add(
        BannerTile(
          banner: banner,
          onDismiss: () => widget.onBannerDismiss(banner.id),
        ),
      );
    }

    if (widget.checkupState case FoodBoxesCheckupCheckNeeded(isDelayAvailable: final isDelayAvailable)) {
      messages.add(
        _buildFoodBoxesCheckupTileCheckNeeded(context, user, isDelayAvailable),
      );
    }

    if (user.manualDonationEnabled) {
      messages.add(_buildManualDonationTile(context));
    }

    return messages;
  }

  Widget _buildManualDonationTile(BuildContext context) {
    return UiNotificationTile(
      title: context.l10n.manualDonationCardTitle,
      description: context.l10n.manualDonationCardGoToHistoryDescription,
      actions: [
        UiPrimaryButton(
          text: context.l10n.manualDonationGoToHistoryAction,
          size: UiButtonSize.medium(fullWidth: true),
          onPressed: () => widget.onNavigateToHistoryPressed(),
        ),
      ],
    );
  }

  Widget _buildFoodBoxesCheckupTileCheckNeeded(BuildContext context, UserData user, bool isDelayAvailable) {
    return ContentWithLoading(
      isLoading: _isFoodBoxesCheckupLoading,
      child: FoodBoxesCheckupTileCheckNeeded(
        isDelayAvailable: isDelayAvailable,
        onDelayPressed: () async {
          setState(() {
            _isFoodBoxesCheckupLoading = true;
          });

          final success = await _delayCheckup.invoke(user);
          if (context.mounted) {
            if (success) {
              await HelperService.loadUserInfo(context);
              widget.refreshCheckupState();
            } else {
              UiTemporarySnackBar.showError(context, message: context.l10n.foodBoxesCheckupErrorMessage);
            }
          }

          setState(() {
            _isFoodBoxesCheckupLoading = false;
          });
        },
        onCheckPressed: () {
          context.router.push(
            FoodBoxesDetailRoute(
              user: user,
              isCheckupMode: true,
            ),
          );
        },
      ),
    );
  }
}
