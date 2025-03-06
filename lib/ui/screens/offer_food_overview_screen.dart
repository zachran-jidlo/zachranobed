import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/utils/iterable_utils.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
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
  final _foodBoxTypes = <FoodBoxType>[];

  final _foodInfos = <FoodInfo>[];
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    try {
      final boxTypes = await _foodBoxRepository.getTypes(includeDisposable: true);
      setState(() {
        _foodBoxTypes.addAll(boxTypes);
        _foodInfos.addAll(widget.initialFoodInfos);
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
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
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_foodInfos.isEmpty)
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
                      _offerFoodListSection(context),
                      ZOButton(
                        text: context.l10n!.offerFoodOverviewAddAction,
                        icon: Icons.add,
                        type: ZOButtonType.textPrimary,
                        minimumSize: ZOButtonSize.medium(
                          fullWidth: useWideButton,
                        ),
                        onPressed: _onAddNewButtonPressed,
                      ),
                      const SizedBox(height: GapSize.xl),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ZOButton(
                          text: context.l10n!.offerFood,
                          icon: Icons.check,
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
                onPressed: _onAddNewButtonPressed,
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
    return _offeredFoodRepository.createOffer(
      delivery: delivery,
      foodInfo: _foodInfos,
    );
  }

  void _onAddNewButtonPressed() async {
    final result = await context.router.push(
      OfferFoodAddNewRoute(
        allFoodInfos: _foodInfos,
      ),
    );
    _handleDetailResult(
      result: result as OfferFoodDetailResult?,
    );
  }

  void _onConfirmationButtonPressed() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    if (await _foodInfos.verifyAvailableBoxCount(context, _foodBoxRepository)) {
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

  /// Builds a section within offer food list.
  Widget _offerFoodListSection(BuildContext context) {
    if (_foodInfos.isEmpty) {
      return const SizedBox();
    }
    return Column(
      children: _foodInfos
          .map(
            (food) => FoodInfoRow(
              foodInfo: food,
              onPressed: () async {
                final result = await context.router.push(
                  OfferFoodEditExistingRoute(
                    foodInfo: food,
                    allFoodInfos: _foodInfos,
                  ),
                );
                _handleDetailResult(
                  oldFoodInfo: food,
                  result: result as OfferFoodDetailResult?,
                );
              },
            ),
          )
          .separated(const SizedBox(height: 8.0))
          .toList(),
    );
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
    }
    // Replace an existing food item with a new one
    else if (oldFoodInfo != null && result is OfferFoodDetailResultSaveItem) {
      setState(() {
        final index = _foodInfos.indexWhere((item) => item.id == result.foodInfo.id);
        _foodInfos[index] = result.foodInfo;
      });
    }
    // Add a new food item
    else if (oldFoodInfo == null && result is OfferFoodDetailResultSaveItem) {
      setState(() {
        _foodInfos.add(result.foodInfo);
      });
    }
  }
}
