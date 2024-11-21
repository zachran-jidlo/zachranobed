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
import 'package:zachranobed/ui/widgets/food_section_fields.dart';
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

  final List<FoodInfo> _foodSections = [FoodInfo.withUuid()];
  final List<bool> _checkboxValues = [true];
  final List<FoodBoxType> _foodBoxTypes = [];

  @override
  void initState() {
    super.initState();

    _foodBoxRepository.getTypes(includeDisposable: true).then((value) {
      setState(() {
        _foodBoxTypes.clear();
        _foodBoxTypes.addAll(value);
      });
    });
  }

  @override
  void dispose() {
    _formValidationManager.dispose();
    super.dispose();
  }

  bool _somethingIsFilled() {
    return _foodSections.any((foodInfo) =>
        foodInfo.dishName != null ||
        foodInfo.allergens != null ||
        foodInfo.foodCategory != null ||
        foodInfo.numberOfServings != null ||
        foodInfo.numberOfBoxes != null ||
        foodInfo.foodBoxType != null ||
        foodInfo.consumeBy != null);
  }

  Future<bool> _showConfirmationDialog() async {
    if (_somethingIsFilled()) {
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
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: WidgetStyle.padding,
          ),
          child: SingleChildScrollView(
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
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      FoodSectionFields(
                        formValidationManager: _formValidationManager,
                        foodSections: _foodSections,
                        checkboxValues: _checkboxValues,
                        boxTypes: _foodBoxTypes,
                      ),
                      _addAnotherFoodButton(),
                      const SizedBox(height: GapSize.xxl),
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

  Widget _addAnotherFoodButton() {
    return ZOButton(
      text: context.l10n!.addAnotherFood,
      icon: MaterialSymbols.add,
      type: ZOButtonType.secondary,
      minimumSize: ZOButtonSize.medium(),
      onPressed: () {
        setState(() {
          _foodSections.add(FoodInfo.withUuid());
          _checkboxValues.add(true);
        });
      },
    );
  }

  void _onConfirmationButtonPressed() async {
    if (_formKey.currentState!.validate()) {
      if (await _foodSections.verifyAvailableBoxCount(
          context, _foodBoxRepository)) {
        if (mounted) {
          context.router.navigate(
            OfferFoodOverviewRoute(foodInfos: _foodSections),
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
}
