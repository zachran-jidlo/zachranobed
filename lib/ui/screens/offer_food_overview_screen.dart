import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/common/utils/iterable_utils.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/foodboxes/domain/model/box_info.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_type.dart';
import 'package:zachranobed/features/foodboxes/domain/repository/food_box_repository.dart';
import 'package:zachranobed/features/offeredfood/domain/model/food_info.dart';
import 'package:zachranobed/features/offeredfood/domain/repository/offered_food_repository.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/ui/screens/offer_food_detail_screen.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/dialog.dart';
import 'package:zachranobed/ui/widgets/empty_page.dart';
import 'package:zachranobed/ui/widgets/food_info_row.dart';
import 'package:zachranobed/ui/widgets/info_banner.dart';
import 'package:zachranobed/ui/widgets/screen_scaffold.dart';
import 'package:zachranobed/ui/widgets/section_header.dart';
import 'package:zachranobed/ui/widgets/snackbar/temporary_snackbar.dart';

@RoutePage()
class OfferFoodOverviewScreen extends StatefulWidget {
  final List<FoodInfo> initialFoodInfos;

  const OfferFoodOverviewScreen({
    super.key,
    required this.initialFoodInfos,
  });

  @override
  State<OfferFoodOverviewScreen> createState() => _OfferFoodOverviewScreenState();
}

class _OfferFoodOverviewScreenState extends State<OfferFoodOverviewScreen> {
  final _offeredFoodRepository = GetIt.I<OfferedFoodRepository>();
  final _foodBoxRepository = GetIt.I<FoodBoxRepository>();

  final _foodInfos = <FoodInfo>[];
  final _boxInfos = <FoodBoxType, int>{};

