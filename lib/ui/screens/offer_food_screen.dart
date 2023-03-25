import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:zachranobed/routes.dart';
import 'package:zachranobed/services/api/offered_food_api_service.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/date_time_picker.dart';
import 'package:zachranobed/ui/widgets/dialog.dart';
import 'package:zachranobed/ui/widgets/dropdown.dart';
import 'package:zachranobed/ui/widgets/text_field.dart';

class OfferFoodScreen extends StatefulWidget {
  const OfferFoodScreen({Key? key}) : super(key: key);

  @override
  State<OfferFoodScreen> createState() => _OfferFoodScreenState();
}

class _OfferFoodScreenState extends State<OfferFoodScreen> {
  Future<http.Response>? _futureResponse;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _allergensController = TextEditingController();
  final TextEditingController _servingsNumberController =
      TextEditingController();
  final TextEditingController _consumeByController = TextEditingController();

  String _selectedPackaging = '';

  final List<String> _packagingOptions = <String>[
    'REkrabička',
    'Jednorázový obal'
  ];

  @override
  void dispose() {
    _foodNameController.dispose();
    _allergensController.dispose();
    _servingsNumberController.dispose();
    _consumeByController.dispose();
    super.dispose();
  }

  bool _somethingIsFilled() {
    if (_foodNameController.text.isNotEmpty ||
        _allergensController.text.isNotEmpty ||
        _servingsNumberController.text.isNotEmpty ||
        _consumeByController.text.isNotEmpty ||
        _selectedPackaging != '') {
      return true;
    }
    return false;
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
                const SizedBox(height: 10),
                Row(
                  children: const <Widget>[
                    Text(ZachranObedStrings.offerLeftoverFood,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(ZachranObedStrings.offerFoodDescription),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      ZachranObedTextField(
                        text: ZachranObedStrings.foodName,
                        controller: _foodNameController,
                        onValidation: (val) => val!.isEmpty
                            ? ZachranObedStrings.requiredFieldError
                            : null,
                      ),
                      const SizedBox(height: 15),
                      ZachranObedTextField(
                        text: ZachranObedStrings.allergens,
                        controller: _allergensController,
                        onValidation: (val) => val!.isEmpty
                            ? ZachranObedStrings.requiredFieldError
                            : null,
                      ),
                      const SizedBox(height: 15),
                      ZachranObedTextField(
                        text: ZachranObedStrings.numberOfServings,
                        controller: _servingsNumberController,
                        onValidation: (val) {
                          if (val!.isEmpty) {
                            return ZachranObedStrings.requiredFieldError;
                          }
                          int? validNumber = int.tryParse(val);
                          if (validNumber == null) {
                            return ZachranObedStrings.invalidNumberError;
                          }
                          return null;
                        },
                        inputType: TextInputType.number,
                        textInputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      const SizedBox(height: 20),
                      ZachranObedButton(
                        text: ZachranObedStrings.addAnotherFood.toUpperCase(),
                        onPressed: () {
                          print('Kliknuto na přidat další pokrm');
                        },
                      ),
                      const SizedBox(height: 20),
                      ZachranObedDropdown(
                        hintText: ZachranObedStrings.packaging,
                        items: _packagingOptions,
                        onValidation: (val) => val == null
                            ? ZachranObedStrings.requiredDropdownError
                            : null,
                        onChanged: (String value) {
                          _selectedPackaging = value;
                        },
                      ),
                      const SizedBox(height: 15),
                      ZachranObedDateTimePicker(
                        text: ZachranObedStrings.consumeBy,
                        controller: _consumeByController,
                        onValidation: (val) => val!.isEmpty
                            ? ZachranObedStrings.requiredFieldError
                            : null,
                      ),
                      const SizedBox(height: 15),
                      ZachranObedButton(
                        text: ZachranObedStrings.offerFood.toUpperCase(),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _futureResponse = OfferedFoodApiService()
                                .createOffer(
                                    const Uuid().v4(),
                                    DateTime.now(),
                                    _foodNameController.text,
                                    _allergensController.text,
                                    int.parse(_servingsNumberController.text),
                                    _selectedPackaging,
                                    DateFormat('dd.MM.y HH:mm')
                                        .parse(_consumeByController.text),
                                    HelperService.getCurrentUser(context)!
                                        .internalId);
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
}
