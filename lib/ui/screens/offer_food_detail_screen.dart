import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/offeredfood/domain/model/food_info.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/ui/widgets/app_bar.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/dialog.dart';
import 'package:zachranobed/ui/widgets/food_info_fields.dart';
import 'package:zachranobed/ui/widgets/form/form_validation_manager.dart';
import 'package:zachranobed/ui/widgets/screen_scaffold.dart';

/// Represents the initial screen for offering food.
///
/// This screen serves as the starting point for a user to begin the process of adding a new food offer. This screen
/// does not return a result, but instead navigates to the [OfferFoodOverviewScreen] screen.
@RoutePage()
class OfferFoodInitialScreen extends OfferFoodDetailScreen {
  /// Creates a new [OfferFoodDetailScreen].
  const OfferFoodInitialScreen({Key? key})
      : super(
          key: key,
          foodInfo: null,
          returnResult: false,
          screenMode: OfferFoodDetailScreenMode.add,
        );
}

/// Represents the screen for adding new food to the food offer.
///
/// This screen allows the user to fill in the details of a new food info and add it to the food offer. This screen
/// returns a result of type [OfferFoodDetailResultSaveItem] containing the newly added food info.
@RoutePage()
class OfferFoodAddNewScreen extends OfferFoodDetailScreen {
  /// Creates a new [OfferFoodDetailScreen].
  const OfferFoodAddNewScreen({Key? key})
      : super(
          key: key,
          foodInfo: null,
          returnResult: true,
          screenMode: OfferFoodDetailScreenMode.add,
        );
}

@RoutePage()
class OfferFoodEditExistingScreen extends OfferFoodDetailScreen {
  /// Creates a new [OfferFoodDetailScreen] with the given [foodInfo].
  const OfferFoodEditExistingScreen({Key? key, required FoodInfo foodInfo})
      : super(
          key: key,
          foodInfo: foodInfo,
          returnResult: true,
          screenMode: OfferFoodDetailScreenMode.edit,
        );
}

/// Represents the different modes of the [OfferFoodDetailScreen].
///
/// The [add] mode is used when creating a new food info, while the [edit] mode is used when editing an existing food
/// info.
enum OfferFoodDetailScreenMode {
  add,
  edit,
}

/// Sealed class for results of the [OfferFoodDetailScreen].
sealed class OfferFoodDetailResult {}

/// Result indicating that a food info was saved.
///
/// This result contains the [foodInfo] that was saved.
class OfferFoodDetailResultSaveItem extends OfferFoodDetailResult {
  final FoodInfo foodInfo;

  /// Creates a [OfferFoodDetailResultSaveItem] with the given [foodInfo].
  OfferFoodDetailResultSaveItem(this.foodInfo);
}

/// Result indicating that a food info was removed.
class OfferFoodDetailResultRemoveItem extends OfferFoodDetailResult {}

class OfferFoodDetailScreen extends StatefulWidget {
  final FoodInfo? foodInfo;
  final bool returnResult;
  final OfferFoodDetailScreenMode screenMode;

  const OfferFoodDetailScreen({
    super.key,
    required this.foodInfo,
    required this.returnResult,
    required this.screenMode,
  });

  @override
  State<OfferFoodDetailScreen> createState() => _OfferFoodDetailScreenState();
}

class _OfferFoodDetailScreenState extends State<OfferFoodDetailScreen> {
  late FoodInfo _foodInfoPending;

