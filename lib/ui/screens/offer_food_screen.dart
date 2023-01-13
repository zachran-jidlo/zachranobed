import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zachranobed/constants.dart';
import 'package:zachranobed/models/offered_food.dart';
import 'package:zachranobed/routes.dart';
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
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _allergensController = TextEditingController();
  final TextEditingController _servingsNumberController = TextEditingController();
  final TextEditingController _consumeByController = TextEditingController();

  String _selectedPackaging = "";

  final List<String> _packagingOptions = <String>['REkrabička', 'Jednorázový obal'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(ZachranObedStrings.offer),
        leading: BackButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => ZachranObedDialog(
              title: ZachranObedStrings.endOffer,
              confirmText: ZachranObedStrings.cancelTheOffer,
              cancelText: ZachranObedStrings.continueTheOffer,
              onConfirmPressed: () {
                Navigator.of(context).pop('Confirm action');
                Navigator.of(context).pop('Perform the action');
              },
              onCancelPressed: () => Navigator.of(context).pop('Cancel action'),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: const [
                  Text(
                    ZachranObedStrings.offerWarmFood,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
                  ),
                ],
              ),
              const SizedBox(height: 10),

              const Text(ZachranObedStrings.offerFoodDescription),
              const SizedBox(height: 20),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    ZachranObedTextField(
                      text: ZachranObedStrings.foodName,
                      controller: _foodNameController,
                      onValidation: (val) => val!.isEmpty ? ZachranObedStrings.requiredFieldError : null,
                    ),
                    const SizedBox(height: 15),

                    ZachranObedTextField(
                      text: ZachranObedStrings.allergens,
                      controller: _allergensController,
                      onValidation: (val) => val!.isEmpty ? ZachranObedStrings.requiredFieldError : null,
                    ),
                    const SizedBox(height: 15),

                    ZachranObedTextField(
                      text: ZachranObedStrings.numberOfServings,
                      controller: _servingsNumberController,
                      onValidation: (val) => val!.isEmpty ? ZachranObedStrings.requiredFieldError : null,
                      inputType: TextInputType.number,
                      textInputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 20),

                    ZachranObedButton(
                      text: ZachranObedStrings.addAnotherFood.toUpperCase(),
                      onPressed: () {
                        print("Kliknuto na přidat další pokrm");
                      },
                    ),
                    const SizedBox(height: 20),

                    ZachranObedDropdown(
                      hintText: ZachranObedStrings.packaging,
                      items: _packagingOptions,
                      onValidation: (val) => val == null ? ZachranObedStrings.requiredDropdownError : null,
                      onChanged: (String value) {
                        _selectedPackaging = value;
                        print(_selectedPackaging);
                      },
                    ),
                    const SizedBox(height: 15),

                    ZachranObedDateTimePicker(
                      text: ZachranObedStrings.consumeBy,
                      controller: _consumeByController,
                      onValidation: (val) => val!.isEmpty ? ZachranObedStrings.requiredFieldError : null,
                    ),
                    const SizedBox(height: 15),

                    ZachranObedButton(
                      text: ZachranObedStrings.offerFood.toUpperCase(),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print("Nabídka odeslána");
                          OfferedFood offeredFood = OfferedFood(
                              date: DateTime.now(),
                              name: _foodNameController.text,
                              allergens: _allergensController.text,
                              numberOfServings: int.parse(_servingsNumberController.text),
                              packaging: _selectedPackaging,
                              consumeBy: _consumeByController.text
                          );
                          print("Nabídka - datum vytvoření: ${offeredFood.date}, název pokrmu: ${offeredFood.name}, alergeny: ${offeredFood.allergens}, počet porcí: ${offeredFood.numberOfServings}, balení: ${offeredFood.packaging}, spotřebujte do: ${offeredFood.consumeBy}");
                          Navigator.of(context).pushReplacementNamed(RouteManager.thankYou);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
