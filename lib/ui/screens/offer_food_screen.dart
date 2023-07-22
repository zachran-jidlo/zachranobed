import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:zachranobed/enums/packaging.dart';
import 'package:zachranobed/models/food_info.dart';
import 'package:zachranobed/models/offered_food.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/services/offered_food_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/clickable_text.dart';
import 'package:zachranobed/ui/widgets/date_time_picker.dart';
import 'package:zachranobed/ui/widgets/dialog.dart';
import 'package:zachranobed/ui/widgets/dropdown.dart';
import 'package:zachranobed/ui/widgets/food_section_text_fields.dart';

class OfferFoodScreen extends StatefulWidget {
  const OfferFoodScreen({super.key});

  @override
  State<OfferFoodScreen> createState() => _OfferFoodScreenState();
}

class _OfferFoodScreenState extends State<OfferFoodScreen> {
  final _offeredFoodService = GetIt.I<OfferedFoodService>();

  Future<DocumentReference<OfferedFood>>? _futureResponse;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _consumeByController = TextEditingController();
  String _selectedPackaging = '';

  final List<FoodInfo> _foodSections = [FoodInfo()];

  @override
  void dispose() {
    _consumeByController.dispose();
    super.dispose();
  }

  bool _somethingIsFilled() {
    if (_consumeByController.text.isNotEmpty || _selectedPackaging != '') {
      return true;
    }
    return _foodSections.any((foodInfo) =>
        foodInfo.dishName.isNotEmpty == true ||
        foodInfo.allergens != null ||
        foodInfo.numberOfServings != null);
  }

  Future<bool> _showConfirmationDialog() async {
    if (_somethingIsFilled()) {
      return (await showDialog(
            context: context,
            builder: (context) => ZODialog(
              title: AppLocalizations.of(context)!.cancelOffer,
              content: AppLocalizations.of(context)!.cancelOfferDialogContent,
              confirmText: AppLocalizations.of(context)!.confirmCancel,
              cancelText: AppLocalizations.of(context)!.continueTheOffer,
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
                      AppLocalizations.of(context)!.offerLeftoverFood,
                      style: const TextStyle(fontSize: FontSize.l),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      FoodSectionTextFields(
                        foodSections: _foodSections,
                      ),
                      ZOButton(
                        text: AppLocalizations.of(context)!.addAnotherFood,
                        icon: MaterialSymbols.add,
                        isSecondary: true,
                        height: 40.0,
                        onPressed: () {
                          setState(() => _foodSections.add(FoodInfo()));
                        },
                      ),
                      const SizedBox(height: GapSize.xl),
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.summaryInfo,
                            style: const TextStyle(fontSize: FontSize.m),
                          ),
                        ],
                      ),
                      _buildGap(),
                      ZODropdown(
                        hintText: AppLocalizations.of(context)!.packaging,
                        items: Packaging.values
                            .map((e) => PackagingHelper.toValue(e, context))
                            .toList(),
                        onValidation: (val) => val == null
                            ? AppLocalizations.of(context)!
                                .requiredDropdownError
                            : null,
                        onChanged: (value) => _selectedPackaging = value,
                      ),
                      _buildGap(),
                      ZODateTimePicker(
                        label: AppLocalizations.of(context)!.consumeBy,
                        icon: MaterialSymbols.calendar_today,
                        controller: _consumeByController,
                        onValidation: (val) => val!.isEmpty
                            ? AppLocalizations.of(context)!.requiredFieldError
                            : null,
                      ),
                      const SizedBox(height: GapSize.xl),
                      ZOButton(
                        text: AppLocalizations.of(context)!.offerFood,
                        icon: MaterialSymbols.check,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _futureResponse = _offerFood();
                            Navigator.of(context).pushReplacementNamed(
                                RouteManager.thankYou,
                                arguments: _futureResponse);
                          }
                        },
                      ),
                      const SizedBox(height: GapSize.s),
                      ZOClickableText(
                        clickableText: AppLocalizations.of(context)!.manualName,
                        prefixText: AppLocalizations.of(context)!.consent,
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

  Widget _buildGap() {
    return const SizedBox(height: GapSize.l);
  }

  Future<DocumentReference<OfferedFood>> _offerFood() async {
    var response = null;
    for (var foodInfo in _foodSections) {
      response = await _offeredFoodService.createOffer(
        OfferedFood(
          id: "",
          date: DateTime.now(),
          foodInfo: FoodInfo(
            dishName: foodInfo.dishName,
            allergens: foodInfo.allergens,
            numberOfServings: foodInfo.numberOfServings,
          ),
          packaging: _selectedPackaging,
          consumeBy:
              DateFormat('dd.MM.y HH:mm').parse(_consumeByController.text),
          weekNumber:
              '${DateTime.now().year}-${HelperService.getCurrentWeekNumber}',
          donor: HelperService.getCurrentUser(context)!.establishmentName,
        ),
      );
    }
    return response;
  }
}
