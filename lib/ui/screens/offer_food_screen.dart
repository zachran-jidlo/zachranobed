import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/common/helper_service.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_type.dart';
import 'package:zachranobed/features/foodboxes/domain/repository/food_box_repository.dart';
import 'package:zachranobed/features/offeredfood/domain/model/food_info.dart';
import 'package:zachranobed/features/offeredfood/domain/repository/offered_food_repository.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
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
  final _offeredFoodRepository = GetIt.I<OfferedFoodRepository>();
  final _foodBoxRepository = GetIt.I<FoodBoxRepository>();

  final _formKey = GlobalKey<FormState>();

  final List<FoodInfo> _foodSections = [const FoodInfo()];
  final List<TextEditingController> _consumeByControllers = [
    TextEditingController()
  ];
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
    for (var controller in _consumeByControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  bool _somethingIsFilled() {
    return _foodSections.any((foodInfo) =>
        foodInfo.dishName != null ||
        foodInfo.allergens != null ||
        foodInfo.foodCategory != null ||
        foodInfo.numberOfServings != null ||
        foodInfo.numberOfBoxes != null ||
        foodInfo.foodBoxId != null ||
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
                        boxTypes: _foodBoxTypes,
                      ),
                      ZOButton(
                        text: context.l10n!.addAnotherFood,
                        icon: MaterialSymbols.add,
                        type: ZOButtonType.secondary,
                        height: 40.0,
                        onPressed: () {
                          setState(() {
                            _foodSections.add(const FoodInfo());
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
                              final isSuccess = await _offerFood();
                              if (mounted) {
                                context.router.replace(ThankYouRoute(
                                  isSuccess: isSuccess,
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

    final user = HelperService.getCurrentUser(context);
    if (user == null) {
      return false;
    }

    final requiredBoxes = <String, int>{};
    for (final foodInfo in _foodSections) {
      final foodBoxId = foodInfo.foodBoxId;
      if (foodBoxId == null) {
        continue;
      }
      final required = foodInfo.numberOfBoxes ?? foodInfo.numberOfServings ?? 0;
      requiredBoxes[foodBoxId] = (requiredBoxes[foodBoxId] ?? 0) + required;
    }

    final available = await _foodBoxRepository.verifyAvailableBoxCount(
      entityId: user.entityId,
      requiredBoxes: requiredBoxes,
      getQuantity: (e) => e.quantityAtCanteen,
    );

    if (!available) {
      if (mounted) {
        context.router.pop();
      }
    }

    return available;
  }

  Future<bool> _offerFood() async {
    final delivery = context.read<DeliveryNotifier>().delivery;
    if (delivery == null) {
      return false;
    }
    return _offeredFoodRepository.createOffer(
      delivery: delivery,
      foodInfo: _foodSections,
    );
  }
}
