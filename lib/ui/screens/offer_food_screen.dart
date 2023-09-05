import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:zachranobed/enums/packaging.dart';
import 'package:zachranobed/extensions/build_context_extensions.dart';
import 'package:zachranobed/models/canteen.dart';
import 'package:zachranobed/models/food_info.dart';
import 'package:zachranobed/models/offered_food.dart';
import 'package:zachranobed/routes/app_router.gr.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/services/offered_food_service.dart';
import 'package:zachranobed/shared/constants.dart';
import 'package:zachranobed/ui/widgets/button.dart';
import 'package:zachranobed/ui/widgets/clickable_text.dart';
import 'package:zachranobed/ui/widgets/date_time_picker.dart';
import 'package:zachranobed/ui/widgets/dialog.dart';
import 'package:zachranobed/ui/widgets/dropdown.dart';
import 'package:zachranobed/ui/widgets/food_section_text_fields.dart';

@RoutePage()
class OfferFoodScreen extends StatefulWidget {
  const OfferFoodScreen({super.key});

  @override
  State<OfferFoodScreen> createState() => _OfferFoodScreenState();
}

class _OfferFoodScreenState extends State<OfferFoodScreen> {
  final _offeredFoodService = GetIt.I<OfferedFoodService>();

  DocumentReference<OfferedFood>? _futureResponse;

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
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      FoodSectionTextFields(
                        foodSections: _foodSections,
                      ),
                      ZOButton(
                        text: context.l10n!.addAnotherFood,
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
                            context.l10n!.summaryInfo,
                            style: const TextStyle(fontSize: FontSize.m),
                          ),
                        ],
                      ),
                      _buildGap(),
                      ZODropdown(
                        hintText: context.l10n!.packaging,
                        items: Packaging.values
                            .map((e) => PackagingHelper.toValue(e, context))
                            .toList(),
                        onValidation: (val) => val == null
                            ? context.l10n!.requiredDropdownError
                            : null,
                        onChanged: (value) => _selectedPackaging = value,
                      ),
                      _buildGap(),
                      ZODateTimePicker(
                        label: context.l10n!.consumeBy,
                        icon: MaterialSymbols.calendar_today,
                        controller: _consumeByController,
                        onValidation: (val) => val!.isEmpty
                            ? context.l10n!.requiredFieldError
                            : null,
                      ),
                      const SizedBox(height: GapSize.xl),
                      ZOButton(
                        text: context.l10n!.offerFood,
                        icon: MaterialSymbols.check,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _futureResponse = await _offerFood();
                            if (mounted) {
                              context.router.replace(
                                  ThankYouRoute(response: _futureResponse));
                            }
                          }
                        },
                      ),
                      const SizedBox(height: GapSize.s),
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

  Widget _buildGap() {
    return const SizedBox(height: GapSize.l);
  }

  Future<DocumentReference<OfferedFood>> _offerFood() async {
    var response = null;
    final donor = HelperService.getCurrentUser(context) as Canteen;
    final now = DateTime.now();
    final consumeBy =
        DateFormat('dd.MM.y HH:mm').parse(_consumeByController.text);
    for (var foodInfo in _foodSections) {
      response = await _offeredFoodService.createOffer(
        OfferedFood(
          id: "",
          date: now,
          dateTimestamp: now.millisecondsSinceEpoch ~/ 1000,
          foodInfo: FoodInfo(
            dishName: foodInfo.dishName,
            allergens: foodInfo.allergens,
            numberOfServings: foodInfo.numberOfServings,
          ),
          packaging: _selectedPackaging,
          consumeBy: consumeBy,
          consumeByTimestamp: consumeBy.millisecondsSinceEpoch ~/ 1000,
          weekNumber:
              '${DateTime.now().year}-${HelperService.getCurrentWeekNumber}',
          donorId: donor.establishmentId,
          recipientId: donor.recipient!.establishmentId,
        ),
      );
    }
    return response;
  }
}