  final _formValidationManager = FormValidationManager();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _foodInfoPending = widget.foodInfo ?? FoodInfo.withUuid();
  }

  @override
  void dispose() {
    _formValidationManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      appBar: ZOAppBar(
        title: _getScreenTitle(),
      ),
      web: (context) => _offerFoodDetailScreenContent(
        actionButtonsAxis: Axis.horizontal,
      ),
      mobile: (context) => _offerFoodDetailScreenContent(
        actionButtonsAxis: Axis.vertical,
      ),
    );
  }

  /// Builds the content of the offer food detail screen.
  ///
  /// The [actionButtonsAxis] parameter determines direction of the action
  /// buttons.
  Widget _offerFoodDetailScreenContent({
    required Axis actionButtonsAxis,
  }) {
    return PopScope(
      canPop: !_foodInfoPending.isSomethingFilled() || widget.foodInfo == _foodInfoPending,
      onPopInvoked: (didPop) {
        if (!didPop) {
          _showCancelConfirmationDialog();
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: WidgetStyle.padding,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                FoodInfoFields(
                  formValidationManager: _formValidationManager,
                  foodInfo: _foodInfoPending,
                  onChanged: (food) {
                    setState(() {
                      _foodInfoPending = food;
                    });
                  },
                ),
                const SizedBox(height: GapSize.m),
                _bottomActionsButtons(actionButtonsAxis: actionButtonsAxis),
                const SizedBox(height: GapSize.l),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getScreenTitle() {
    switch (widget.screenMode) {
      case OfferFoodDetailScreenMode.add:
        return context.l10n!.offerFoodDetailAddScreenTitle;
      case OfferFoodDetailScreenMode.edit:
        return context.l10n!.offerFoodDetailEditScreenTitle;
    }
  }

  Widget _bottomActionsButtons({
    required Axis actionButtonsAxis,
  }) {
    switch (actionButtonsAxis) {
      case Axis.horizontal:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _confirmationButton(
              fullWidth: false,
            ),
            const SizedBox.square(dimension: GapSize.xs),
            _removeButton(
              fullWidth: false,
              large: true,
            ),
          ],
        );
      case Axis.vertical:
        return Column(
          children: [
            _removeButton(
              fullWidth: true,
              large: false,
            ),
            const SizedBox.square(dimension: GapSize.xs),
            _confirmationButton(
              fullWidth: true,
            ),
          ],
        );
    }
  }

  Widget _removeButton({required bool large, required bool fullWidth}) {
    return ZOButton(
      icon: Icons.delete_outlined,
      text: context.l10n!.offerFoodDetailRemoveButton,
      type: ZOButtonType.tertiary,
      minimumSize: large ? ZOButtonSize.large(fullWidth: fullWidth) : ZOButtonSize.medium(fullWidth: fullWidth),
      onPressed: () => _onRemoveFoodPressed(false),
    );
  }

  Widget _confirmationButton({required bool fullWidth}) {
    switch (widget.screenMode) {
      case OfferFoodDetailScreenMode.add:
        return ZOButton(
          text: context.l10n!.offerFoodDetailContinueButton,
          minimumSize: ZOButtonSize.large(fullWidth: fullWidth),
          onPressed: _onConfirmationButtonPressed,
        );
      case OfferFoodDetailScreenMode.edit:
        return ZOButton(
          icon: Icons.check,
          text: context.l10n!.offerFoodDetailSaveButton,
          minimumSize: ZOButtonSize.large(fullWidth: fullWidth),
          onPressed: _onConfirmationButtonPressed,
        );
    }
  }

  void _onConfirmationButtonPressed() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    if (_formKey.currentState!.validate()) {
      if (mounted) {
        // Remove dialog and return result
        context.router.popForced();
        if (widget.returnResult) {
          context.router.popForced(OfferFoodDetailResultSaveItem(_foodInfoPending));
        } else {
          context.router.replace(OfferFoodOverviewRoute(initialFoodInfos: [_foodInfoPending]));
        }
      }
    } else {
      if (mounted) {
        // Remove dialog and scroll to error
        context.router.popForced();
        _formValidationManager.scrollToFirstError();
      }
    }
  }

  void _onRemoveFoodPressed(bool removeConfirmed) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) {
        return ZODialog(
          criticalConfirmStyle: true,
          title: context.l10n!.offerFoodFormRemoveDialogTitle,
          content: context.l10n!.offerFoodFormRemoveDialogContent,
          confirmText: context.l10n!.offerFoodFormRemoveDialogConfirmAction,
          cancelText: context.l10n!.commonCancel,
          onConfirmPressed: () => context.router.maybePop(true),
          onCancelPressed: () => context.router.maybePop(false),
        );
      },
    );

    if (mounted && confirmed) {
      context.router.popForced(OfferFoodDetailResultRemoveItem());
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
        onConfirmPressed: () => Navigator.of(context).maybePop(true),
        onCancelPressed: () => context.router.maybePop(false),
      ),
    );

    if (mounted && confirmed) {
      context.router.popForced();
    }
  }
}
