import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:zachranobed/enums/packaging.dart';
import 'package:zachranobed/models/food_info.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/services/api/offered_food_api_service.dart';
import 'package:zachranobed/services/helper_service.dart';
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
  Future<Response>? _futureResponse;

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
        foodInfo.name.isNotEmpty == true ||
        foodInfo.allergens != null ||
        foodInfo.numberOfServings != null);
  }

  Future<bool> _showConfirmationDialog() async {
    if (_somethingIsFilled()) {
      return (await showDialog(
            context: context,
            builder: (context) => ZODialog(
              title: ZOStrings.endOffer,
              content: ZOStrings.cancelOfferDialogContent,
              confirmText: ZOStrings.cancelTheOffer,
              cancelText: ZOStrings.continueTheOffer,
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
                const Row(
                  children: <Widget>[
                    Text(
                      ZOStrings.offerLeftoverFood,
                      style: TextStyle(fontSize: FontSize.l),
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
                        text: ZOStrings.addAnotherFood,
                        icon: MaterialSymbols.add,
                        isSecondary: true,
                        height: 40.0,
                        onPressed: () {
                          setState(() => _foodSections.add(FoodInfo()));
                        },
                      ),
                      const SizedBox(height: GapSize.xl),
                      const Row(
                        children: [
                          Text(
                            ZOStrings.summaryInfo,
                            style: TextStyle(fontSize: FontSize.m),
                          ),
                        ],
                      ),
                      _buildGap(),
                      ZODropdown(
                        hintText: ZOStrings.packaging,
                        items: Packaging.values
                            .map((e) => e.packagingName)
                            .toList(),
                        onValidation: (val) => val == null
                            ? ZOStrings.requiredDropdownError
                            : null,
                        onChanged: (value) => _selectedPackaging = value,
                      ),
                      _buildGap(),
                      ZODateTimePicker(
                        label: ZOStrings.consumeBy,
                        icon: MaterialSymbols.calendar_today,
                        controller: _consumeByController,
                        onValidation: (val) =>
                            val!.isEmpty ? ZOStrings.requiredFieldError : null,
                      ),
                      const SizedBox(height: GapSize.xl),
                      ZOButton(
                        text: ZOStrings.offerFood,
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
                        clickableText: ZOStrings.manualName,
                        prefixText: ZOStrings.consent,
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

  Future<Response> _offerFood() {
    var response = null;
    for (var foodInfo in _foodSections) {
      response = OfferedFoodApiService().createOffer(
          const Uuid().v4(),
          DateTime.now(),
          FoodInfo(
            name: foodInfo.name,
            allergens: foodInfo.allergens,
            numberOfServings: foodInfo.numberOfServings,
          ),
          _selectedPackaging,
          DateFormat('dd.MM.y HH:mm').parse(_consumeByController.text),
          HelperService.getCurrentUser(context)!.internalId);
    }
    return response;
  }
}
