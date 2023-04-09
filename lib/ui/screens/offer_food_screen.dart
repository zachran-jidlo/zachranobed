import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:zachranobed/models/food_info.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/services/api/offered_food_api_service.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/date_time_picker.dart';
import 'package:zachranobed/ui/widgets/dialog.dart';
import 'package:zachranobed/ui/widgets/dropdown.dart';
import 'package:zachranobed/ui/widgets/food_section_text_fields.dart';

class OfferFoodScreen extends StatefulWidget {
  const OfferFoodScreen({Key? key}) : super(key: key);

  @override
  State<OfferFoodScreen> createState() => _OfferFoodScreenState();
}

class _OfferFoodScreenState extends State<OfferFoodScreen> {
  Future<Response>? _futureResponse;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _consumeByController = TextEditingController();
  String _selectedPackaging = '';

  final List<String> _packagingOptions = <String>[
    'REkrabička',
    'Jednorázový obal'
  ];

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
        foodInfo.allergens.isNotEmpty == true ||
        foodInfo.numberOfServings != null);
  }

  Future<bool> _showConfirmationDialog() async {
    if (_somethingIsFilled()) {
      return (await showDialog(
            context: context,
            builder: (context) => ZachranObedDialog(
              title: ZachranObedStrings.endOffer,
              confirmText: ZachranObedStrings.cancelTheOffer,
              cancelText: ZachranObedStrings.continueTheOffer,
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
        appBar: AppBar(
          centerTitle: true,
          title: const Text(ZachranObedStrings.offer),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 15),
                Row(
                  children: const <Widget>[
                    Text(
                      ZachranObedStrings.offerLeftoverFood,
                      style: TextStyle(fontSize: 24),
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
                      ZachranObedButton(
                        text: ZachranObedStrings.addAnotherFood,
                        icon: MaterialSymbols.add,
                        isSecondary: true,
                        onPressed: () {
                          setState(() => _foodSections.add(FoodInfo()));
                        },
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: const [
                          Text(
                            ZachranObedStrings.summaryInfo,
                            style: TextStyle(fontSize: 22),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      ZachranObedDropdown(
                        hintText: ZachranObedStrings.packaging,
                        items: _packagingOptions,
                        onValidation: (val) => val == null
                            ? ZachranObedStrings.requiredDropdownError
                            : null,
                        onChanged: (String value) => _selectedPackaging = value,
                      ),
                      const SizedBox(height: 30),
                      ZachranObedDateTimePicker(
                        text: ZachranObedStrings.consumeBy,
                        icon: MaterialSymbols.calendar_today,
                        controller: _consumeByController,
                        onValidation: (val) => val!.isEmpty
                            ? ZachranObedStrings.requiredFieldError
                            : null,
                      ),
                      const SizedBox(height: 30),
                      ZachranObedButton(
                        text: ZachranObedStrings.offerFood,
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
                      const SizedBox(height: 15),
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
