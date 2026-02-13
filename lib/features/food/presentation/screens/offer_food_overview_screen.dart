import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/presentation/notifiers/delivery_notifier.dart';
import 'package:zachranobed/common/presentation/router/app_router.gr.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';
import 'package:zachranobed/common/presentation/utils/helper_service.dart';
import 'package:zachranobed/common/presentation/utils/image_assets.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_button_size.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_icon_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_primary_button.dart';
import 'package:zachranobed/common/presentation/widget/button/ui_text_button.dart';
import 'package:zachranobed/common/presentation/widget/other/adaptive_content.dart';
import 'package:zachranobed/common/presentation/widget/other/section_header.dart';
import 'package:zachranobed/common/presentation/widget/page/info_page.dart';
import 'package:zachranobed/common/presentation/widget/screen_scaffold.dart';
import 'package:zachranobed/common/presentation/widget/snackbar/ui_temporary_snackbar.dart';
import 'package:zachranobed/common/presentation/widget/ui_app_bar.dart';
import 'package:zachranobed/common/presentation/widget/ui_checkbox.dart';
import 'package:zachranobed/common/presentation/widget/ui_dialog.dart';
import 'package:zachranobed/common/presentation/widget/ui_gradient_icon.dart';
import 'package:zachranobed/common/presentation/widget/ui_icon.dart';
import 'package:zachranobed/common/presentation/widget/ui_list_tile.dart';
import 'package:zachranobed/common/presentation/widget/ui_notification_tile.dart';
import 'package:zachranobed/features/food/domain/model/food_box_type.dart';
import 'package:zachranobed/features/food/domain/model/food_info.dart';
import 'package:zachranobed/features/food/domain/usecase/create_food_offer_use_case.dart';
import 'package:zachranobed/features/food/domain/usecase/verify_available_box_count_use_case.dart';
import 'package:zachranobed/features/food/presentation/screens/offer_food_detail_screen.dart';

/// A screen that displays an overview of food items to be offered as a donation.
///
/// Allows canteen users to review the list of food items they want to donate,
/// add or edit food items, specify the number of returnable boxes, and confirm
/// the donation. Shows a dismissible banner reminding users to verify counts
/// before submission.
///
/// Displays an empty state when no food items have been added yet, with options
/// to add new items or close the screen.
@RoutePage()
class OfferFoodOverviewScreen extends StatefulWidget {
  /// The initial list of food items to display.
  final List<FoodInfo> initialFoodInfos;

  /// Creates an [OfferFoodOverviewScreen].
  const OfferFoodOverviewScreen({
    super.key,
    required this.initialFoodInfos,
  });

  @override
  State<OfferFoodOverviewScreen> createState() => _OfferFoodOverviewScreenState();
}

class _OfferFoodOverviewScreenState extends State<OfferFoodOverviewScreen> {
  final _createFoodOffer = GetIt.I<CreateFoodOfferUseCase>();
  final _verifyAvailableBoxCount = GetIt.I<VerifyAvailableBoxCountUseCase>();

  final _foodInfos = <FoodInfo>[];
  final _boxInfos = <FoodBoxType, int>{};

