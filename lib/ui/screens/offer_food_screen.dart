import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:zachranobed/ui/widgets/text_field.dart';

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

  final List<FoodInfo> _formSections = [FoodInfo()];

  @override
  void dispose() {
    _consumeByController.dispose();
    super.dispose();
  }

  bool _somethingIsFilled() {
    if (_consumeByController.text.isNotEmpty || _selectedPackaging != '') {
      return true;
    }
    return _formSections.any((foodInfo) =>
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
                const SizedBox(height: 10),
                Row(
                  children: const <Widget>[
                    Text(
                      ZachranObedStrings.offerLeftoverFood,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(ZachranObedStrings.offerFoodDescription),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _formSections.length,
                        itemBuilder: (context, index) {
                          return _buildFoodSection(_formSections[index], index);
                        },
                      ),
                      ZachranObedButton(
                        text: ZachranObedStrings.addAnotherFood.toUpperCase(),
                        onPressed: () {
                          setState(() => _formSections.add(FoodInfo()));
                        },
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
                        controller: _consumeByController,
                        onValidation: (val) => val!.isEmpty
                            ? ZachranObedStrings.requiredFieldError
                            : null,
                      ),
                      const SizedBox(height: 30),
                      ZachranObedButton(
                        text: ZachranObedStrings.offerFood.toUpperCase(),
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

  Widget _buildFoodSection(FoodInfo foodInfo, int index) {
    return Column(
      key: ValueKey(foodInfo),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pokrm ${index + 1}',
              style: const TextStyle(fontSize: 18),
            ),
            if (index != 0) _removeButton(foodInfo),
          ],
        ),
        const SizedBox(height: 30),
        ZachranObedTextField(
          text: ZachranObedStrings.foodName,
          onValidation: (val) =>
              val!.isEmpty ? ZachranObedStrings.requiredFieldError : null,
          onChanged: (val) => foodInfo.name = val,
          value: foodInfo.name,
        ),
        const SizedBox(height: 30),
        ZachranObedTextField(
          text: ZachranObedStrings.allergens,
          onValidation: (val) =>
              val!.isEmpty ? ZachranObedStrings.requiredFieldError : null,
          onChanged: (val) => foodInfo.allergens = val,
          value: foodInfo.allergens,
        ),
        const SizedBox(height: 30),
        ZachranObedTextField(
          text: ZachranObedStrings.numberOfServings,
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
          textInputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (val) =>
              foodInfo.numberOfServings = val.isEmpty ? null : int.parse(val),
          value: foodInfo.numberOfServings?.toString(),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Future<Response> _offerFood() {
    var response = null;
    for (var foodInfo in _formSections) {
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

  Widget _removeButton(FoodInfo foodInfo) {
    return InkWell(
      onTap: () {
        setState(() {
          _formSections.remove(foodInfo);
        });
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}
