import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/enums/box_type.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/models/canteen.dart';
import 'package:zachranobed/models/offered_food.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/services/box_service.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/services/offered_food_service.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/clickable_text.dart';
import 'package:zachranobed/ui/widgets/dialog.dart';
import 'package:zachranobed/ui/widgets/food_section_fields.dart';
import 'package:zachranobed/ui/widgets/snackbar/temporary_snackbar.dart';

@RoutePage()
class OfferFoodScreen extends StatefulWidget {
  const OfferFoodScreen({super.key});

  @override
  State<OfferFoodScreen> createState() => _OfferFoodScreenState();
}

class _OfferFoodScreenState extends State<OfferFoodScreen> {
  final _offeredFoodService = GetIt.I<OfferedFoodService>();
  final _boxService = GetIt.I<BoxService>();

  DocumentReference<OfferedFood>? _futureResponse;

  final _formKey = GlobalKey<FormState>();

  final List<OfferedFood> _foodSections = [const OfferedFood()];
  final List<TextEditingController> _consumeByControllers = [
    TextEditingController()
  ];
  final List<bool> _checkboxValues = [true];

  @override
  void dispose() {
    for (var controller in _consumeByControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  bool _somethingIsFilled() {
    return _foodSections.any((foodInfo) =>
        foodInfo.dishName != null ||
        foodInfo.allergens != null ||
        foodInfo.numberOfServings != null ||
        foodInfo.numberOfBoxes != null ||
        foodInfo.boxType != null ||
        foodInfo.foodCategory != null ||
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
              icon: Icons.delete_outline,
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
                        foodSections: _foodSections,
                        controllers: _consumeByControllers,
                        checkboxValues: _checkboxValues,
                      ),
                      ZOButton(
                        text: context.l10n!.addAnotherFood,
                        icon: MaterialSymbols.add,
                        isSecondary: true,
                        height: 40.0,
                        onPressed: () {
                          setState(() {
                            _foodSections.add(const OfferedFood());
                            _consumeByControllers.add(TextEditingController());
                            _checkboxValues.add(true);
                          });
                        },
                      ),
                      const SizedBox(height: GapSize.xxl),
                      ZOButton(
                        text: context.l10n!.offerFood,
                        icon: MaterialSymbols.check,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (await _verifyAvailableBoxCount()) {
                              _futureResponse = await _offerFood();
                              if (mounted) {
                                context.router.replace(ThankYouRoute(
                                  response: _futureResponse,
                                  message:
                                      context.l10n!.foodDonationConfirmation,
                                ));
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
                          }
                        },
                      ),
                      const SizedBox(height: GapSize.m),
                      ZOClickableText(
                        clickableText: context.l10n!.manualName,
                        prefixText: context.l10n!.consent,
                        underline: true,
                        onTap: () => print('Kliknuto na příručku'),
                      ),
                      const SizedBox(height: 50),
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

  Future<bool> _verifyAvailableBoxCount() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final canteen = HelperService.getCurrentUser(context) as Canteen;
    for (var foodInfo in _foodSections) {
      final isAvailable = await _boxService.verifyAvailableBoxCount(
        numberOfBoxes: foodInfo.numberOfBoxes ?? foodInfo.numberOfServings!,
        boxType: foodInfo.boxType!,
        establishmentId: canteen.establishmentId,
        isCanteen: true,
      );
      if (mounted) {
        if (!isAvailable &&
            foodInfo.boxType !=
                BoxTypeHelper.toValue(BoxType.disposablePackaging, context)) {
          context.router.pop();
          return false;
        }
      }
    }
    return true;
  }

  Future<DocumentReference<OfferedFood>> _offerFood() async {
    var response = null;
    final canteen = HelperService.getCurrentUser(context) as Canteen;
    final now = DateTime.now();
    for (var foodInfo in _foodSections) {
      response = await _offeredFoodService.createOffer(
        OfferedFood(
          date: now,
          dateTimestamp: now.millisecondsSinceEpoch ~/ 1000,
          dishName: foodInfo.dishName,
          allergens: foodInfo.allergens,
          foodCategory: foodInfo.foodCategory,
          numberOfServings: foodInfo.numberOfServings,
          numberOfBoxes: foodInfo.numberOfBoxes ?? foodInfo.numberOfServings,
          boxType: foodInfo.boxType,
          consumeBy: foodInfo.consumeBy,
          consumeByTimestamp:
              foodInfo.consumeBy!.millisecondsSinceEpoch ~/ 1000,
          weekNumber: '${now.year}-${HelperService.getCurrentWeekNumber}',
          donorId: canteen.establishmentId,
          recipientId: canteen.recipientId,
        ),
      );
    }
    return response;
  }
}