  var _isEmptyConfirmed = false;
  var _isBannerDismissed = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      _foodInfos.addAll(widget.initialFoodInfos);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold.universalBuilder(
      appBar: UiAppBar(
        title: context.l10n.offerFoodOverviewScreenTitle,
      ),
      builder: (context) {
        if (_foodInfos.isEmpty) {
          return _buildEmptyPage();
        }

        return _buildContent(context);
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showCancelConfirmationDialog();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: _buildSummary(context),
            ),
          ),
          _buildBottomButton(context),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    return Column(
      children: [
        if (!_isBannerDismissed)
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: 32.0,
            ),
            child: UiNotificationTile(
              icon: Icons.warning_rounded,
              title: context.l10n.offerFoodOverviewBannerTitle,
              description: context.l10n.offerFoodOverviewBannerDescription,
              trailing: UiIconButton.solid(
                icon: Icons.close,
                onPressed: () => setState(() => _isBannerDismissed = true),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              OfferFoodOverviewFoodSection(
                foodInfos: _foodInfos,
                onAddPressed: _onAddNewFoodPressed,
                onEditPressed: _onEditFoodPressed,
              ),
              const SizedBox(height: 48),
              OfferFoodOverviewBoxSection(
                boxInfos: _boxInfos,
                onEditPressed: _onEditBoxesPressed,
                isEmptyConfirmed: _isEmptyConfirmed,
                onEmptyConfirmedChanged: (value) {
                  setState(() {
                    _isEmptyConfirmed = value;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    final isMobileLayout = context.watch<AdaptiveLayoutConfig>().isMobile;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Flex(
        spacing: 16.0,
        direction: isMobileLayout ? Axis.vertical : Axis.horizontal,
        children: [
          UiPrimaryButton(
            size: UiButtonSize.medium(fullWidth: isMobileLayout),
            text: context.l10n.offerFood,
            enabled: _isEmptyConfirmed || _boxInfos.isNotEmpty,
            onPressed: _onConfirmationButtonPressed,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPage() {
    return InfoPage(
      image: ImageAssets.imageEmptyMeals,
      title: context.l10n.offerFoodOverviewEmptyTitle,
      description: context.l10n.offerFoodOverviewEmptyDescription,
      actions: [
        Column(
          spacing: 16.0,
          children: [
            UiPrimaryButton(
              size: UiButtonSize.medium(fullWidth: true),
              text: context.l10n.offerFoodOverviewEmptyAction,
              onPressed: _onAddNewFoodPressed,
            ),
            UiTextButton(
              text: context.l10n.commonClose,
              onPressed: () => context.router.maybePop(),
            ),
          ],
        )
      ],
    );
  }

  Future<bool> _offerFood() async {
    final delivery = context.read<DeliveryNotifier>().delivery;
    if (delivery == null) {
      return false;
    }

    final boxInfo = _boxInfos.map((type, quantity) => MapEntry(type.id, quantity));
    return _createFoodOffer.invoke(
      delivery: delivery,
      foodInfo: _foodInfos,
      boxInfo: boxInfo,
    );
  }

  void _onAddNewFoodPressed() async {
    final result = await context.router.push(
      const OfferFoodAddNewRoute(),
    );
    _handleDetailResult(
      result: result as OfferFoodDetailResult?,
    );
  }

  void _onEditFoodPressed(FoodInfo food) async {
    final result = await context.router.push(
      OfferFoodEditExistingRoute(foodInfo: food),
    );
    _handleDetailResult(
      oldFoodInfo: food,
      result: result as OfferFoodDetailResult?,
    );
  }

  void _onEditBoxesPressed() async {
    final result = await context.router.push(
      OfferFoodBoxesRoute(
        currentBoxesQuantity: _boxInfos,
      ),
    );
    final newQuantity = result as Map<FoodBoxType, int>?;
    if (newQuantity != null) {
      setState(() {
        _boxInfos.clear();
        _boxInfos.addAll(newQuantity);
      });
    }
  }

  void _onConfirmationButtonPressed() async {
    UiDialog.showLoadingDialog(context);

    final requiredBoxes = _boxInfos.map((type, quantity) => MapEntry(type.id, quantity));
    final hasRequiredBoxes = await _verifyAvailableBoxCount.invoke(
      user: HelperService.getCurrentUser(context)!,
      requiredBoxes: requiredBoxes,
    );

    if (hasRequiredBoxes) {
      final isSuccess = await _offerFood();
      if (mounted) {
        context.router.replace(ThankYouRoute(
          isSuccess: isSuccess,
          message: context.l10n.foodDonationConfirmation,
        ));
      }
    } else {
      if (mounted) {
        context.router.maybePop();
        UiTemporarySnackBar.showError(context, message: context.l10n.boxCountError);
      }
    }
  }

  void _showCancelConfirmationDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => UiDialog(
        title: context.l10n.cancelOffer,
        content: context.l10n.cancelOfferDialogContent,
        actions: [
          UiTextButton(
            text: context.l10n.continueTheOffer,
            onPressed: () => context.router.maybePop(false),
          ),
          UiPrimaryButton(
            text: context.l10n.confirmCancel,
            onPressed: () => context.router.maybePop(true),
          ),
        ],
      ),
    );

    if (mounted && confirmed == true) {
      context.router.pop();
    }
  }

  void _handleDetailResult({
    FoodInfo? oldFoodInfo,
    OfferFoodDetailResult? result,
  }) {
    // Remove existing food item
    if (oldFoodInfo != null && result is OfferFoodDetailResultRemoveItem) {
      setState(() {
        _foodInfos.remove(oldFoodInfo);
      });

      _showUpdateBoxesDialogIfNeeded(context.l10n.offerFoodOverviewUpdateBoxesRemoveDialogContent);
    }
    // Replace an existing food item with a new one
    else if (oldFoodInfo != null && result is OfferFoodDetailResultSaveItem) {
      setState(() {
        final index = _foodInfos.indexWhere((item) => item.id == result.foodInfo.id);
        _foodInfos[index] = result.foodInfo;
      });

      _showUpdateBoxesDialogIfNeeded(context.l10n.offerFoodOverviewUpdateBoxesEditDialogContent);
    }
    // Add a new food item
    else if (oldFoodInfo == null && result is OfferFoodDetailResultSaveItem) {
      setState(() {
        _foodInfos.add(result.foodInfo);
      });

      _showUpdateBoxesDialogIfNeeded(context.l10n.offerFoodOverviewUpdateBoxesAddDialogContent);
    }
  }

  /// If boxes were already added, we need to show dialog that offers to update boxes.
  void _showUpdateBoxesDialogIfNeeded(String message) {
    if (_boxInfos.isEmpty || _foodInfos.isEmpty) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => UiDialog(
        title: context.l10n.offerFoodOverviewUpdateBoxesDialogTitle,
        content: message,
        actions: [
          UiTextButton(
            text: context.l10n.commonCancel,
            onPressed: () => context.router.maybePop(),
          ),
          UiPrimaryButton(
            text: context.l10n.offerFoodOverviewUpdateBoxesDialogConfirmAction,
            onPressed: () {
              context.router.maybePop();
              _onEditBoxesPressed();
            },
          ),
        ],
      ),
    );
  }
}

/// A section in the offer food overview screen that displays a list of food info items.
class OfferFoodOverviewFoodSection extends StatelessWidget {
  /// Information about the food items being offered.
  final List<FoodInfo> foodInfos;

  /// Callback function to be executed when the "Add" button is pressed.
  final VoidCallback onAddPressed;

  /// Callback function to be executed when a food item's "Edit" button is pressed.
  final Function(FoodInfo) onEditPressed;

  /// Creates an [OfferFoodOverviewFoodSection].
  const OfferFoodOverviewFoodSection({
    super.key,
    required this.foodInfos,
    required this.onAddPressed,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.0,
      children: [
        _buildSectionHeader(context),
        _buildList(context),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return SectionHeader(
      title: context.l10n.offerFoodOverviewSectionFoodInfoTitle,
      action: UiTextButton(
        text: context.l10n.offerFoodOverviewSectionFoodInfoAddAction,
        icon: Icons.add,
        onPressed: onAddPressed,
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Column(
      spacing: 8.0,
      children: foodInfos.map(
        (food) {
          final count = food.numberOfServings ?? food.numberOfPackages ?? 0;
          return UiListTile(
            title: food.dishName.toString(),
            end: Row(
              spacing: 16.0,
              children: [
                Text(
                  context.l10n.commonCountTemplate(count),
                  style: context.textStyles.labelLarge.copyWith(
                    color: context.uiColors.textPrimary,
                  ),
                ),
                UiGradientIcon(
                  spec: UiIconSpec.data(Icons.edit),
                  gradient: context.uiColors.primaryGradient,
                  size: 24,
                ),
              ],
            ),
            onPressed: () => onEditPressed(food),
          );
        },
      ).toList(),
    );
  }
}

/// A section in the offer food overview screen that displays a list of box info items.
class OfferFoodOverviewBoxSection extends StatelessWidget {
  /// Information about the box items being offered.
  final Map<FoodBoxType, int> boxInfos;

  /// Callback function to be executed when the "Edit" button is pressed.
  final VoidCallback onEditPressed;

  /// Whether the "Empty" checkbox is checked.
  final bool isEmptyConfirmed;

  /// Callback function to be executed when the "Empty" checkbox flag is changed.
  final Function(bool) onEmptyConfirmedChanged;

  /// Creates an [OfferFoodOverviewBoxSection].
  const OfferFoodOverviewBoxSection({
    super.key,
    required this.boxInfos,
    required this.onEditPressed,
    required this.isEmptyConfirmed,
    required this.onEmptyConfirmedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context),
        const SizedBox(height: 16),
        if (boxInfos.isEmpty) ...[
          Text(
            context.l10n.offerFoodOverviewSectionBoxInfoDescription,
            style: context.textStyles.bodyMedium,
          ),
          _buildCheckbox(context)
        ] else ...[
          _buildBoxList(context),
        ]
      ],
    );
  }

  Widget _buildCheckbox(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onEmptyConfirmedChanged(!isEmptyConfirmed),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            UiCheckbox(
              isChecked: isEmptyConfirmed,
              onChanged: (value) => onEmptyConfirmedChanged(value),
            ),
            Flexible(
              child: Text(
                context.l10n.offerFoodOverviewSectionBoxInfoEmpty,
                style: context.textStyles.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return SectionHeader(
      title: context.l10n.offerFoodOverviewSectionBoxInfoTitle,
      action: boxInfos.isEmpty
          ? UiTextButton(
              text: context.l10n.offerFoodOverviewSectionBoxInfoAddAction,
              icon: Icons.add,
              onPressed: onEditPressed,
            )
          : UiTextButton(
              text: context.l10n.offerFoodOverviewSectionBoxInfoEditAction,
              icon: Icons.edit,
              onPressed: onEditPressed,
            ),
    );
  }

  Widget _buildBoxList(BuildContext context) {
    return Column(
      spacing: 8.0,
      children: boxInfos.entries.map(
        (entry) {
          return UiListTile(
            title: entry.key.name,
            end: Text(
              context.l10n.commonCountTemplate(entry.value),
              style: context.textStyles.labelLarge,
            ),
          );
        },
      ).toList(),
    );
  }
}