  var _isEmptyConfirmed = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      _foodInfos.addAll(widget.initialFoodInfos);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      web: (context) => _offerFoodOverviewScreenContent(useWideButton: false),
      mobile: (context) => _offerFoodOverviewScreenContent(useWideButton: true),
    );
  }

  /// Builds the content of the offer food overview screen.
  ///
  /// The [useWideButton] parameter determines whether to stretch confirmation
  /// button to screen width.
  Widget _offerFoodOverviewScreenContent({
    required bool useWideButton,
  }) {
    return PopScope(
      canPop: _foodInfos.isEmpty,
      onPopInvoked: (didPop) {
        if (!didPop) {
          _showCancelConfirmationDialog();
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(WidgetStyle.padding),
                alignment: Alignment.centerLeft,
                child: Text(
                  context.l10n!.offerFoodOverviewScreenTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.clip,
                ),
              ),
              if (_foodInfos.isEmpty)
                _emptyScreenContent(useWideButton)
              else ...[
                InfoBanner.text(
                  backgroundColor: ZOColors.amberTransparent,
                  message: context.l10n!.offerFoodOverviewBanner,
                ),
                const SizedBox(height: GapSize.m),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: WidgetStyle.padding,
                  ),
                  child: Column(
                    children: [
                      OfferFoodOverviewFoodSection(
                        foodInfos: _foodInfos,
                        onAddPressed: _onAddNewFoodPressed,
                        onEditPressed: _onEditFoodPressed,
                      ),
                      const SizedBox(height: GapSize.xl),
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
                      const SizedBox(height: GapSize.xxl),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ZOButton(
                          text: context.l10n!.offerFood,
                          icon: Icons.check,
                          enabled: _isEmptyConfirmed || _boxInfos.isNotEmpty,
                          minimumSize: ZOButtonSize.large(
                            fullWidth: useWideButton,
                          ),
                          onPressed: _onConfirmationButtonPressed,
                        ),
                      ),
                      const SizedBox(height: GapSize.xs),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyScreenContent(bool useWideButton) {
    return Column(
      children: [
        EmptyPage(
          vectorImagePath: ZOStrings.overviewPath,
          title: context.l10n!.offerFoodOverviewEmptyTitle,
          description: context.l10n!.offerFoodOverviewEmptyDescription,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: GapSize.xl),
          child: Column(
            children: [
              ZOButton(
                text: context.l10n!.offerFoodOverviewEmptyAction,
                icon: Icons.add,
                minimumSize: ZOButtonSize.medium(fullWidth: useWideButton),
                onPressed: _onAddNewFoodPressed,
              ),
              const SizedBox(height: GapSize.xs),
              ZOButton(
                text: context.l10n!.commonClose,
                type: ZOButtonType.textPrimary,
                minimumSize: ZOButtonSize.medium(fullWidth: useWideButton),
                onPressed: () => context.router.maybePop(),
              ),
            ],
          ),
        ),
        const SizedBox(height: GapSize.xl),
      ],
    );
  }

  Future<bool> _offerFood() async {
    final delivery = context.read<DeliveryNotifier>().delivery;
    if (delivery == null) {
      return false;
    }

    final boxInfo = _boxInfos.entries.map((entry) {
      return BoxInfo(
        foodBoxId: entry.key.id,
        numberOfBoxes: entry.value,
      );
    }).toList();
    return _offeredFoodRepository.createOffer(
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final requiredBoxes = _boxInfos.map((type, quantity) => MapEntry(type.id, quantity));
    final hasRequiredBoxes = await _foodBoxRepository.verifyAvailableBoxCount(
      user: HelperService.getCurrentUser(context)!,
      requiredBoxes: requiredBoxes,
      getQuantity: (e) => e.quantityAtCanteen,
    );

    if (hasRequiredBoxes) {
      final isSuccess = await _offerFood();
      if (mounted) {
        context.router.replace(ThankYouRoute(
          isSuccess: isSuccess,
          message: context.l10n!.foodDonationConfirmation,
        ));
      }
    } else {
      if (mounted) {
        context.router.maybePop();
        ScaffoldMessenger.of(context).showSnackBar(
          ZOTemporarySnackBar(
            backgroundColor: Colors.red,
            message: context.l10n!.boxCountError,
          ),
        );
      }
    }
  }

  void _showCancelConfirmationDialog() async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => ZODialog(
        criticalConfirmStyle: true,
        title: context.l10n!.cancelOffer,
        content: context.l10n!.cancelOfferDialogContent,
        confirmText: context.l10n!.confirmCancel,
        cancelText: context.l10n!.continueTheOffer,
        onConfirmPressed: () => context.router.maybePop(true),
        onCancelPressed: () => context.router.maybePop(false),
      ),
    );

    if (mounted && confirmed == true) {
      context.router.popForced();
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

      _showUpdateBoxesDialogIfNeeded(context.l10n!.offerFoodOverviewUpdateBoxesRemoveDialogContent);
    }
    // Replace an existing food item with a new one
    else if (oldFoodInfo != null && result is OfferFoodDetailResultSaveItem) {
      setState(() {
        final index = _foodInfos.indexWhere((item) => item.id == result.foodInfo.id);
        _foodInfos[index] = result.foodInfo;
      });

      _showUpdateBoxesDialogIfNeeded(context.l10n!.offerFoodOverviewUpdateBoxesEditDialogContent);
    }
    // Add a new food item
    else if (oldFoodInfo == null && result is OfferFoodDetailResultSaveItem) {
      setState(() {
        _foodInfos.add(result.foodInfo);
      });

      _showUpdateBoxesDialogIfNeeded(context.l10n!.offerFoodOverviewUpdateBoxesAddDialogContent);
    }
  }

  /// If boxes were already added, we need to show dialog that offers to update boxes.
  void _showUpdateBoxesDialogIfNeeded(String message) {
    if (_boxInfos.isEmpty) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => ZODialog(
        criticalConfirmStyle: true,
        title: context.l10n!.offerFoodOverviewUpdateBoxesDialogTitle,
        content: message,
        confirmText: context.l10n!.offerFoodOverviewUpdateBoxesDialogConfirmAction,
        cancelText: context.l10n!.commonCancel,
        onConfirmPressed: () {
          context.router.maybePop();
          _onEditBoxesPressed();
        },
        onCancelPressed: () => context.router.maybePop(),
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
      children: [
        _buildSectionHeader(context),
        _buildList(context),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return SectionHeader(
      useBottomPadding: false,
      title: Text(
        context.l10n!.offerFoodOverviewSectionFoodInfoTitle,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      action: ZOButton(
        text: context.l10n!.offerFoodOverviewSectionFoodInfoAddAction,
        icon: Icons.add,
        type: ZOButtonType.textPrimary,
        minimumSize: ZOButtonSize.medium(fullWidth: false),
        onPressed: onAddPressed,
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    if (foodInfos.isEmpty) {
      return const SizedBox();
    }
    return Column(
      children: foodInfos
          .map(
            (food) => FoodInfoRow(
              foodInfo: food,
              onPressed: () {
                onEditPressed(food);
              },
            ),
          )
          .separated(
            const SizedBox(height: 8.0),
            leading: true,
          )
          .toList(),
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
        const SizedBox(height: GapSize.xs),
        Text(context.l10n!.offerFoodOverviewSectionBoxInfoDescription),
        const SizedBox(height: GapSize.xs),
        if (boxInfos.isEmpty) ...[
          _buildCheckbox(context)
        ] else ...[
          _buildCard(context),
        ]
      ],
    );
  }

  Widget _buildCheckbox(BuildContext context) {
    return InkWell(
        onTap: () {
          onEmptyConfirmedChanged(!isEmptyConfirmed);
        },
        child: Container(
          decoration: BoxDecoration(
            color: ZOColors.cardBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Checkbox(
                  value: isEmptyConfirmed,
                  onChanged: (value) {
                    onEmptyConfirmedChanged(value ?? isEmptyConfirmed);
                  }),
              Text(context.l10n!.offerFoodOverviewSectionBoxInfoEmpty)
            ],
          ),
        ));
  }

  Widget _buildSectionHeader(BuildContext context) {
    return SectionHeader(
      useBottomPadding: false,
      title: Text(
        context.l10n!.offerFoodOverviewSectionBoxInfoTitle,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      action: boxInfos.isEmpty
          ? ZOButton(
              text: context.l10n!.offerFoodOverviewSectionBoxInfoAddAction,
              icon: Icons.add,
              type: ZOButtonType.textPrimary,
              minimumSize: ZOButtonSize.medium(fullWidth: false),
              onPressed: onEditPressed,
            )
          : ZOButton(
              text: context.l10n!.offerFoodOverviewSectionBoxInfoEditAction,
              icon: Icons.edit,
              type: ZOButtonType.textPrimary,
              minimumSize: ZOButtonSize.medium(fullWidth: false),
              onPressed: onEditPressed,
            ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: ZOColors.borderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: boxInfos.entries
            .map((e) {
              return ListTile(
                title: Text(
                  e.key.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  context.l10n!.foodInfoCountTemplate(e.value),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ZOColors.onPrimaryLight),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            })
            .separated(const Divider(height: 1, color: ZOColors.secondary))
            .toList(),
      ),
    );
  }
}
