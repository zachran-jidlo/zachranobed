import 'package:flutter/material.dart';
import 'package:zachranobed/constants.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/dropdown.dart';
import 'package:zachranobed/ui/widgets/textField.dart';

class OfferFoodScreen extends StatefulWidget {
  const OfferFoodScreen({Key? key}) : super(key: key);

  @override
  State<OfferFoodScreen> createState() => _OfferFoodScreenState();
}

class _OfferFoodScreenState extends State<OfferFoodScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController foodNameController = TextEditingController();
  TextEditingController allergensController = TextEditingController();
  TextEditingController servingsNumberController = TextEditingController();
  TextEditingController packagingController = TextEditingController();
  TextEditingController consumeByController = TextEditingController();

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
                      controller: foodNameController,
                      onValidation: (val) => val!.isEmpty ? ZachranObedStrings.requiredFieldError : null,
                    ),
                    const SizedBox(height: 15),

                    ZachranObedTextField(
                      text: "Alergeny",
                      controller: allergensController,
                      onValidation: (val) => val!.isEmpty ? ZachranObedStrings.requiredFieldError : null,
                    ),
                    const SizedBox(height: 15),

                    ZachranObedTextField(
                      text: "Počet porcí",
                      controller: servingsNumberController,
                      onValidation: (val) => val!.isEmpty ? ZachranObedStrings.requiredFieldError : null,
                    ),
                    const SizedBox(height: 15),

                    ZachranObedDropdown(
                      hintText: "Balení",
                      items: _packagingOptions,
                      onValidation: (val) => val == null ? ZachranObedStrings.requiredDropdownError : null,
                    ),
                    const SizedBox(height: 15),

                    ZachranObedTextField(
                      text: "Spotřebujte do",
                      controller: consumeByController,
                      onValidation: (val) => val!.isEmpty ? ZachranObedStrings.requiredFieldError : null,
                    ),
                    const SizedBox(height: 15),

                    ZachranObedButton(
                      text: "NABÍDNOUT POKRM",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print("Odesalt nabídku");
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
