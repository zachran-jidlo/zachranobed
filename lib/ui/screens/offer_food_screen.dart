import 'package:flutter/material.dart';
import 'package:zachranobed/constants.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/date_time_picker.dart';
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

  final List<String> _packagingOptions = <String>['REkrabička', 'Jednorázový obal'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(ZachranObedStrings.offer),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Nabídnout teplý pokrm",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Text("Pokrm nabídnete darem charitativním organizacím, které jej předají lidem v nouzi."),
              const SizedBox(height: 20),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    ZachranObedTextField(
                      text: "Název pokrmu",
                      controller: _foodNameController,
                      onValidation: (val) => val!.isEmpty ? ZachranObedStrings.requiredFieldError : null,
                      inputType: TextInputType.text,
                    ),
                    const SizedBox(height: 15),

                    ZachranObedTextField(
                      text: "Alergeny",
                      controller: _allergensController,
                      onValidation: (val) => val!.isEmpty ? ZachranObedStrings.requiredFieldError : null,
                      inputType: TextInputType.text,
                    ),
                    const SizedBox(height: 15),

                    ZachranObedTextField(
                      text: "Počet porcí",
                      controller: _servingsNumberController,
                      onValidation: (val) => val!.isEmpty ? ZachranObedStrings.requiredFieldError : null,
                      inputType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),

                    ZachranObedButton(
                      text: "PŘIDAT DALŠÍ POKRM",
                      onPressed: () {
                        print("Kliknuto na přidat další pokrm");
                      },
                    ),
                    const SizedBox(height: 20),

                    ZachranObedDropdown(
                      hintText: "Balení",
                      items: _packagingOptions,
                      onValidation: (val) => val == null ? ZachranObedStrings.requiredDropdownError : null,
                    ),
                    const SizedBox(height: 15),

                    ZachranObedDateTimePicker(
                      text: "Spotřebujte do",
                      controller: _consumeByController,
                      onValidation: (val) => val!.isEmpty ? ZachranObedStrings.requiredFieldError : null,
                    ),
                    const SizedBox(height: 15),

                    ZachranObedButton(
                      text: "NABÍDNOUT POKRM",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print("Nabídka odeslána");
                          Navigator.of(context).pop();
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
