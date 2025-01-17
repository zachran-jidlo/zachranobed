import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_type.dart';
import 'package:zachranobed/features/foodboxes/domain/repository/food_box_repository.dart';
import 'package:zachranobed/features/offeredfood/domain/model/food_info.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/dialog.dart';
import 'package:zachranobed/ui/widgets/food_info_expandable.dart';
import 'package:zachranobed/ui/widgets/food_info_fields.dart';
import 'package:zachranobed/ui/widgets/form/form_validation_manager.dart';
import 'package:zachranobed/ui/widgets/screen_scaffold.dart';
import 'package:zachranobed/ui/widgets/snackbar/temporary_snackbar.dart';

@RoutePage()
class OfferFoodScreen extends StatefulWidget {
  const OfferFoodScreen({super.key});

  @override
  State<OfferFoodScreen> createState() => _OfferFoodScreenState();
}

class _OfferFoodScreenState extends State<OfferFoodScreen> {
  final _foodBoxRepository = GetIt.I<FoodBoxRepository>();

  final _formKey = GlobalKey<FormState>();
  final _formValidationManager = FormValidationManager();

  final List<FoodBoxType> _foodBoxTypes = [];

  final List<FoodInfo> _foodInfoEntered = [];

  late ScrollController _scrollController;

  var _foodInfoEnteredExpanded = false;
  var _foodInfoPending = FoodInfo.withUuid();

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    _foodBoxRepository.getTypes(includeDisposable: true).then((value) {
      setState(() {
        _foodBoxTypes.clear();
        _foodBoxTypes.addAll(value);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _formValidationManager.dispose();
    super.dispose();
  }

  bool _somethingIsFilled() {
    return _foodInfoPending.dishName != null ||
        _foodInfoPending.allergens != null ||
        _foodInfoPending.foodCategory != null ||
        _foodInfoPending.foodTemperature != null ||
        _foodInfoPending.numberOfPackages != null ||
        _foodInfoPending.numberOfServings != null ||
        _foodInfoPending.numberOfBoxes != null ||
        _foodInfoPending.foodBoxType != null ||
        _foodInfoPending.preparedAt != null ||
        _foodInfoPending.consumeBy != null;
  }

  Future<bool> _showConfirmationDialog() async {
    if (_foodInfoEntered.isNotEmpty || _somethingIsFilled()) {
      return (await showDialog(
            context: context,
            builder: (context) => ZODialog(
              title: context.l10n!.cancelOffer,
              content: context.l10n!.cancelOfferDialogContent,
              confirmText: context.l10n!.confirmCancel,
              cancelText: context.l10n!.continueTheOffer,
              onConfirmPressed: () => Navigator.of(context).pop(true),
              onCancelPressed: () => Navigator.of(context).pop(false),
            ),
          )) ??
          false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      web: (context) => _offerFoodScreenContent(useWideButton: false),
      mobile: (context) => _offerFoodScreenContent(useWideButton: true),
    );
  }

  /// Builds the content of the offer food screen.
  ///
  /// The [useWideButton] parameter determines whether to stretch confirmation
  /// button to screen width.
  Widget _offerFoodScreenContent({
    required bool useWideButton,
  }) {
    return WillPopScope(
      onWillPop: _showConfirmationDialog,
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: WidgetStyle.padding,
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      context.l10n!.offerLeftoverFood,
                      style: const TextStyle(fontSize: FontSize.l),
                    ),
                  ],
                ),
                const SizedBox(height: GapSize.s),
                FoodInfoExpandable(
                  isExpanded: _foodInfoEnteredExpanded,
                  onExpandedChanged: (expanded) {
                    setState(() {
                      _foodInfoEnteredExpanded = expanded;
                    });
                  },
                  foodInfos: _foodInfoEntered,
                  onFoodInfoPressed: (info) => _onEditFoodPressed(info, false),
                ),
                const SizedBox(height: GapSize.xl),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      FoodInfoFields(
                        foodInfo: _foodInfoPending,
                        formValidationManager: _formValidationManager,
                        boxTypes: _foodBoxTypes,
                        onChanged: (foodInfo) {
                          setState(() {
                            _foodInfoPending = foodInfo;
                          });
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ZOButton(
                              text: context.l10n!.offerFoodFormRemoveAction,
                              icon: Icons.delete_outlined,
                              type: ZOButtonType.tertiary,
                              minimumSize: ZOButtonSize.medium(),
                              onPressed: () => _onRemoveFoodPressed(false),
                            ),
                          ),
                          const SizedBox(width: GapSize.xs),
                          Expanded(
                            child: ZOButton(
                              text: context.l10n!.addAnotherFood,
                              icon: MaterialSymbols.add,
                              type: ZOButtonType.secondary,
                              minimumSize: ZOButtonSize.medium(),
                              onPressed: _onAddAnotherPressed,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: GapSize.xl),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ZOButton(
                          text: context.l10n!.continueTheOffer,
                          minimumSize: ZOButtonSize.large(
                            fullWidth: useWideButton,
                          ),
                          onPressed: _onConfirmationButtonPressed,
                        ),
                      ),
                      const SizedBox(height: GapSize.l),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onAddAnotherPressed() {
    if (_formKey.currentState!.validate()) {
      _scrollToTop();
      setState(() {
        _foodInfoEnteredExpanded = false;
        _foodInfoEntered.add(_foodInfoPending);
        _foodInfoPending = FoodInfo.withUuid();
      });
    } else {
      _formValidationManager.scrollToFirstError();
    }
  }

  void _onEditFoodPressed(FoodInfo info, bool replaceConfirmed) {
    if (_somethingIsFilled() && !replaceConfirmed) {
      showDialog(
        context: context,
        builder: (context) {
          return ZODialog(
            criticalConfirmStyle: true,
            title: context.l10n!.offerFoodFormEditDialogTitle,
            content: context.l10n!.offerFoodFormEditDialogContent,
            confirmText: context.l10n!.offerFoodFormEditDialogConfirmAction,
            cancelText: context.l10n!.commonBack,
            onConfirmPressed: () {
              Navigator.of(context).pop(false);
              _onEditFoodPressed(info, true);
            },
            onCancelPressed: () => Navigator.of(context).pop(false),
          );
        },
      );
      return;
    }

    _scrollToTop();
    setState(() {
      _foodInfoEnteredExpanded = false;
      _foodInfoEntered.removeWhere((it) => it.id == info.id);
      _foodInfoPending = info;
    });
  }

  void _onRemoveFoodPressed(bool removeConfirmed) {
    if (!removeConfirmed) {
      showDialog(
        context: context,
        builder: (context) {
          return ZODialog(
            criticalConfirmStyle: true,
            title: context.l10n!.offerFoodFormRemoveDialogTitle,
            content: context.l10n!.offerFoodFormRemoveDialogContent,
            confirmText: context.l10n!.offerFoodFormRemoveDialogConfirmAction,
            cancelText: context.l10n!.commonCancel,
            onConfirmPressed: () {
              Navigator.of(context).pop(false);
              _onRemoveFoodPressed(true);
            },
            onCancelPressed: () => Navigator.of(context).pop(false),
          );
        },
      );
      return;
    }

    _scrollToTop();
    setState(() {
      _foodInfoEnteredExpanded = false;
      _foodInfoEntered.removeWhere((it) => it.id == _foodInfoPending.id);
      _foodInfoPending = FoodInfo.withUuid();
    });
  }

  void _onConfirmationButtonPressed() async {
    if (_formKey.currentState!.validate()) {
      final foodInfos = [..._foodInfoEntered, _foodInfoPending];
      if (await foodInfos.verifyAvailableBoxCount(
          context, _foodBoxRepository)) {
        if (mounted) {
          context.router.navigate(
            OfferFoodOverviewRoute(foodInfos: foodInfos),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            ZOTemporarySnackBar(
              backgroundColor: Colors.red,
              message: context.l10n!.boxCountError,
            ),
          );
        }
      }
    } else {
      _formValidationManager.scrollToFirstError();
    }
  }

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }
}
